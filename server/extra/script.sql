CREATE SCHEMA IF NOT EXISTS "public";

CREATE TABLE "public".unit ( 
	unit varchar(15) NOT NULL,
	CONSTRAINT pk_unit PRIMARY KEY ( unit )
);

CREATE TABLE "public".unit_conversion ( 
	from_unit varchar(15) NOT NULL NOT NULL,
	to_unit varchar(15) NOT NULL NOT NULL,
	"value" double precision NOT NULL,
	CONSTRAINT pk_unit_conversion PRIMARY KEY (from_unit, to_unit),
	CONSTRAINT fk_unit_conversion_from_unit FOREIGN KEY (from_unit) REFERENCES "public".unit(unit),
	CONSTRAINT fk_unit_conversion_to_unit FOREIGN KEY (to_unit) REFERENCES "public".unit(unit)
);

CREATE TABLE "public".method (
	"method" char(4) NOT NULL,
	CONSTRAINT pk_method PRIMARY KEY (method)
);

CREATE TABLE "public".article ( 
	article_code varchar(15) NOT NULL,
	name varchar(100) NOT NULL,
	default_unit varchar(15) NOT NULL,
	"method" char(4) NOT NULL,
	CONSTRAINT pk_article PRIMARY KEY (article_code),
	CONSTRAINT fk_article_unit FOREIGN KEY (default_unit) REFERENCES "public".unit(unit),
	CONSTRAINT fk_article_method FOREIGN KEY (method) REFERENCES "public".method(method)
);

CREATE TABLE "public".article_valid_unit ( 
	article_code varchar(15) NOT NULL,
	unit varchar(15) NOT NULL,
	CONSTRAINT pk_article_valid_unit PRIMARY KEY (article_code, unit),
	CONSTRAINT fk_article_valid_unit_article FOREIGN KEY (article_code) REFERENCES "public".article(article_code),
	CONSTRAINT fk_article_valid_unit_unit FOREIGN KEY (unit) REFERENCES "public".unit(unit)
);

CREATE TABLE "public".store (
	store_code varchar(15),
    location varchar(50) NOT NULL,
	CONSTRAINT pk_store PRIMARY KEY (store_code)
);

CREATE TABLE "public".validated_stock_transaction ( 
	id serial NOT NULL,
    source_id integer, -- NULL for entry movements
	action_date TIMESTAMP NOT NULL,
	action_type varchar(3) NOT NULL,
    store_code varchar(15) NOT NULL,
	article_code varchar(15) NOT NULL,
	quantity double precision NOT NULL,
	unit_price double precision, -- NULL for stock outflows
	CONSTRAINT pk_validated_stock_transaction PRIMARY KEY (id),
	CONSTRAINT fk_validated_stock_transaction_source FOREIGN KEY (source_id) REFERENCES "public".validated_stock_transaction(id),
	CONSTRAINT fk_validated_stock_transaction_store FOREIGN KEY (store_code) REFERENCES "public".store(store_code),
	CONSTRAINT fk_validated_stock_transaction_article FOREIGN KEY (article_code) REFERENCES "public".article(article_code),
	CONSTRAINT cns_validated_stock_transaction_type CHECK (action_type IN ('IN', 'OUT')),
	CONSTRAINT cns_validated_stock_transaction_qte CHECK ( quantity > 0 )
);

CREATE TABLE "public".pending_movement ( 
	id serial NOT NULL,
	action_type varchar(3) NOT NULL,
    store_code varchar(15) NOT NULL,
	article_code varchar(15) NOT NULL,
	action_date TIMESTAMP NOT NULL,
	quantity double precision NOT NULL,
	unit_price double precision, -- NULL for stock outflows
    validation_date TIMESTAMP, -- Default NULL
    status INTEGER NOT NULL DEFAULT 0, -- 0: pending, 10: validated, ...
	CONSTRAINT pk_pending_movement PRIMARY KEY (id),
	CONSTRAINT fk_pending_movement_store FOREIGN KEY (store_code) REFERENCES "public".store(store_code),
	CONSTRAINT fk_pending_movement_article FOREIGN KEY (article_code) REFERENCES "public".article(article_code),
	CONSTRAINT cns_pending_movement_type CHECK (action_type IN ('IN', 'OUT')),
	CONSTRAINT cns_pending_movement_qte CHECK ( quantity > 0 )
);


-- IN
CREATE VIEW entry_stock_movement AS
SELECT
    validated_stock_transaction.id,
    validated_stock_transaction.action_date,
    validated_stock_transaction.store_code,
    validated_stock_transaction.article_code,
    SUM(validated_stock_transaction.quantity) AS total_quantity,
    validated_stock_transaction.unit_price,
    SUM(validated_stock_transaction.quantity * validated_stock_transaction.unit_price) AS total_price
FROM validated_stock_transaction
WHERE 
    validated_stock_transaction.action_type = 'IN'
GROUP BY
    validated_stock_transaction.id,
    validated_stock_transaction.action_date,
    validated_stock_transaction.store_code,
    validated_stock_transaction.article_code,
    validated_stock_transaction.unit_price
ORDER BY
    validated_stock_transaction.action_date ASC
;
CREATE OR REPLACE FUNCTION get_entry_stock_movement_summary(
    start_date DATE,
    end_date DATE,
    store_pattern VARCHAR,
    article_pattern VARCHAR
)
RETURNS TABLE (
    store_code VARCHAR,
    article_code VARCHAR,
    total_quantity DOUBLE PRECISION,
    unit_price DOUBLE PRECISION,
    total_price DOUBLE PRECISION
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        entry_stock_movement.store_code, 
        entry_stock_movement.article_code, 
        SUM(entry_stock_movement.total_quantity) AS total_quantity, 
        entry_stock_movement.unit_price,
        SUM(entry_stock_movement.total_quantity * entry_stock_movement.unit_price) AS total_price
    FROM entry_stock_movement
    WHERE 
        entry_stock_movement.action_date BETWEEN start_date AND end_date 
        AND entry_stock_movement.store_code LIKE store_pattern
        AND entry_stock_movement.article_code LIKE article_pattern
    GROUP BY 
        entry_stock_movement.store_code, 
        entry_stock_movement.article_code, 
        entry_stock_movement.unit_price;
END;
$$ LANGUAGE plpgsql
;


-- OUT
CREATE VIEW stock_outflow AS
SELECT 
    validated_stock_transaction.id,
    validated_stock_transaction.action_date,
    validated_stock_transaction.source_id,
    validated_stock_transaction.store_code,
    validated_stock_transaction.article_code,
    SUM(validated_stock_transaction.quantity) AS total_quantity
FROM validated_stock_transaction
WHERE 
    validated_stock_transaction.action_type = 'OUT'
GROUP BY
    validated_stock_transaction.id,
    validated_stock_transaction.action_date,
    validated_stock_transaction.source_id,
    validated_stock_transaction.store_code,
    validated_stock_transaction.article_code,
    validated_stock_transaction.unit_price
ORDER BY
    validated_stock_transaction.action_date ASC
;
CREATE OR REPLACE FUNCTION get_stock_outflow_summary(
    start_date DATE,
    end_date DATE,
    store_pattern VARCHAR,
    article_pattern VARCHAR
)
RETURNS TABLE (
    store_code VARCHAR,
    article_code VARCHAR,
    total_quantity DOUBLE PRECISION
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        stock_outflow.store_code, 
        stock_outflow.article_code, 
        SUM(stock_outflow.total_quantity) AS total_quantity
    FROM stock_outflow
    WHERE 
        stock_outflow.action_date BETWEEN start_date AND end_date 
        AND stock_outflow.store_code LIKE store_pattern
        AND stock_outflow.article_code LIKE article_pattern
    GROUP BY 
        stock_outflow.store_code, 
        stock_outflow.article_code;
END;
$$ LANGUAGE plpgsql
;


-- STATE
CREATE OR REPLACE FUNCTION get_stock_state(
    from_date DATE,
    store_pattern VARCHAR,
    article_pattern VARCHAR
)
RETURNS TABLE (
    store_code VARCHAR,
    article_code VARCHAR,
    remaining_quantity DOUBLE PRECISION,
    average_unit_price DOUBLE PRECISION,
    total_price DOUBLE PRECISION
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        remaining_stock_per_movement.store_code,
        remaining_stock_per_movement.article_code,
        SUM(remaining_stock_per_movement.remaining_quantity) AS remaining_quantity,
        (SUM(remaining_stock_per_movement.total_price_value) / SUM(remaining_stock_per_movement.remaining_quantity)) AS average_unit_price,
        SUM(remaining_stock_per_movement.total_price_value) AS total_price
    FROM (
        SELECT
            IN_MOVEMENT.id,
            IN_MOVEMENT.action_date,
            IN_MOVEMENT.store_code,
            IN_MOVEMENT.article_code,
            IN_MOVEMENT.unit_price,
            (IN_MOVEMENT.total_quantity - COALESCE(SUM(OUT_MOVEMENT.total_quantity), 0)) AS remaining_quantity,
            ((IN_MOVEMENT.total_quantity - COALESCE(SUM(OUT_MOVEMENT.total_quantity), 0)) * IN_MOVEMENT.unit_price) AS total_price_value
        FROM entry_stock_movement AS IN_MOVEMENT
        LEFT JOIN stock_outflow AS OUT_MOVEMENT
            ON OUT_MOVEMENT.source_id = IN_MOVEMENT.id
            AND OUT_MOVEMENT.action_date <= from_date
        WHERE 
            IN_MOVEMENT.action_date <= from_date
        GROUP BY
            IN_MOVEMENT.id,
            IN_MOVEMENT.action_date,
            IN_MOVEMENT.store_code,
            IN_MOVEMENT.article_code,
            IN_MOVEMENT.unit_price,
            IN_MOVEMENT.total_quantity
        ORDER BY
            IN_MOVEMENT.action_date ASC
        ) 
        AS remaining_stock_per_movement
    WHERE 
        remaining_stock_per_movement.store_code LIKE store_pattern
        AND remaining_stock_per_movement.article_code LIKE article_pattern
    GROUP BY
        remaining_stock_per_movement.store_code,
        remaining_stock_per_movement.article_code;
END;
$$ LANGUAGE plpgsql
;

CREATE OR REPLACE FUNCTION stock_state(
    start_date DATE,
    end_date DATE,
    store_pattern VARCHAR,
    article_pattern VARCHAR
)
RETURNS TABLE (
    store_code VARCHAR,
    article_code VARCHAR,
    initial_stock DOUBLE PRECISION,
    remaining_stock DOUBLE PRECISION,
    average_unit_price DOUBLE PRECISION,
    total_price DOUBLE PRECISION
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        COALESCE(final_stock_state.store_code, initial_stock_state.store_code),
        COALESCE(final_stock_state.article_code, initial_stock_state.article_code),
        COALESCE(initial_stock_state.remaining_quantity, 0) AS initial_stock,
        COALESCE(
            final_stock_state.remaining_quantity, 
            initial_stock_state.remaining_quantity
        ) AS remaining_stock,
        COALESCE(
            (
                COALESCE(
                    final_stock_state.total_price_value / final_stock_state.remaining_quantity, 
                    initial_stock_state.total_price / initial_stock_state.remaining_quantity
                ) 
            ),
            0
        ) AS average_unit_price,
        COALESCE(final_stock_state.total_price_value, 0) AS total_price
    FROM get_stock_state(start_date, store_pattern, article_pattern) AS initial_stock_state
    FULL JOIN (
        SELECT
            remaining_stock_per_movement.store_code,
            remaining_stock_per_movement.article_code,
            SUM(remaining_stock_per_movement.remaining_quantity) AS remaining_quantity,
            SUM(remaining_stock_per_movement.total_price_value) AS total_price_value
        FROM (
            SELECT
                IN_MOVEMENT.id,
                IN_MOVEMENT.action_date,
                IN_MOVEMENT.store_code,
                IN_MOVEMENT.article_code,
                IN_MOVEMENT.unit_price,
                (IN_MOVEMENT.total_quantity - COALESCE(SUM(OUT_MOVEMENT.total_quantity), 0)) AS remaining_quantity,
                ((IN_MOVEMENT.total_quantity - COALESCE(SUM(OUT_MOVEMENT.total_quantity), 0)) * IN_MOVEMENT.unit_price) AS total_price_value
            FROM entry_stock_movement AS IN_MOVEMENT
            LEFT JOIN stock_outflow AS OUT_MOVEMENT
                ON OUT_MOVEMENT.source_id = IN_MOVEMENT.id
                AND OUT_MOVEMENT.action_date >= start_date
                AND OUT_MOVEMENT.action_date <= end_date
            WHERE
                IN_MOVEMENT.action_date > start_date
                AND IN_MOVEMENT.action_date <= end_date
            GROUP BY
                IN_MOVEMENT.id,
                IN_MOVEMENT.action_date,
                IN_MOVEMENT.store_code,
                IN_MOVEMENT.article_code,
                IN_MOVEMENT.unit_price,
                IN_MOVEMENT.total_quantity
            ORDER BY
                IN_MOVEMENT.action_date ASC
        ) AS remaining_stock_per_movement
        GROUP BY
            remaining_stock_per_movement.store_code,
            remaining_stock_per_movement.article_code
    ) AS final_stock_state
    ON initial_stock_state.store_code = final_stock_state.store_code
        AND initial_stock_state.article_code = final_stock_state.article_code;

END;
$$ LANGUAGE plpgsql
;

CREATE OR REPLACE FUNCTION stock_state_alt(
    start_date DATE,
    end_date DATE,
    store_pattern VARCHAR,
    article_pattern VARCHAR
)
RETURNS TABLE (
    store_code VARCHAR,
    article_code VARCHAR,
    initial_stock DOUBLE PRECISION,
    remaining_stock DOUBLE PRECISION,
    average_unit_price DOUBLE PRECISION,
    total_price DOUBLE PRECISION
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(final_stock_state.store_code, initial_stock_state.store_code),
        COALESCE(final_stock_state.article_code, initial_stock_state.article_code),
        COALESCE(initial_stock_state.remaining_quantity, 0) AS initial_stock,
        COALESCE(
            final_stock_state.remaining_quantity, 
            initial_stock_state.remaining_quantity
        ) AS remaining_stock,
        COALESCE(
            (
                COALESCE(
                    final_stock_state.total_price, 
                    initial_stock_state.total_price
                ) 
                / 
                COALESCE(
                    final_stock_state.remaining_quantity,
                    initial_stock_state.remaining_quantity
                )
            ),
            0
        ) AS average_unit_price,
        COALESCE(final_stock_state.total_price, 0) AS total_price
    FROM get_stock_state(start_date, store_pattern, article_pattern) AS initial_stock_state
    LEFT JOIN get_stock_state(end_date, store_pattern, article_pattern) AS final_stock_state
    ON initial_stock_state.store_code = final_stock_state.store_code
        AND initial_stock_state.article_code = final_stock_state.article_code;

END;
$$ LANGUAGE plpgsql
;
-- CREATE VIEW remaining_stock_per_movement AS
-- SELECT
--     IN_MOVEMENT.id,
--     IN_MOVEMENT.action_date,
--     IN_MOVEMENT.store_code,
--     IN_MOVEMENT.article_code,
--     IN_MOVEMENT.unit_price,
--     (IN_MOVEMENT.total_quantity - COALESCE(SUM(OUT_MOVEMENT.total_quantity), 0)) AS remaining_quantity
-- FROM entry_stock_movement AS IN_MOVEMENT
-- LEFT JOIN stock_outflow AS OUT_MOVEMENT
-- ON OUT_MOVEMENT.source_id = IN_MOVEMENT.id
-- GROUP BY
--     IN_MOVEMENT.id,
--     IN_MOVEMENT.action_date,
--     IN_MOVEMENT.store_code,
--     IN_MOVEMENT.article_code,
--     IN_MOVEMENT.unit_price,
--     IN_MOVEMENT.total_quantity
-- ORDER BY
--     IN_MOVEMENT.action_date ASC
-- ;
-- CREATE VIEW remaining_stock AS
-- SELECT
--     remaining_stock_per_movement.store_code,
--     remaining_stock_per_movement.article_code,
--     SUM(remaining_stock_per_movement.remaining_quantity) AS remaining_quantity
-- FROM remaining_stock_per_movement
-- GROUP BY
--     remaining_stock_per_movement.store_code,
--     remaining_stock_per_movement.article_code
-- ;
-- CREATE OR REPLACE FUNCTION article_stock_state(
--     start_date DATE,
--     end_date DATE,
--     store_pattern VARCHAR,
--     article_pattern VARCHAR
-- )
-- RETURNS TABLE (
--     store_code VARCHAR,
--     article_code VARCHAR,
--     initial_stock DOUBLE PRECISION,
--     remaining_stock DOUBLE PRECISION,
--     avg_unit_price DOUBLE PRECISION,
--     total_price DOUBLE PRECISION
-- )
-- AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT 
--         stock_state_func.store_code, 
--         stock_state_func.article_code, 
--         SUM(stock_state_func.initial_stock) AS initial_stock, 
--         SUM(stock_state_func.remaining_stock) AS remaining_stock, 
--         (SUM(stock_state_func.remaining_stock * stock_state_func.unit_price) / SUM(stock_state_func.remaining_stock)) AS avg_unit_price,
--         SUM(stock_state_func.remaining_stock * stock_state_func.unit_price) AS total_price
--     FROM stock_state(start_date, end_date, store_pattern, article_pattern) AS stock_state_func
--     GROUP BY stock_state_func.store_code, stock_state_func.article_code;

-- END;
-- $$ LANGUAGE plpgsql
-- ;
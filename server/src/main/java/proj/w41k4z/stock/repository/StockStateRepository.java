package proj.w41k4z.stock.repository;

import java.sql.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import proj.w41k4z.stock.model.StockState;

public interface StockStateRepository extends JpaRepository<StockState, Integer> {

        @Query(value = "SELECT 1 AS temp_id, * FROM stock_state_alt(:date1, :date2, :store, :article)", nativeQuery = true)
        List<StockState> getStockState(@Param("date1") Date date1, @Param("date2") Date date2,
                        @Param("store") String store, @Param("article") String article);
}
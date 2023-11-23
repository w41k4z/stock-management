package proj.w41k4z.stock.model.movement;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Table;

@Entity
@Table(name = "pending_movement")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "action_type")
public abstract class PendingMovement extends StockMovement {

    @Column(name = "validation_date")
    private Timestamp validationDate;

    public Timestamp getValidationDate() {
        return validationDate;
    }

    public void setValidationDate(Timestamp validationDate) {
        this.validationDate = validationDate;
    }
}

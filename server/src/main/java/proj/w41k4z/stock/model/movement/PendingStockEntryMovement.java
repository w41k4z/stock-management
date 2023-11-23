package proj.w41k4z.stock.model.movement;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("IN")
public class PendingStockEntryMovement extends PendingMovement {

    @Column(name = "unit_price")
    private Double unitPrice;

    public Double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(Double unitPrice) {
        this.unitPrice = unitPrice;
    }

}

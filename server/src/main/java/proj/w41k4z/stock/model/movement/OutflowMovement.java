package proj.w41k4z.stock.model.movement;

import javax.persistence.Entity;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;

@Entity
@DiscriminatorValue("OUT")
public class OutflowMovement extends ValidatedStockTransaction {

    @Column(name = "source_id")
    private Long sourceId;

    public Long getSourceId() {
        return sourceId;
    }

    public void setSourceId(Long source) {
        this.sourceId = source;
    }
}

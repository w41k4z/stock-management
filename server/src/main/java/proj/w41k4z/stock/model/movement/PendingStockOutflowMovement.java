package proj.w41k4z.stock.model.movement;

import java.util.List;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("OUT")
public class PendingStockOutflowMovement extends PendingMovement {

    public List<OutflowMovement> pendingStockOutflowBreakdown() {
        return null;
    }
}

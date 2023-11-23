package proj.w41k4z.stock.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import proj.w41k4z.stock.model.movement.StockMovement;

public interface StockMovementRepository extends JpaRepository<StockMovement, Long> {

}

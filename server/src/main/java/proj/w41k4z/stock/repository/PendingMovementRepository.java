package proj.w41k4z.stock.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import proj.w41k4z.stock.model.movement.PendingMovement;

public interface PendingMovementRepository extends JpaRepository<PendingMovement, Long> {

}

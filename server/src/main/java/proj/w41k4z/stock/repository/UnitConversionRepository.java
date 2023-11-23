package proj.w41k4z.stock.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import proj.w41k4z.stock.embeddable.UnitConversionId;
import proj.w41k4z.stock.model.UnitConversion;

public interface UnitConversionRepository extends JpaRepository<UnitConversion, UnitConversionId> {
    public Optional<UnitConversion> findByUnitConversionId(UnitConversionId unitConversionId);
}
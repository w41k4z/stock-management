package proj.w41k4z.stock.service;

import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import proj.w41k4z.stock.embeddable.UnitConversionId;
import proj.w41k4z.stock.model.UnitConversion;
import proj.w41k4z.stock.repository.UnitConversionRepository;

@Service
public class UnitConversionService {
    @Autowired
    private UnitConversionRepository unitConversionRepository;

    @Autowired
    private UnitConversionId unitConversionId; // for the convert method

    public double convert(String from, String to, double value) {
        System.out.println(unitConversionId);
        unitConversionId.setFromUnit(from);
        unitConversionId.setToUnit(to);
        Optional<UnitConversion> optionalUnitConversion = unitConversionRepository
                .findByUnitConversionId(unitConversionId);
        if (optionalUnitConversion.isPresent()) {
            return value * optionalUnitConversion.get().getValue();
        }
        unitConversionId.setFromUnit(to);
        unitConversionId.setToUnit(from);
        optionalUnitConversion = unitConversionRepository
                .findByUnitConversionId(unitConversionId);
        if (optionalUnitConversion.isPresent()) {
            return value / optionalUnitConversion.get().getValue();
        }
        throw new NoSuchElementException("No unit conversion found for: " + value + " " + from + " -> " + to);
    }
}

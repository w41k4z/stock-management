package proj.w41k4z.stock.embeddable;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import org.springframework.stereotype.Component;

@Component
@Embeddable
public class UnitConversionId implements Serializable {
    @Column(name = "from_unit")
    private String fromUnit;

    @Column(name = "to_unit")
    private String toUnit;

    public String getFromUnit() {
        return fromUnit;
    }

    public UnitConversionId() {
    }

    public UnitConversionId(String fromUnit, String toUnit) {
        this.fromUnit = fromUnit;
        this.toUnit = toUnit;
    }

    public void setFromUnit(String fromUnit) {
        this.fromUnit = fromUnit;
    }

    public String getToUnit() {
        return toUnit;
    }

    public void setToUnit(String toUnit) {
        this.toUnit = toUnit;
    }
}

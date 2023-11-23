package proj.w41k4z.stock.model;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

import proj.w41k4z.stock.embeddable.UnitConversionId;

@Entity
@Table(name = "unit_conversion")
public class UnitConversion {
    @EmbeddedId
    private UnitConversionId unitConversionId;

    private Double value;

    public UnitConversionId getUnitConversionId() {
        return unitConversionId;
    }

    public void setUnitConversionId(UnitConversionId unitConversionId) {
        this.unitConversionId = unitConversionId;
    }

    public Double getValue() {
        return value;
    }

    public void setValue(Double value) {
        this.value = value;
    }
}

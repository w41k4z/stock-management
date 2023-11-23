package proj.w41k4z.stock.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

import org.springframework.data.annotation.Immutable;

@Entity
@Immutable
public class StockState {

    @Id // For JPA Identification control
    @Column(name = "temp_id")
    private Integer tempId;

    @Column(name = "store_code")
    private String storeCode;

    @Column(name = "article_code")
    private String articleCode;

    @Column(name = "initial_stock")
    private Double initialStock;

    @Column(name = "remaining_stock")
    private Double remainingStock;

    // Stock state only
    @Column(name = "unit_price")
    private Double unitPrice;

    // Article stock state only
    @Column(name = "avg_unit_price")
    private Double averageUnitPrice;

    @Column(name = "total_price")
    private Double totalPrice;

    public String getStoreCode() {
        return storeCode;
    }

    public void setStoreCode(String storeCode) {
        this.storeCode = storeCode;
    }

    public String getArticleCode() {
        return articleCode;
    }

    public void setArticleCode(String articleCode) {
        this.articleCode = articleCode;
    }

    public Double getInitialStock() {
        return initialStock;
    }

    public void setInitialStock(Double initialStock) {
        this.initialStock = initialStock;
    }

    public Double getRemainingStock() {
        return remainingStock;
    }

    public void setRemainingStock(Double remainingStock) {
        this.remainingStock = remainingStock;
    }

    public Double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(Double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public Double getAverageUnitPrice() {
        return averageUnitPrice;
    }

    public void setAverageUnitPrice(Double avgUP) {
        this.averageUnitPrice = avgUP;
    }

    public Double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

}

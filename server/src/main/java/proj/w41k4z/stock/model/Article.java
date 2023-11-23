package proj.w41k4z.stock.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "article", schema = "public")
public class Article {

    @Id
    @Column(name = "article_code")
    private String articleCode;

    @Column(name = "name", nullable = false)
    private String name;

    @OneToOne
    @JoinColumn(name = "default_unit", nullable = false)
    private Unit defaultUnit;

    @OneToMany
    @JoinTable(name = "article_valid_unit", joinColumns = @JoinColumn(name = "article_code"), inverseJoinColumns = @JoinColumn(name = "unit"))
    private List<Unit> validUnits;

    @Column
    private String method; // FIFO, LIFO

    public String getArticleCode() {
        return articleCode;
    }

    public void setArticleCode(String articleCode) {
        this.articleCode = articleCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Unit getDefaultUnit() {
        return defaultUnit;
    }

    public void setDefaultUnit(Unit defaultUnit) {
        this.defaultUnit = defaultUnit;
    }

    public List<Unit> getValidUnits() {
        return validUnits;
    }

    public void setValidUnits(List<Unit> validUnits) {
        this.validUnits = validUnits;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }
}
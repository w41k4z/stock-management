package proj.w41k4z.stock.model.movement;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

import proj.w41k4z.stock.model.Article;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class StockMovement {
    @Id
    private Long id;

    @OneToOne
    @JoinColumn(name = "article_code", nullable = false)
    private Article article;

    private Double quantity;

    @Column(name = "action_date")
    private Timestamp actionDate;

    public Long getId() {
        return id;
    }

    public void setId(Long stockMovementId) {
        this.id = stockMovementId;
    }

    public Article getArticle() {
        return article;
    }

    public void setArticle(Article article) {
        this.article = article;
    }

    public Double getQuantity() {
        return quantity;
    }

    public void setQuantity(Double quantity) {
        this.quantity = quantity;
    }

    public Timestamp getActionDate() {
        return actionDate;
    }

    public void setActionDate(Timestamp actionDate) {
        this.actionDate = actionDate;
    }
}

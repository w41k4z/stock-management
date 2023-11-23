package proj.w41k4z.stock.dto;

import java.io.Serializable;
import java.sql.Date;

public class StockStateCondition implements Serializable {

    private Date date1;
    private Date date2;
    private String store;
    private String article;

    public Date getDate1() {
        return date1;
    }

    public void setDate1(Date date1) {
        this.date1 = date1;
    }

    public Date getDate2() {
        return date2;
    }

    public void setDate2(Date date2) {
        this.date2 = date2;
    }

    public String getStore() {
        return store;
    }

    public void setStore(String store) {
        this.store = store;
    }

    public String getArticle() {
        return article;
    }

    public void setArticle(String article) {
        this.article = article;
    }

}

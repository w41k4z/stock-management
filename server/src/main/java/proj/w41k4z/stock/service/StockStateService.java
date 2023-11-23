package proj.w41k4z.stock.service;

import java.sql.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import proj.w41k4z.stock.model.StockState;
import proj.w41k4z.stock.repository.StockStateRepository;

@Service
public class StockStateService {

    @Autowired
    private StockStateRepository stockStateRepository;

    public List<StockState> getStockState(Date date1, Date date2, String store, String article) {
        return stockStateRepository.getStockState(date1, date2, store, article);
    }
}

package proj.w41k4z.stock.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import proj.w41k4z.stock.dto.StockStateCondition;
import proj.w41k4z.stock.model.StockState;
import proj.w41k4z.stock.service.StockStateService;

@RestController
@RequestMapping("/stock-states")
@CrossOrigin(origins = "http://localhost:3000")
public class StockStateController {

    @Autowired
    private StockStateService stockStateService;

    @GetMapping(path = "")
    public List<StockState> getStockState(@RequestBody StockStateCondition condition) {
        return stockStateService.getStockState(condition.getDate1(), condition.getDate2(), condition.getStore() + "%",
                condition.getArticle() + "%");
    }
}

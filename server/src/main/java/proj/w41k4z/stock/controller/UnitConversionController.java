package proj.w41k4z.stock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import proj.w41k4z.stock.service.UnitConversionService;

@RestController
@RequestMapping("/unit-conversions")
public class UnitConversionController {
    @Autowired
    private UnitConversionService unitConversionService;

    @GetMapping(path = "/convert/{from}/{to}/{value}")
    public double convert(@PathVariable String from, @PathVariable String to,
            @PathVariable double value) {
        return unitConversionService.convert(from, to, value);
    }
}

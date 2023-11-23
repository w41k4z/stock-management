package proj.w41k4z.stock.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import proj.w41k4z.stock.model.Article;
import proj.w41k4z.stock.service.ArticleService;

@RestController
@RequestMapping("/articles")
@CrossOrigin(origins = "http://localhost:3000")
public class ArticleController {
    @Autowired
    private ArticleService articleService;

    @GetMapping(path = "")
    public List<Article> fetch() {
        return articleService.getAll();
    }

    @GetMapping(path = "/{articleCode}")
    public Article fetchById(@PathVariable String articleCode) {
        return articleService.getByArticleCode(articleCode);
    }
}

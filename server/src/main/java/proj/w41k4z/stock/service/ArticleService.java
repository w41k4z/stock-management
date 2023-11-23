package proj.w41k4z.stock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import proj.w41k4z.stock.model.Article;
import proj.w41k4z.stock.repository.ArticleRepository;

@Service
public class ArticleService {
    @Autowired
    private ArticleRepository articleRepository;

    public List<Article> getAll() {
        return articleRepository.findAll();
    }

    public Article getByArticleCode(String article_code) {
        return articleRepository.findById(article_code).get();
    }
}

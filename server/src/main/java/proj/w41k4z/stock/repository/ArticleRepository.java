package proj.w41k4z.stock.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import proj.w41k4z.stock.model.Article;

public interface ArticleRepository extends JpaRepository<Article, String> {
}
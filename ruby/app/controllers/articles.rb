class ArticleController
  def create_article(article)
    article_not_exists = Article.where(title: article['title']).empty? #Article not exists impl reversed
    return { ok: false, msg: 'Article with given title already exists' } unless article_not_exists

    new_article = Article.new(:title => article['title'], :content => article['content'], :created_at => Time.now)
    new_article.save
    { ok: true, obj: article }
  rescue StandardError
    { ok: false }
  end

  def update_article(id, new_data)

    article = Article.where(id: id).first
    return { ok: false, msg: 'Article could not be found' } unless !article.nil?
    article.title = new_data['title']
    article.content = new_data['content']
    article.save #save_changes, not a method
    { ok: true, obj: article } #Obj = article
  rescue StandardError
    { ok: false }
  end

  def get_article(id)
    res = Article.where(:id => id).first #retrieve only one entry instead of list
    
    if !res.nil? #res.empty? check emptiness for single record, not list, correct condition 
      { ok: true, data: res }
    else
      { ok: false, msg: 'Article not found' }
    end
  rescue StandardError
    { ok: false }
  end

  def delete_article(_id)
    delete_count = 0#Article.delete(:id => id) Delete does not take the same parameters as where
    article = Article.where(:id => _id).first
    if !article.nil?
      article.destroy
      delete_count = delete_count + 1
    end
    if delete_count == 0
      { ok: false } #Change statement to return false
    else
      { ok: true, delete_count: delete_count }
    end
  end

  def get_batch
    res = Article.all
    if res.empty? || res.count != 3
      { ok: false, msg: 'Db is empty or has articles more or less than 3' }
    else
      { ok: true, data: res }
    end 
  rescue StandardError
    { ok: false }
  end
end

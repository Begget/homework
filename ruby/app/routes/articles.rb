require_relative '../controllers/articles'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @articleCtrl = ArticleController.new
  end

  before do
    content_type :json
  end

  get('/') do
    #summmary = @articleCtrl.get_batch
    summary = @articleCtrl.get_batch
    
    if (summary[:ok])
      'App working OK'
      status 200
      { articles: summary[:data] }.to_json  #Spellings of summary (3 m's)
    else
      { msg: 'Could not get articles.' }.to_json
    end
  end
  
  # new get for /2, and /99
  get('/:id') do
  summary = @articleCtrl.get_article(params[:id])
    
    if (summary[:ok])
      'App working OK'
      status 200
      { article: summary[:data] }.to_json  #Spellings of summary (3 m's)
    else
      { msg: 'Could not get article, out of index or does not exist.' }.to_json
    end
  end


  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.create_article(payload) #update_article(payload)
    if summary[:ok]
      { msg: 'Article created' }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    puts params[:id]
    summary = @articleCtrl.update_article(params[:id], payload)
    if summary[:ok]
      'App working OK'
      status 200
      {msg: "Article updated" }.to_json
    else
      { msg: summary[:msg] }.to_json
    end
  end

  delete('/:id') do
    summary = @articleCtrl.delete_article(params[:id]) #self.delete_article(params[:id])
    puts summary
    if summary[:ok]
      { msg: 'Article deleted' }.to_json
    else
      { msg: 'Article does not exist' }.to_json#mgs: 'Article does not exist' }.to_json
    end
  end
end

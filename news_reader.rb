require 'net/http'
require 'rss'

module NewsReader

  @feeds = {
    gematsu: 'https://gematsu.com/feed',
    giant_bomb: 'https://www.giantbomb.com/feeds/news/',
    game_informer: 'https://www.gameinformer.com/news.xml',
    era: 'https://www.resetera.com/forums/video-games.7/index.rss'
  }

  def NewsReader.news(site)
    articles = []
    url = @feeds[site.to_sym]
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    feed = RSS::Parser.parse(response.body)
    feed.items[0..10].each do |item|
      articles.push("#{item.title}\n #{item.link}\n")
    end
    articles.join(' ')
  end
end
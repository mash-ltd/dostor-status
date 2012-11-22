require 'koala'

desc "Pushes a random article to each user's feed"
task :push_article => :environment do
  User.all.each do |user|
    begin
      graph = Koala::Facebook::API.new(user.access_token)
      offset = rand(Article.count)
      article = Article.offset((offset < 0 ? 0 : offset)).first

      graph.put_wall_post(article.to_fb)
    rescue
    end
  end
end
require 'koala'

desc "Pushes a random article to each user's feed"
task :push_article => :environment do
  User.all.each do |user|
    begin
      graph = Koala::Facebook::API.new(user.access_token)
      offset = rand(Article.count)
      article = Article.offset((offset < 0 ? 0 : offset)).first

      graph.put_wall_post("#{tn(article.number)}: #{article.body}")
    rescue
    end
  end
end

def tn(num)
  num.to_s.split(//).map{|r|I18n.t("n"+r)}.join
end
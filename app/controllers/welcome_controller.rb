class WelcomeController < ApplicationController
  before_filter :parse_facebook_cookies
  layout "welcome"

  def index
    offset = rand(Article.count)
    @article = Article.offset((offset < 0 ? 0 : offset)).first

    respond_to do |format|
      format.html
    end
  end

  def fb_login
    if @user
      @user.update_attribute :access_token, @facebook_cookies["access_token"]
    else
      @user = User.create facebook_id: @facebook_cookies["user_id"], access_token: @facebook_cookies["access_token"]
    end

    graph = Koala::Facebook::API.new(@user.access_token)
    offset = rand(Article.count)
    article = Article.offset((offset < 0 ? 0 : offset)).first

    graph.put_wall_post("#{tn(article.number)}: #{article.body}")

    respond_to do |format|
      format.html { redirect_to :root }
    end
  end

  def fb_logout
    if @user
      @user.destroy
    end

    respond_to do |format|
      format.html { redirect_to :root }
    end
  end

  private
  def parse_facebook_cookies
   @facebook_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
   @user = User.find_by_facebook_id @facebook_cookies["user_id"] if @facebook_cookies
   @logged_in_fb = @facebook_cookies.present? && @user.present?
  end
end

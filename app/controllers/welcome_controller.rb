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

    success = true

    begin
      graph = Koala::Facebook::API.new(@user.access_token)
      offset = rand(Article.count)
      article = Article.offset((offset < 0 ? 0 : offset)).first

      graph.put_wall_post(article.to_fb)
    rescue
      success = false
    end

    respond_to do |format|
      if success
        format.html { redirect_to :root }
      else
        format.html { redirect_to :fb_logout, alert: "الحصول على إذن استخدام صفحتك على فيسبوك لم ينجح" }
      end
    end
  end

  def fb_logout
    if @user
      @user.destroy
    end

    respond_to do |format|
      format.html { redirect_to :root, alert: flash[:alert] }
    end
  end

  private
  def parse_facebook_cookies
   @facebook_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
   @user = User.find_by_facebook_id @facebook_cookies["user_id"] if @facebook_cookies
   @logged_in_fb = @facebook_cookies.present? && @user.present?
  end
end

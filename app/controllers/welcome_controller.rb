# encoding: utf-8
class WelcomeController < ApplicationController
  before_filter :parse_facebook_session
  layout "welcome"

  def index
    if params[:number]
      @article = Article.find_by_number params[:number]
    end

    unless @article.present?
      offset = rand(Article.count)
      @article = Article.offset((offset < 0 ? 0 : offset)).first
    end

    respond_to do |format|
      format.html
    end
  end

  def fb_callback
    session[:access_token] = Koala::Facebook::OAuth.new(oauth_redirect_url).get_access_token(params[:code]) if params[:code]

    respond_to do |format|
      format.html { redirect_to session[:access_token] ? fb_login_path : fb_logout_path }
    end
  end

  def fb_login
    success = true

    begin
      graph = Koala::Facebook::API.new(session["access_token"])

      if @user
        @user.update_attribute :access_token, session["access_token"]
        session["fb_user_id"] = @user.facebook_id
      elsif @facebook_cookies.present? && @facebook_cookies["user_id"].present?
        @user = User.create! facebook_id: @facebook_cookies["user_id"], access_token: session["access_token"]
        session["fb_user_id"] = @user.facebook_id
      else
        raise "Failed to sign into Facebook"
      end

      offset = rand(Article.count)
      article = Article.offset((offset < 0 ? 0 : offset)).first

      graph.put_wall_post(article.to_fb)
      @user.increment!(:pushed_articles)
      @logged_in_fb = true
    rescue => ex
      logger.error ex
      success = false
    end

    respond_to do |format|
      if success
        format.html { redirect_to :root }
      else
        # encoding: utf-8
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
  def parse_facebook_session
    unless session["fb_user_id"].present?
      @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
      user_id = @facebook_cookies["user_id"]
    else
      user_id = session["fb_user_id"]
    end

    @user = User.find_by_facebook_id user_id if user_id
    @logged_in_fb = user_id.present? && @user.present?
  end
end

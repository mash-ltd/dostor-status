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

  def naqeshny
    @qs = Rack::Utils.parse_nested_query(request.env["QUERY_STRING"])
    if params[:number]
      @article = Article.find_by_number params[:number]
    end

    unless @article.present?
      @article = Article.find_by_number 1
    end

    @netherlands = request.referrer.match(/.*netherlands.*/).present?
    
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def naqeshny_netherlands
    @qs = Rack::Utils.parse_nested_query(request.env["QUERY_STRING"])
    if params[:number]
      @statement = Statement.find_by_number params[:number]
    end

    unless @statement.present?
      @statement = Statement.find_by_number 1
    end
    
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def naqeshny_article
    @qs = Rack::Utils.parse_nested_query(request.env["QUERY_STRING"])
    if params[:number]
      @article = Article.find_by_number params[:number]
    end

    unless @article.present?
      @article = Article.find_by_number 1
    end

    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def naqeshny_nether_test
    respond_to do |format|
      format.html {render layout: false}
    end
  end

  def fb_login
    success = true

    begin
      graph = Koala::Facebook::API.new(session["access_token"])
      user_hash = graph.get_object("me")
      session["fb_user_id"] = user_hash["id"]

      @user = User.find_by_facebook_id session["fb_user_id"] if session["fb_user_id"]

      if @user
        @user.update_attribute :access_token, session["access_token"]
      elsif session["fb_user_id"].present?
        @user = User.create! facebook_id: session["fb_user_id"], access_token: session["access_token"]
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
   @user = User.find_by_facebook_id session["fb_user_id"] if session["fb_user_id"]
   @logged_in_fb = session["fb_user_id"].present? && @user.present?
  end
end

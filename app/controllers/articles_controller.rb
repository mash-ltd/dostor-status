class ArticlesController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @articles = Article.order("number ASC")

    respond_to do |format|
      format.html
    end
  end

  def show
    @article = Article.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  def new
    @article = Article.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @article = Article.new params[:article]

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @article = Article.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  def update
    @article = Article.find params[:id]

    respond_to do |format|
      if @article.update_attributes params[:article]
        format.html { redirect_to @article }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    article = Article.delete params[:id]

    respond_to do |format|
      format.html { redirect_to articles_path}
    end
  end
end

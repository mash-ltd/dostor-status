# encoding: utf-8
class NaqeshnyController < ApplicationController
  def show
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
end

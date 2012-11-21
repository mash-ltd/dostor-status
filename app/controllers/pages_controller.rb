class PagesController < ApplicationController
  def contact
  end

  def privacy
    respond_to do |format|
      format.html
    end
  end

  def tos
    respond_to do |format|
      format.html
    end
  end
end

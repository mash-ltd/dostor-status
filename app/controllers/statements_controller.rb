class StatementsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @statements = Statement.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @statement = Statement.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  def new
    @statement = Statement.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @statement = Statement.new params[:statement]

    respond_to do |format|
      if @statement.save
        format.html { redirect_to @statement }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @statement = Statement.find params[:id]

    respond_to do |format|
      format.html
    end
  end

  def update
    @statement = Statement.find params[:id]

    respond_to do |format|
      if @statement.update_attributes params[:statement]
        format.html { redirect_to @statement }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    statement = Statement.delete params[:id]

    respond_to do |format|
      format.html { redirect_to statements_path}
    end
  end

end

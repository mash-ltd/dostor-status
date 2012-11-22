class UsersController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @users = User.all
    @user_count = @users.count

    respond_to do |format|
      format.html
    end
  end

  def destroy
    user = User.find params[:id]
    user.destroy

    respond_to do |format|
      format.html { redirect_to action: :index }
    end
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, :except => [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])

    puts @user.inspect

    github = Github.new

    @repos = github.repos.list user: @user.username 

  end


end

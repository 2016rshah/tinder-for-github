class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, :except => [:index]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])

    puts @user.inspect

    #github = Github.new
    #github = Github.new client_id: '...', client_secret: '...'

    #@repos = github.repos.list user: @user.username 

    
    starring = Github::Client::Activity::Starring.new client_id: ENV["OMNIAUTH_PROVIDER_KEY"], client_secret: ENV["OMNIAUTH_PROVIDER_SECRET"]
    starring.star '2016rshah', 'blog'

  end

  def star
	end


end

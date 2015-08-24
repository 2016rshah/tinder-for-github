class GithubController < ApplicationController

  def authorize
    address = github.authorize_url redirect_uri: 'http://localhost:3000/github/callback', scope: 'public_repo'
    redirect_to address
  end

  def callback
    authorization_code = params[:code]
    access_token = github.get_token authorization_code
    token = access_token.token   # => returns token value

    puts token 
    starring = Github::Client::Activity::Starring.new oauth_token: token
    starring.star '2016rshah', 'blog'
    puts "starred!"

    redirect_to root_path
  end

  private

   def github
    @github ||= Github.new client_id: ENV["OMNIAUTH_PROVIDER_KEY"], client_secret: ENV["OMNIAUTH_PROVIDER_SECRET"]
   end
end

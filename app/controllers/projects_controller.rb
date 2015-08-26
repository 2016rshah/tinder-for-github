class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :star, :unstar]
  before_action :set_token, only: [:star, :unstar, :index]
  before_action :authenticate_user!

  # GET /projects
  # GET /projects.json
  def index
    starring = Github::Client::Activity::Starring.new oauth_token: @token

    pjs = Project.all
    @projects_unstarred = Array.new
    @projects_starred = Array.new
    for p in pjs
      if not starring.starring? p.username, p.title
        @projects_unstarred.push p
      else
        @projects_starred.push p
      end
    end

  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    @project.username = current_user.username

    projects = Github.repos.list user: @project.username

    project_titles = Array.new

    for p in projects
      project_titles.push p.name
    end

    puts project_titles
    puts "projects"

    if project_titles.include? @project.title 
      respond_to do |format|
        if @project.save
          format.html { redirect_to @project, notice: 'Project was successfully created.' }
          format.json { render :show, status: :created, location: @project }
        else
          format.html { render :new }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end

    else
      redirect_to root_path, :flash => { :error => "Repository doesn't exist!" }
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def star
    starring = Github::Client::Activity::Starring.new oauth_token: @token

    starring.star @project.username, @project.title

    redirect_to @project
  end

  def unstar 
    starring = Github::Client::Activity::Starring.new oauth_token: @token

    starring.unstar @project.username, @project.title

    redirect_to @project
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:username, :title)
    end

    def set_token
      if session[:token]
        @token = session[:token]
      else
        redirect_to "/github/authorize"
      end
    end
end

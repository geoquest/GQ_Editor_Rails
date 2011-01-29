require 'exist_adapter'

class ProjectsController < ApplicationController
  before_filter :authenticate
  def index
    @projects = Project.find_all_by_user_id(@current_user.id)
  end

  def show
    @project = Project.find(:first, :conditions => {:id => params[:id], :user_id => @current_user.id})

    if @project.nil?
      redirect_to projects_path, :notice => "A project with this id does not exist or it is not yours"
    end
  end

  def new
    @project = Project.new
    @project.user = @current_user
  end

  def create
    @project = Project.new (params[:project])
    @project.user = @current_user
    if @project.save
      adapter = ExistAdapter.new
      adapter.upload_file("data/game.xml", "game.xml", @project.id.to_s)
      redirect_to projects_path, :notice => 'Project successfully added.'
    end
  end

end
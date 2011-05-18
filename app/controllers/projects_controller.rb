require 'exist_adapter'

class ProjectsController < ApplicationController
  before_filter :authenticate
  def index
    @projects = Project.find_all_by_user_id(@current_user.id)
  end

  def show
    @project = Project.find(:first, :conditions => {:id => params[:id], :user_id => @current_user.id})


    adapter = ExistAdapter.new(@project.id)

    mission_query = 'doc("game.xml")/game/mission'
    @missions = adapter.do_request(mission_query);

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

      # Create folders on server:
      projekt_path = Rails.root.join("public", "projects", @project.id.to_s).to_s
      Dir.mkdir(projekt_path)
      Dir.mkdir(projekt_path + "/drawable")
      Dir.mkdir(projekt_path + "/drawable/npcs")
      Dir.mkdir(projekt_path + "/drawable/hotspots")
      Dir.mkdir(projekt_path + "/sound")

      # Upload game.xml to Exists
      adapter = ExistAdapter.new(@project.id)
      path = Rails.root.join("data", "skeleton.xml");
      adapter.upload_file_as_filename(path, "game.xml")
      redirect_to projects_path, :notice => 'Project successfully added.'
    end
  end

end

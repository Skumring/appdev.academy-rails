class Portfolio::ProjectsController < ApplicationController
  def index
    @portfolio_page = Page.find_by!(slug: 'portfolio')
    @projects = Project.where(is_hidden: false).order('position DESC')
  end
  
  def taged_index
    if Tag.exists?(slug: params[:tag_slug])
      @portfolio_page = Page.find_by!(slug: 'portfolio')
      @projects = Project.joins(:tags).where(tags: { slug: params[:tag_slug] }, is_hidden: false).order('position DESC')
    else
      redirect_to portfolio_root_path
    end
  end
  
  def show
    # Search by :slug
    @project = Project.find_by(slug: params[:slug])
    # Search by :id
    @project = Project.find(params[:slug]) if @project.nil?
    
    respond_to do |format|
      format.html do
        render :show
      end
      
      format.json do
        images = @project.gallery_images.order(id: :asc).map { |g| { src: g.image.url, w: g.width, h: g.height }}
        render json: images, status: :ok
      end
    end
  end
end

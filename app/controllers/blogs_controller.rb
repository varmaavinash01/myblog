class BlogsController < ApplicationController
  respond_to :json, :html

  def index
    @blogs = Blog.get_all
  end

  def new
  end
  
  def create
    blog = Blog.build(params)
    Blog.save(blog)
    redirect_to :action => "index"
  end

  def show
    @blog = Blog.get(params["id"])
  end

  def edit
  end

  def update
  end

  def destroy
    respond_with Blog.delete(params["del_id"])
  end
end

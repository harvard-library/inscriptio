class PostsController < ApplicationController
  
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
    @bulletin_board = params[:bulletin_board]
  end

  def show
    @post = Post.find(params[:id])
    
    breadcrumbs.add 'Bulletin Board', bulletin_board_path(@post.bulletin_board)
    breadcrumbs.add 'Post', @post.id
  end

  def edit
    @post = Post.find(params[:id])
    
    unless current_user.admin? || @post.user_id == current_user.id
       redirect_to('/') and return
    end
    
    @bulletin_board = @post.bulletin_board.id
  end
  
  def create
    @post = Post.new
    params[:post][:bulletin_board] = BulletinBoard.find(params[:post][:bulletin_board])
    params[:post][:user] = User.find(current_user)
    @post.attributes = params[:post]
    respond_to do|format|
      if @post.save
        flash[:notice] = 'Added that post'
        format.html {redirect_to bulletin_board_path(@post.bulletin_board)}
      else
        flash[:error] = 'Could not add that post'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    
    unless current_user.admin? || @post.user_id == current_user.id
       redirect_to('/') and return
    end
    
    post = @post.id
    if @post.destroy
      flash[:notice] = %Q|Deleted post #{post}|
      redirect_to :action => :index
    end
  end

  def update
    @post = Post.find(params[:id])
    
    unless current_user.admin? || @post.user_id == current_user.id
       redirect_to('/') and return
    end
    
    params[:post][:bulletin_board] = BulletinBoard.find(params[:post][:bulletin_board])
    params[:post][:user] = User.find(current_user)
    @post.attributes = params[:post]
    respond_to do|format|
      if @post.save
        flash[:notice] = %Q|#{@post} updated|
        format.html {redirect_to bulletin_board_path(@post.bulletin_board)}
      else
        flash[:error] = 'Could not update that post'
        format.html {render :action => :new}
      end
    end
  end
end

class PostsController < ApplicationController
  load_and_authorize_resource :except => [:new, :create]

  def new
    @post = Post.new(:bulletin_board => BulletinBoard.find(params[:bulletin_board]), :user => current_user)
    authorize! :create, @post
  end

  def show
    breadcrumbs.add 'Bulletin Board', bulletin_board_path(@post.bulletin_board)
    breadcrumbs.add 'Post', @post.id
  end

  def edit
    @bulletin_board = @post.bulletin_board
  end

  def create
    @post = Post.new(params[:post].except(:bulletin_board))
    @post.bulletin_board = BulletinBoard.find(params[:post][:bulletin_board])
    @post.user = current_user
    authorize! :create, @post

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
    bb = @post.bulletin_board

    post = @post.id
    if @post.destroy
      flash[:notice] = %Q|Deleted post #{post}|
      redirect_to bb, :action => :show
    end
  end

  def update
    params[:post][:bulletin_board] = BulletinBoard.find(params[:post][:bulletin_board])
    params[:post][:user] = User.find(current_user)
    @post.attributes = params[:post]
    respond_to do|format|
      if @post.save
        flash[:notice] = %Q|#{@post.id} updated|
        format.html {redirect_to bulletin_board_path(@post.bulletin_board)}
      else
        flash[:error] = 'Could not update that post'
        format.html {render :action => :new}
      end
    end
  end
end

class BulletinBoardsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]
  
  def index
    @bulletin_boards = BulletinBoard.all
    
    bbs = BulletinBoard.find(:all, :conditions => {:post_lifetime => 1})
    bbs.each do |bb|
      bb.post_lifetime = 30
      bb.save
    end
  end

  def new
    @bulletin_board = BulletinBoard.new
  end

  def show
    @bulletin_board = BulletinBoard.find(params[:id])
    @posts = Post.find(:all, :conditions => {:bulletin_board_id => @bulletin_board.id})
    
    breadcrumbs.add 'Bulletin Board', @bulletin_board.id
  end

  def edit
    @bulletin_board = BulletinBoard.find(params[:id])
  end
  
  def create
    @bulletin_board = BulletinBoard.new
    @bulletin_board.attributes = params[:bulletin_board]
    respond_to do|format|
      if @bulletin_board.save
        flash[:notice] = 'Added that Bulletin Board'
        format.html {render :action => :index}
      else
        flash[:error] = 'Could not add that Bulletin Board'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @bulletin_board = BulletinBoard.find(params[:id])
    bulletin_board = @bulletin_board.id
    if @bulletin_board.destroy
      flash[:notice] = %Q|Deleted Bulletin Board #{bulletin_board.id}|
      redirect_to :action => :index
    end
  end

  def update
    @bulletin_board = BulletinBoard.find(params[:id])
    @bulletin_board.attributes = params[:bulletin_board]
    respond_to do|format|
      if @bulletin_board.save
        flash[:notice] = %Q|Bulletin Board #{@bulletin_board.id} updated!|
        format.html {render :action => :index}
      else
        flash[:error] = 'Could not update that Bulletin Board'
        format.html {render :action => :new}
      end
    end
  end
end

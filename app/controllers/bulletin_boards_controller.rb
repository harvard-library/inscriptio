class BulletinBoardsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]
  load_and_authorize_resource

  def show
    @posts = Post.find(:all, :conditions => {:bulletin_board_id => @bulletin_board.id})

    breadcrumbs.add 'Bulletin Board', @bulletin_board.id
  end
end

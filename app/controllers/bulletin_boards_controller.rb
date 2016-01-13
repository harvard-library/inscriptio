class BulletinBoardsController < ApplicationController
  load_and_authorize_resource

  def show
    @posts = @bulletin_board.posts

    breadcrumbs.add 'Bulletin Board', @bulletin_board.id
  end
end

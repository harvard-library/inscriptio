class ModeratorFlagsController < ApplicationController
  load_resource :post, :except => :destroy
  load_and_authorize_resource :moderator_flag, :through => :post, :except => :destroy
  load_and_authorize_resource :only => :destroy
  def create
    respond_to do|format|
      if @moderator_flag.save
        flash[:notice] = 'Added that Moderation Flag'
        format.html {redirect_to @moderator_flag.post.bulletin_board}
      else
        flash.now[:error] = 'Could not add that Moderation Flag'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    if @moderator_flag.destroy
      flash[:notice] = %Q|Deleted moderator flag reading: #{@moderator_flag.reason}|
      redirect_to @moderator_flag.post.bulletin_board
    end
  end

end

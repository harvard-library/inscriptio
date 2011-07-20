class ModeratorFlagsController < ApplicationController
  before_filter :verify_credentials, :only => [:index, :new, :show, :create, :update, :destroy]
  
  def index
    @moderator_flags = ModeratorFlag.all 
  end

  def new
    @moderator_flag = ModeratorFlag.new
    @post = params[:post]
  end

  def show
    @reservation = ModeratorFlag.find(params[:id])
  end

  def edit
    @moderator_flag = ModeratorFlag.find(params[:id])
  end
  
  def create
    @moderator_flag = ModeratorFlag.new
    params[:moderator_flag][:post] = Post.find(params[:moderator_flag][:post])
    params[:moderator_flag][:user] = User.find(current_user)
    
    @moderator_flag.attributes = params[:moderator_flag]
    respond_to do|format|
      if @moderator_flag.save
        Notification.moderator_flag_set(@moderator_flag.post).deliver
        flash[:notice] = 'Added that Moderation Flag'
        format.html {redirect_to @moderator_flag.post}
      else
        flash[:error] = 'Could not add that Moderation Flag'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @moderator_flag = ModeratorFlag.find(params[:id])
    moderator_flag = @moderator_flag.id
    if @moderator_flag.destroy
      flash[:notice] = %Q|Deleted reservation #{moderator_flag}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @moderator_flag = ModeratorFlag.find(params[:id])
    @moderator_flag.attributes = params[:moderator_flag]
    respond_to do|format|
      if @moderator_flag.save
        flash[:notice] = %Q|#{@moderator_flag} updated|
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not update that Moderator Flag'
        format.html {render :action => :new}
      end
    end
  end
end

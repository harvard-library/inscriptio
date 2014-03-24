class ModeratorFlagsController < ApplicationController
  load_and_authorize_resource :except => [:new, :create]
  load_resource :only => [:new]

  def new
    @post = Post.find(params[:post].to_i)
    @moderator_flag.post_id = @post.id
    authorize! :create, @moderator_flag
  end

  def create
    @moderator_flag = ModeratorFlag.new(params[:moderator_flag].except(:post))
    @moderator_flag.post = Post.find(params[:moderator_flag][:post])

    authorize! :create, @moderator_flag

    respond_to do|format|
      if @moderator_flag.save
        flash[:notice] = 'Added that Moderation Flag'
        format.html {redirect_to @moderator_flag.post}
      else
        flash.now[:error] = 'Could not add that Moderation Flag'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    moderator_flag = @moderator_flag.id
    if @moderator_flag.destroy
      flash[:notice] = %Q|Deleted reservation #{moderator_flag}|
      redirect_to :action => :index
    end
  end

  def update
    respond_to do|format|
      if @moderator_flag.save
        flash.now[:notice] = %Q|#{@moderator_flag} updated|
        format.html {render :action => :show}
      else
        flash.now[:error] = 'Could not update that Moderator Flag'
        format.html {render :action => :new}
      end
    end
  end
end

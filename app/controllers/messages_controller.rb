class MessagesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:help]
  load_and_authorize_resource :except => [:help]

  def index
    breadcrumbs.add 'Messages'
  end

  def new
  end

  def show
    breadcrumbs.add 'Messages', messages_path
    breadcrumbs.add @message.title, @message.id
  end

  def create
    respond_to do|format|
      if @message.save
        flash[:notice] = 'Added that Message'
        format.html {redirect_to :action => :index}
      else
        flash.now[:error] = 'Could not add that Message'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    message = @message.title
    if @message.destroy
      flash[:notice] = %Q|Deleted message #{message}|
      redirect_to :action => :index
    end
  end

  def update
    @message.attributes = message_params
    respond_to do|format|
      if @message.save
        flash[:notice] = %Q|#{@message.title} updated|
        format.html {redirect_to messages_path}
      else
        flash.now[:error] = 'Could not update that Message'
        format.html {render :action => :new}
      end
    end
  end

  def help

  end

  private
  def message_params
    params.require(:message).permit( :title, :content, :description )
  end

end

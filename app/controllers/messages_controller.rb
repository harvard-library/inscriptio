class MessagesController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show, :help]
  
  def index
    @messages = Message.all
    
    breadcrumbs.add 'Messages'
  end

  def new
    @message = Message.new
  end

  def show
    @message = Message.find(params[:id])
    
    breadcrumbs.add 'Messages', messages_path
    breadcrumbs.add @message.title, @message.id
  end

  def edit
    @message = Message.find(params[:id])
  end
  
  def create
    @message = Message.new
    @message.attributes = params[:message]
    respond_to do|format|
      if @message.save
        flash[:notice] = 'Added that Message'
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not add that Message'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    message = @message.title
    if @message.destroy
      flash[:notice] = %Q|Deleted message #{message}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @message = Message.find(params[:id])
    @message.attributes = params[:message]
    respond_to do|format|
      if @message.save
        flash[:notice] = %Q|#{@message.title} updated|
        format.html {redirect_to messages_path}
      else
        flash[:error] = 'Could not update that Message'
        format.html {render :action => :new}
      end
    end
  end
  
  def help
    
  end
end

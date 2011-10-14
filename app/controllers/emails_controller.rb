class EmailsController < ApplicationController
  
  def new
    p "params"
    p params[:subject]
    p params[:content]
    @library = Library.find(params[:library])
    p @library.name
    @users = Array.new
    #@library.reservable_asset_types.reservable_assets.reservations.user
    @library.reservable_asset_types.each do |rat|
      rat.reservable_assets.each do |ra|
        ra.reservations.each do |r|
          Email.create(
            :from => @library.from,
            :reply_to => @library.from,
            :to => r.user.email,
            :bcc => @library.bcc,
            :subject => params[:subject],
            :body => params[:content]
          )
          p r.user.email
        end  
      end      
    end  
    flash[:notice] = "Message Sent!"
    redirect_to :back
  end  
end

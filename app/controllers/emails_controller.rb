class EmailsController < ApplicationController
  
  def new
    @library = Library.find(params[:library])
    @users = Array.new
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
  
  def asset_type
    @reservable_asset_type = ReservableAssetType.find(params[:reservable_asset_type])
    @users = Array.new
    @reservable_asset_type.reservable_assets.each do |ra|
      ra.reservations.each do |r|
        Email.create(
          :from => @reservable_asset_type.library.from,
          :reply_to => @reservable_asset_type.library.from,
          :to => r.user.email,
          :bcc => @reservable_asset_type.library.bcc,
          :subject => params[:subject],
          :body => params[:content]
        )
        p r.user.email
      end  
    end      
    flash[:notice] = "Message Sent!"
    redirect_to :back
  end   
end

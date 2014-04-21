class SchoolAffiliationsController < ApplicationController
  load_and_authorize_resource

  def index
    breadcrumbs.add "School Affiliations"
  end

  def show
    breadcrumbs.add @school_affiliation.name, @school_affiliation.id
  end

  def create
    respond_to do|format|
      if @school_affiliation.save
        flash[:notice] = 'Added that School Affiliation'
        format.html {redirect_to school_affiliations_path}
      else
        flash[:error] = 'Could not add that School Affiliation'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    school_affiliation = @school_affiliation.name
    if @school_affiliation.destroy
      flash[:notice] = %Q|Deleted school affiliation #{school_affiliation}|
      redirect_to :action => :index
    end
  end

  def update
    @school_affiliation.attributes = params[:school_affiliation]
    respond_to do|format|
      if @school_affiliation.save
        flash[:notice] = %Q|#{@school_affiliation} updated|
        format.html {redirect_to school_affiliations_path}
      else
        flash.now[:error] = 'Could not update that School Affiliation'
        format.html {render :action => :new}
      end
    end
  end
end

class SchoolAffiliationsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]
  
  def index
    @school_affiliations = SchoolAffiliation.all
    
    breadcrumbs.add "School Affiliations"
  end

  def new
    @school_affiliation = SchoolAffiliation.new
  end

  def show
    @school_affiliation = SchoolAffiliation.find(params[:id])
    
    breadcrumbs.add @school_affiliation.name, @school_affiliation.id
  end

  def edit
    @school_affiliation = SchoolAffiliation.find(params[:id])
  end
  
  def create
    @school_affiliation = SchoolAffiliation.new
    @school_affiliation.attributes = params[:school_affiliation]
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
    @school_affiliation = SchoolAffiliation.find(params[:id])
    school_affiliation = @school_affiliation.name
    if @school_affiliation.destroy
      flash[:notice] = %Q|Deleted school affiliation #{school_affiliation}|
      redirect_to :action => :index
    end
  end

  def update
    @school_affiliation = SchoolAffiliation.find(params[:id])
    @school_affiliation.attributes = params[:school_affiliation]
    respond_to do|format|
      if @school_affiliation.save
        flash[:notice] = %Q|#{@school_affiliation} updated|
        format.html {render :action => :index}
      else
        flash[:error] = 'Could not update that School Affiliation'
        format.html {render :action => :new}
      end
    end
  end
end

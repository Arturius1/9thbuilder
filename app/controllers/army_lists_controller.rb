class ArmyListsController < ApplicationController
  before_filter :authenticate_user!

  # GET /army_lists
  # GET /army_lists.xml
  def index
    @search = params[:search] || {}

    @armies = Army.all
    @army_lists = ArmyList.includes(:army).where(:user_id => current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @army_lists }
    end
  end

  # GET /army_lists/1
  # GET /army_lists/1.xml
  def show
    @army_list = ArmyList.find_by_id_and_user_id!(params[:id], current_user)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @army_list }
    end
  end

  # GET /army_lists/new
  # GET /army_lists/new.xml
  def new
    @army_list = ArmyList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @army_list }
    end
  end

  # GET /army_lists/1/edit
  def edit
    @army_list = ArmyList.find_by_id_and_user_id!(params[:id], current_user)
  end

  # POST /army_lists
  # POST /army_lists.xml
  def create
    @army_list = ArmyList.new(params[:army_list])
    @army_list.user = current_user
    @army_list.value_points = 0

    respond_to do |format|
      if @army_list.save
        format.html { redirect_to(@army_list, :notice => 'Army list was successfully created.') }
        format.xml  { render :xml => @army_list, :status => :created, :location => @army_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @army_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /army_lists/1
  # PUT /army_lists/1.xml
  def update
    @army_list = ArmyList.find_by_id_and_user_id!(params[:id], current_user)

    respond_to do |format|
      if @army_list.update_attributes(params[:army_list])
        format.html { redirect_to(@army_list, :notice => 'Army list was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @army_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /army_lists/1
  # DELETE /army_lists/1.xml
  def destroy
    @army_list = ArmyList.find_by_id_and_user_id!(params[:id], current_user)
    @army_list.destroy

    respond_to do |format|
      format.html { redirect_to(army_lists_url) }
      format.xml  { head :ok }
    end
  end
end

class WidgetsController < ApplicationController

  before_filter :authenticate_user!, :only=>[:edit, :update, :destroy]

  # GET /widgets
  # GET /widgets.json
  def index
    @widgets = Widget.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @widgets }
    end
  end

  # GET /widgets/1
  # GET /widgets/1.json
  def show
    @widget = Widget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @widget }
    end
  end

  # GET /widgets/new
  # GET /widgets/new.json
  def new
    @widget = Widget.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @widget }
    end
  end

  # GET /widgets/1/edit
  def edit
    @widget = Widget.find(params[:id])
  end

  # POST /widgets
  # POST /widgets.json
  def create
    @widget = Widget.new(params[:widget])

    respond_to do |format|
      if @widget.save
        format.html { redirect_to @widget, notice: 'Widget was successfully created.' }
        format.json { render json: @widget, status: :created, location: @widget }
      else
        format.html { render action: "new" }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /widgets/1
  # PUT /widgets/1.json
  def update
    @widget = Widget.find(params[:id])

    respond_to do |format|
      if @widget.update_attributes(params[:widget])
        format.html { redirect_to @widget, notice: 'Widget was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /widgets/1
  # DELETE /widgets/1.json
  def destroy

    Ensnare::Violation.create(:ip_address=>request.remote_ip.to_s, 
                        :violation_type=>"Delete Widget",
                        :session_id=>session.try(:[],"session_id").to_s,
                        :user_id=>current_user.id,
                        :expected=>"None",
                        :name=>params[:id].to_s,
                        :observed=>"Delete",
                        :weight=>5)

    respond_to do |format|
      format.html { redirect_to widgets_url, notice: 'You are not allowed to do that!' }
    end

    
  end
end

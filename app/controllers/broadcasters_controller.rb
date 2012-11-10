class BroadcastersController < ApplicationController
  # GET /broadcasters
  # GET /broadcasters.json
  def index
    @broadcasters = Broadcaster.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @broadcasters }
    end
  end

  # GET /broadcasters/1
  # GET /broadcasters/1.json
  def show
    @broadcaster = Broadcaster.find(params[:id])
    @channels = @broadcaster.channels

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @broadcaster }
    end
  end

  # GET /broadcasters/new
  # GET /broadcasters/new.json
  def new
    @broadcaster = Broadcaster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @broadcaster }
    end
  end

  # GET /broadcasters/1/edit
  def edit
    @broadcaster = Broadcaster.find(params[:id])
  end

  # POST /broadcasters
  # POST /broadcasters.json
  def create
    @broadcaster = Broadcaster.new(params[:broadcaster])

    respond_to do |format|
      if @broadcaster.save
        format.html { redirect_to @broadcaster, notice: 'Broadcaster was successfully created.' }
        format.json { render json: @broadcaster, status: :created, location: @broadcaster }
      else
        format.html { render action: "new" }
        format.json { render json: @broadcaster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /broadcasters/1
  # PUT /broadcasters/1.json
  def update
    @broadcaster = Broadcaster.find(params[:id])

    respond_to do |format|
      if @broadcaster.update_attributes(params[:broadcaster])
        format.html { redirect_to @broadcaster, notice: 'Broadcaster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @broadcaster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /broadcasters/1
  # DELETE /broadcasters/1.json
  def destroy
    @broadcaster = Broadcaster.find(params[:id])
    @broadcaster.destroy

    respond_to do |format|
      format.html { redirect_to broadcasters_url }
      format.json { head :no_content }
    end
  end
end

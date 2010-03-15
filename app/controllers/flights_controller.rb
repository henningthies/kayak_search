class FlightsController < ApplicationController

  before_filter :check_cache_status, :only => :show 

  cache_sweeper :flight_sweeper, :only => [:update, :create, :destroy] 
  
  def check_cache_status 
    @flight = Flight.find(params[:id])
    if @flight.kayak_request.updated_at < 1.day.ago
      @flight.kayak_request.update_attributes(:more_pending => "true")
      spawn_search(@flight) 
    end
  end
  
  # GET /flights
  # GET /flights.xml
  def index
    @flights = Flight.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @flights }
    end
  end

  # GET /flights/1
  # GET /flights/1.xml
  def show
    respond_to do |format|
      format.html
      format.js { render :partial => "results" }
      format.xml  { render :xml => @flight }
    end
  end

  # GET /flights/new
  # GET /flights/new.xml
  def new
    @flight = Flight.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @flight }
    end
  end

  # GET /flights/1/edit
  def edit
    @flight = Flight.find(params[:id])
  end

  # POST /flights
  # POST /flights.xml
  def create
    @flight = Flight.new(params[:flight])
    @flight.kayak_request = KayakRequest.new :more_pending => "true"
    @flight.kayak_request.save
    respond_to do |format|
      if @flight.save
        spawn_search(@flight)
        flash[:notice] = 'Flight was successfully created.'
        format.html { redirect_to(@flight) }
        format.xml  { render :xml => @flight, :status => :created, :location => @flight }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @flight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /flights/1
  # PUT /flights/1.xml
  def update
    @flight = Flight.find(params[:id])
    respond_to do |format|
      if @flight.update_attributes(params[:flight])
        @flight.kayak_request.update_attributes(:more_pending => "true")
        spawn_search(@flight)
        flash[:notice] = 'Flight was successfully updated.'
        format.html { redirect_to(@flight) }
        format.js { render :partial => "results" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @flight.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /flights/1
  # DELETE /flights/1.xml
  def destroy
    @flight = Flight.find(params[:id])
    @flight.destroy
    respond_to do |format|
      format.html { redirect_to(flights_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
  def spawn_search(flight)
    kayak_search = KayakSearch.new(flight)
    spawn do
      while flight.kayak_request.more_pending == "true"
        make_request(kayak_search, flight)        
        sleep 3
      end
    end
  end
  
  def make_request(kayak_search, flight)
    count, more_pending, xml = kayak_search.get_xml
    if count >= 1 || count < 1 && more_pending == "false"
      flight.kayak_request.update_attributes(:more_pending => more_pending, :xml => xml)
    end
  end
  
end

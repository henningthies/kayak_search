class FlightsController < ApplicationController

  before_filter :check_cache_status, :only => :show 

  #cache_sweeper :kayak_request_sweeper, :only => [:update, :create, :destroy, :check_cache_status] 
  
  def check_cache_status 
    @flight = Flight.find(params[:id])
    if @flight.updated_at < 1.day.ago
       @flight.kayak_search_response.more_pending = "true"
       cache = ActiveSupport::Cache.lookup_store(:file_store , RAILS_ROOT+"/tmp/cache")
       cache.delete("views/kayak_requests/#{@flight.id}") if cache.exist?("views/kayak_requests/#{@flight.id}")
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
    @flight.kayak_rss = KayakRss.create
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
        @flight.kayak_search_response.more_pending = "true"
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
    kayak_flight_search_client = KayakFlightSearch::Client.new
    spawn do
      while flight.kayak_search_response.nil? || flight.kayak_search_response.more_pending != "false"
        refresh_results(kayak_flight_search_client, flight)
        sleep 1
      end
    end
  end
  
  def refresh_results(kayak_flight_search_client, flight)
    search_result = kayak_flight_search_client.lookup(:depart_airport => flight.departure_airport.iata_code, :arrival_airport => flight.arrival_airport.iata_code, :depart_date => flight.depart_date, :return_date => flight.return_date)
    flight.update_attributes(:kayak_search_response => search_result.response)
    if search_result.response.count >= 1 || search_result.response.count < 1 && search_result.response.more_pending == "false"
      flight.update_attributes(:kayak_search_response => search_result.response )
      cache = ActiveSupport::Cache.lookup_store(:file_store , RAILS_ROOT+"/tmp/cache")
      cache.delete("views/kayak_requests/#{flight.id}") if cache.exist?("views/kayak_requests/#{flight.id}")
    end
  end
    
end

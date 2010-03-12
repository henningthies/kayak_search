class FlightsController < ApplicationController

  before_filter :check_cache_status, :only => :show 
  
  def check_cache_status 
    @flight = Flight.find(params[:id])

    if @flight.kayak_request.updated_at < 1.day.ago
      @cache = ActiveSupport::Cache.lookup_store(:file_store , RAILS_ROOT+"/tmp/cache")
      host = "#{request.host}.#{request.port}"
      spawn_search(@flight, host)
      if @cache.exist?("views/#{host}/flights/#{@flight.id}")
        cached_data = @cache.read("views/#{host}/flights/#{@flight.id}")
        @cache.write("views/#{host}/flights/#{@flight.id}","
        <li id=\"loading\">Neue Flüge werden gesucht.
        <script type=\"text/javascript\">
        //<![CDATA[
        updater = new PeriodicalExecuter(function() 
        {new Ajax.Updater(\"results\", \"#{@flight.id}\”, {asynchronous:true, evalScripts:true, method:\"get\", onComplete:function(request){updater.stop();}, parameters:\"authenticity_token=\" + encodeURIComponent(\"cut3lvYpjggyblcW8OCQFh+lcgk4LS+g6xgYCwE4DIk=\")})}, 3)
        //]]>
        </script>        
        </li>\n"+cached_data)
      end   
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
        spawn_search(@flight, "#{request.host}.#{request.port}")
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
        spawn_search(@flight, "#{request.host}.#{request.port}")
        flash[:notice] = 'Flight was successfully updated.'
        format.html { redirect_to(@flight) }
        format.js {render :partial => "results"}
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
  def spawn_search(flight, host)
    kayak_search = KayakSearch.new(flight)
    spawn do
      while flight.kayak_request.more_pending == "true"
        make_request(kayak_search, flight, host)        
        sleep 3
      end
    end
  end
  
  def make_request(kayak_search, flight, host)
    count, flight.kayak_request.more_pending, flight.kayak_request.xml = kayak_search.get_xml
    flight.kayak_request.save
    if count >= 1 || count < 1 && flight.kayak_request.more_pending == "false"
      cache = ActiveSupport::Cache.lookup_store(:file_store , RAILS_ROOT+"/tmp/cache")
      cache.delete("views/#{host}/flights/#{flight.id}") if cache.exist?("views/#{host}/flights/#{flight.id}")
    end
    
  end
  
end

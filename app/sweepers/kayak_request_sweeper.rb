class KayakRequestSweeper < ActionController::Caching::Sweeper
  observe KayakRequest
  
  def after_update(kayak_request)
    expire_kayak_reqest_fragment(kayak_request.id)
  end
  
  def before_destroy(kayak_request)
    expire_kayak_reqest_fragment(kayak_request.id)
  end
  
  private
  
  def expire_kayak_reqest_fragment(kayak_request_id)
    expire_fragment("views/kayak_requests/#{kayak_request_id}")
    expire_fragment("kayak_requests/#{kayak_request_id}")
  end
  
end
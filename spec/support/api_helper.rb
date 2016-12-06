module ApiHelper
  def do_request(http_request, url, options={})
    send(http_request, url, params: { format: :json }.merge(options))
  end
end

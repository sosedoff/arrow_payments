require 'faraday'
require 'json'

module ArrowPayments
  module Connection
    API_PRODUCTION = 'https://gateway.arrowpayments.com'
    API_SANDBOX = 'http://demo.arrowpayments.com'

    def get(path, params={}, raw=false)
      request(:get, path, params, raw)
    end

    def post(path, params={}, raw=false)
      request(:post, path, params, raw)
    end

    def post_to_url(url, params)
      Faraday.post(url, params)
    end

    protected

    def request(method, path, params={}, raw=false)
      if method == :post
        path = "/api#{path}"
        
        params['ApiKey'] = api_key
        params['MID'] = merchant_id
      else
        path = "/api/#{api_key}#{path}"
      end

      headers = {'Accept' => 'application/json'}
      api_url = production? ? API_PRODUCTION : API_SANDBOX

      response = connection(api_url).send(method, path, params) do |request|
        request.url(path, params)
      end

      unless response.success?
        case response.status
        when 400
          raise ArrowPayments::BadRequest, response.headers['error']
        when 404
          raise ArrowPayments::NotFound, response.headers['error']
        when 500
          raise ArrowPayments::Error, response.headers['error']
        end
      end

      raw ? response : JSON.parse(response.body)
    end

    def connection(url)
      connection = Faraday.new(url) do |c|
        c.use(Faraday::Request::UrlEncoded)
        c.use(Faraday::Response::Logger) if debug?
        c.adapter(Faraday.default_adapter)
      end
    end
  end
end
class InflectJson
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    if request.content_mime_type == Mime::JSON
      # Convert request body from camelCase to snake_case
      env["RAW_POST_DATA"] = to_underscore(request.raw_post)
    end

    status, headers, response = @app.call(env)

    if headers["Content-Type"] and headers["Content-Type"].match("json")
      # Convert response body from snake_case to camelCase
      body = if response.respond_to? :body
        response.body
      elsif response.respond_to? :join
        response.join
      else
        response
      end
      [status, headers, [to_camel_case(body)]]
    else
      [status, headers, response]
    end
  end

  # Based on https://gist.github.com/timruffles/2780508
  def to_underscore(hash)
    convert_json hash, :underscore
  end
  def to_camel_case(hash)
    convert_json hash, :camelize, :lower
  end
  def convert_json(str, *method)
    obj = ActiveSupport::JSON.decode(str)
    converted = convert(obj, *method)
    ActiveSupport::JSON.encode(converted)
  end
  def convert(obj, *method)
    case obj
    when Hash
      obj.inject({}) do |h,(k,v)|
        v = convert v, *method
        h[k.send(*method)] = v
        h
      end
    when Array
      obj.map {|m| convert m, *method }
    else
      obj
    end
  end
end
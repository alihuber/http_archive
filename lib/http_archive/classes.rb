module HttpArchive

  # Container for information about the HTTP Archive creator.
  class Creator
    # Returns the name of the creator of the HTTP Archive
    # @return [String] String with creator name, e.g. "Firebug"
    attr_accessor :name
    # Returns the version of the creator of the HTTP Archive
    # @return [String] String with creator version, e.g. "1.11"
    attr_accessor :version
  end

  # Container for browser-related information.
  class Browser
    # Returns the name of the browser the page was loaded
    # @return [String] String with browser name, e.g. "Firefox"
    attr_accessor :name
    # Returns the version of the browser the page was loaded
    # @return [String] String with browser version, e.g. "21.0"
    attr_accessor :version
  end

  # Holds general data of the page and its loading process
  class Page
    # Returns the datetime as string when loading of the page started
    # @return [String] datetime-string, e.g. "2013-05-28T22:16:19.883+02:00"
    attr_accessor :started_datetime
    # Returns the id of the page
    # @return [String] page id as string, e.g. "page_50735"
    attr_accessor :id
    # Returns the title of the page
    # @return [String] page title as string, e.g. "Software is hard"
    attr_accessor :title
    # Returns the amount of milliseconds sice the page load started and the content is loaded
    # @return [Fixnum] milliseconds content is loaded, e.g. 4994
    attr_accessor :on_content_load
    # Returns the amount of milliseconds sice the page load started and the page itself is loaded
    # @return [Fixnum] milliseconds page is loaded, e.g. 6745
    attr_accessor :on_load
  end

  # Holds information for every single interaction of the browser with the page.
  # Entry objects hold the request and response data in seperate objects.
  class Entry
    # Returns the reference to the parent page
    # @return [String] ref to parent page as string, e.g. "page_50735"
    attr_accessor :pageref
    # Returns the datetime as string when loading of this element started
    # @return [String] datetime-string, e.g. "2013-05-28T22:16:19.883+02:00"
    attr_accessor :started_datetime
    # Duration of the load time of this interaction
    # @return [Fixnum] elapsed time of this request in milliseconds
    attr_accessor :time
    # Request data for this interaction
    # @return [Request] 'Request' object with request-related data
    attr_accessor :request
    # Response data for this interaction
    # @return [Response] 'Response' object with response-related data
    attr_accessor :response
    # Info about cache usage for this interaction
    # @return [Hash] data about cache usage as a hash
    attr_accessor :cache
    # Info about Request/Response round trip
    # @return [Hash] timings data as a hash
    # @example
    #   {"blocked"=>15, "dns"=>0, "connect"=>0, "send"=>0, "wait"=>39, "receive"=>0}
    attr_accessor :timings
    # IP address of the server
    # @return [String] ip address as string, e.g. "91.239.200.165"
    attr_accessor :server_ip_address
    # Client or server port number
    # @return [String] port number as string, e.g. "80"
    attr_accessor :connection
  end

  # Holds information about the performed request in an interaction
  class Request
    # The method of this request
    # @return [String] request method as string, e.g. "GET"
    attr_accessor :http_method
    # The absolute url of the request
    # @return [String] url as string, e.g. "http://www.spiegel.de/layout/css/style-V3-23.css"
    attr_accessor :url
    # The HTTP version of this request
    # @return [String] HTTP version as string, e.g. "HTTP/1.1"
    attr_accessor :http_version
    # A list of cookie objects for this request
    # @return [Array] list of cookie objects as an array
    attr_accessor :cookies
    # A list of query parameters for this request
    # @return [Array] list of query parameters as an array
    attr_accessor :query_string
    # The headers of this request
    # @return [Hash] header objects (strings) as a hash
    # @example
    #   {"Host"=>"...", "User-Agent"=>"...", "Accept"=>"...", "Accept-Language"=>"...", "Accept-Encoding"=>"...", "Connection"=>"..."}
    attr_accessor :headers
    # Size of the request header
    # @return [Fixnum] header size of this request in bytes, -1 if not available
    attr_accessor :headers_size
    # Size of the request body (POST data payload)
    # @return [Fixnum] body size of this request in bytes, -1 if not available
    attr_accessor :body_size
  end

  # Holds information about the response for an interaction
  class Response
    # The status of this request
    # @return [Fixnum] response status as number, e.g. 200
    attr_accessor :status
    # The status of this request as text description
    # @return [String] response status as string, e.g. "OK"
    attr_accessor :status_text
    # The HTTP version of this response
    # @return [String] HTTP version as string, e.g. "HTTP/1.1"
    attr_accessor :http_version
    # A list of cookie objects for this response
    # @return [Array] list of cookie objects as an array
    attr_accessor :cookies
    # The headers of this response
    # @return [Hash] header objects (strings) as a hash
    # @example
    #   {"Date"=>"...", "Server"=>"...", "Location"=>"...", "Cache-Control"=>"...", "Expires"=>"...", "Content-Length"=>"...", "Keep-Alive"=>"...", "Connection"=>"...", "Content-Type"=>"..."}
    attr_accessor :headers
    # Size of the response header
    # @return [Fixnum] header size of this response in bytes, -1 if not available
    attr_accessor :headers_size
    # Size of the response body
    # @return [Fixnum] body size of this request in bytes, -1 if not available, 0 if from cache
    attr_accessor :body_size
    # Content of the response body
    # @return [Hash] response body objects (strings) as a hash
    # @example
    #   {"mimeType"=>"text/html", "size"=>0}
    attr_accessor :content
    # Redirection target URL from location response header.
    # @return [String] redirect URL as string, e.g. "blog/index.php"
    attr_accessor :redirect_url
  end

end

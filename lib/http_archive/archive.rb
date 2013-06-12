# Module that holds all other classes.
# Nothing to see here...
module HttpArchive
  ##
  # The main object to interact with.
  # All accessible objects (see below) hold further information about the archive.
  #
  class Archive

    # Returns the 'Creator' object with data of the creator of the archive (Firebug etc.)
    # @return [Creator]
    attr_reader :creator
    # Returns the 'Browser' object with data of the browser
    # @return [Browser]
    attr_reader :browser
    # Returns general information about the page interaction as an array of 'Page' objects, normally just one entry
    # @return [Array<Page>]
    attr_reader :pages
    # Returns all browser interactions with the page as an array of 'Entry' objects
    # @return [Array<Entry>]
    attr_reader :entries
    # For internal use, holds the parsed JSON-data
    # @return [Hash]
    attr_writer :content

    # Creates a new Archive object with given input.
    # @param src [String,File] must be object type String or File
    # @raise [ArgumentError, JSON::ParserError]
    def initialize(src)
      unless src.is_a?(File) || src.is_a?(String)
        puts 'Argument must be String or File!'
        raise ArgumentError
      end
      src = src.read if src.is_a?(File)
      begin
        @content = JSON.parse(src)
      rescue
        puts "The input could not be parsed."
        raise JSON::ParserError
      end
      extract_creator
      extract_browser
      extract_pages
      extract_entries
    end


    # Prints a table representation of the Http Archive to STDOUT.
    # An example is given on the README-file.
    # Columns are like the "Network"-view of Firebug or Chrome Dev tools.
    #
    # @return [String] A string table representation of the archive data
    def print_table
      puts

      data = get_total_data
      puts("Metrics for: " +"'" + data[0] + "', " + data[1] + " Requests, " + data[2] + "MB downloaded. "  + "Load time: " + data[3] + "s")

      puts
      print_rows
      puts
    end


    # Gets the common data for a page.
    # Convenience method that can be used for bulk reading of page data.
    # @return [Array<page_title, ressource_count, total_download_size, overall_load_time>] An array with page data
    # @example Example of returned Array
    #     ["Software is hard", "26", "0.36", "6.745"]
    def get_total_data
      size = calc_total_size.to_s
      load_time = (@pages.first.on_load / 1000.0).to_s

      [@pages.first.title, @entries.size.to_s, size, load_time]
    end


    # Gets the data for a row for all entries.
    # Convenience method that can be used for bulk reading of entry data.
    # @return [Array<Array<html_method, ressource_name, status_name, status_code, ressource_size, load_duration>>] An array with row data
    # @example Example of returned Array
    #     [["GET", "/prototype.js?ver=1.6.1", "200", "OK", "139.85", "1.06"], ... ]
    def get_row_data
      rows = []
      @entries.each do |entry|
        method = entry.request.http_method
        # get part after .com/ if any
        url = entry.request.url
        if url.end_with?("/")
          ressource = entry.request.url
        else
          r = url.rindex("/")
          ressource = url[r..-1]
        end
        # first 30 characters of the ressource name
        ressource = ressource[0, 30]
        status = entry.response.status.to_s
        code = entry.response.status_text
        size = (entry.response.content['size'] / 1000.0).round(2).to_s
        duration = (entry.time / 1000.0).to_s

        rows << [method, ressource, status, code, size, duration]
      end
      rows
    end


    private
      def print_rows
        rows = get_row_data
        rows.each do |row|
          puts "%s %-32s %s %-20s %-10s %s" % [row[0], row[1], row[2], row[3], row[4] + " KB", row[5] +"s"]
        end
      end

      def calc_total_size
        total = 0
        @entries.each do |entry|
          total = total + entry.response.content['size']
        end
        total = total / (1024.0 * 1024)
        total.round(2)
      end

      def extract_creator
        creator = HttpArchive::Creator.new
        creator.name = @content['log']['creator']['name']
        creator.version = @content['log']['creator']['version']
        @creator = creator
      end

      def extract_browser
        browser = HttpArchive::Browser.new
        browser.name = @content['log']['browser']['name']
        browser.version = @content['log']['browser']['version']
        @browser = browser
      end

      def extract_pages
        pages = []
        hash_pages = @content['log']['pages']
        hash_pages.each do |page|
          new_page = Page.new
          new_page.started_datetime = page['startedDateTime']
          new_page.id               = page['id']
          new_page.title            = page['title']
          new_page.on_content_load  = page['pageTimings']['onContentLoad']
          new_page.on_load          = page['pageTimings']['onLoad']
          pages << new_page
        end
        @pages = pages
      end

      def extract_entries
        entries = []
        entries_hash = @content['log']['entries']
        entries_hash.each do |entry|
          new_entry = Entry.new
          new_entry.pageref = entry['pageref']
          new_entry.started_datetime = entry['startedDateTime']
          new_entry.time = entry['time']
          new_entry.cache = entry['cache']
          new_entry.timings = entry['timings']
          new_entry.server_ip_address = entry['serverIPAddress']
          new_entry.connection = entry['connection']

          new_request = Request.new
          new_request.http_method = entry['request']['method']
          new_request.url = entry['request']['url']
          new_request.http_version = entry['request']['httpVersion']
          new_request.cookies = entry['request']['cookies']
          new_request.query_string = entry['request']['queryString']
          new_request.headers_size = entry['request']['headersSize']
          new_request.body_size = entry['request']['bodySize']
          header_hash = {}
          entry['request']['headers'].each do |info|
            header_hash[info['name']] = info['value']
          end
          new_request.headers = header_hash


          new_response = Response.new
          new_response.status = entry['response']['status']
          new_response.status_text = entry['response']['statusText']
          new_response.http_version = entry['response']['httpVersion']
          new_response.cookies = entry['response']['cookies']
          new_response.content = entry['response']['content']
          new_response.redirect_url = entry['response']['redirectURL']
          new_response.headers_size = entry['response']['headersSize']
          new_response.body_size = entry['response']['bodySize']
          header_hash = {}
          entry['response']['headers'].each do |info|
            header_hash[info['name']] = info['value']
          end
          new_response.headers = header_hash


          new_entry.request = new_request
          new_entry.response = new_response
          entries << new_entry
        end
        @entries = entries
      end


  end
end

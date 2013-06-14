require_relative '../spec_helper'

describe HttpArchive::Archive do

  let(:file_src) { src = File.open(FixturePath.to_s + '/testfile.har', 'r') }

  it 'can control the content of a file/string as JSON' do
    archive = HttpArchive::Archive.new(file_src)
    # file has been read
    file_src.rewind
    parsed = JSON.parse(file_src.read)
    archive.instance_variable_get(:@content).should == parsed
  end

  it 'turns input into Hash' do
    archive = HttpArchive::Archive.new(file_src)
    archive.instance_variable_get(:@content).class.should be Hash
  end

  its 'constructor argument must be a file or string' do
    src = "{\"log\": {\"version\": \"1.1\"}}"

    expect {HttpArchive::Archive.new(src)}.not_to raise_error(ArgumentError)
    expect {HttpArchive::Archive.new(src)}.not_to raise_error(JSON::ParserError)

    expect {HttpArchive::Archive.new(file_src)}.not_to raise_error(ArgumentError)
    file_src.rewind
    expect {HttpArchive::Archive.new(file_src)}.not_to raise_error(JSON::ParserError)

    expect {HttpArchive::Archive.new(123)}.to raise_error(ArgumentError)
    expect {HttpArchive::Archive.new("test")}.to raise_error(JSON::ParserError)
  end

  it 'can print a table with the data' do
    archive = HttpArchive::Archive.new(file_src)
    archive.respond_to?(:print_table).should be true
  end

  it 'can get an Array of general data of a page' do
    archive = HttpArchive::Archive.new(file_src)
    archive.respond_to?(:get_total_data)
  end

  it 'can get an Array with Arrays with all data of all rows' do
    archive = HttpArchive::Archive.new(file_src)
    archive.respond_to?(:get_row_data)
  end
end

describe 'Archive public methods' do
  let(:file_src) {src = File.open(FixturePath.to_s + '/testfile.har', 'r')}
  let(:archive) {HttpArchive::Archive.new(file_src)}

  its 'get_total_data method returns the correct data' do
    test_ary = ["Software is hard", "26", "0.36", "6.745"]
    real_ary = archive.get_total_data
    real_ary.each { |data| data.class.should be String }
    real_ary.should == test_ary
  end

  its 'get_row_data method return the correct data' do
    test_ary = [["GET", "http://www.janodvarko.cz/", "302", "Moved Temporarily", "0.0", "0.054"],
    ["GET", "/index.php", "301", "Moved Permanently", "0.0", "0.469"],
    ["GET", "http://www.janodvarko.cz/blog/", "200", "OK", "52.95", "2.593"],
    ["GET", "/l10n.js?ver=20101110", "200", "OK", "0.31", "0.065"],
    ["GET", "/prototype.js?ver=1.6.1", "200", "OK", "139.85", "1.06"],
    ["GET", "/wp-scriptaculous.js?ver=1.8.3", "200", "OK", "2.94", "0.136"],
    ["GET", "/effects.js?ver=1.8.3", "200", "OK", "38.47", "0.665"],
    ["GET", "/geshi.css", "200", "OK", "1.03", "0.261"],
    ["GET", "/lightbox.css", "200", "OK", "1.42", "0.269"],
    ["GET", "/lightbox.js", "200", "OK", "23.84", "0.55"],
    ["GET", "/rss.gif", "200", "OK", "0.62", "1.114"],
    ["GET", "/x.png", "200", "OK", "1.37", "1.151"],
    ["GET", "/useincommandline.png", "200", "OK", "21.55", "2.488"],
    ["GET", "/red-text.png", "200", "OK", "18.97", "2.778"],
    ["GET", "/simple-log.png", "200", "OK", "27.14", "3.135"],
    ["GET", "/start-button.png", "200", "OK", "11.29", "2.29"],
    ["GET", "/wordpress.gif", "200", "OK", "0.52", "2.316"],
    ["GET", "/creativebits.gif", "200", "OK", "0.34", "2.323"],
    ["GET", "/urchin.js", "200", "OK", "22.68", "1.476"],
    ["GET", "/style.css", "200", "OK", "9.24", "0.43"],
    ["GET", "/quote.gif", "200", "OK", "1.62", "1.716"],
    ["GET", "/sidebar_top.gif", "200", "OK", "0.11", "1.767"],
    ["GET", "/sidebar_bottom.gif", "200", "OK", "0.11", "1.797"],
    ["GET", "/&utmac=UA-3586722-1&utmcc=__u", "200", "OK", "0.04", "1.318"],
    ["GET", "/loading.gif", "200", "OK", "2.77", "0.071"],
    ["GET", "/closelabel.gif", "200", "OK", "0.98", "0.089"]]

    real_ary = archive.get_row_data
    real_ary.class.should be Array
    real_ary.each { |data| data.class.should be Array }
    test_ary.each_with_index do |data, index|
      real_ary[index].should == data
      real_ary[index].each { |entry| entry.class.should be String }
    end
  end
end


describe 'Archive interface' do

  let(:file_src) {src = File.open(FixturePath.to_s + '/testfile.har', 'r')}
  let(:archive) {HttpArchive::Archive.new(file_src)}

  it 'responds to API-methods' do
    archive.respond_to?(:creator).should be true
    archive.respond_to?(:browser).should be true
    archive.respond_to?(:pages).should be true
    archive.respond_to?(:entries).should be true
  end

  it 'can return a creator object with name and version' do
    creator = archive.creator
    creator.class.should be HttpArchive::Creator
    creator.respond_to?(:name).should be true
    creator.respond_to?(:version).should be true
    creator.name.should be == "Firebug"
    creator.version.should be == "1.11"
  end

  it 'can return a browser object with name and version' do
    browser = archive.browser
    browser.class.should be HttpArchive::Browser
    browser.respond_to?(:name).should be true
    browser.respond_to?(:version).should be true
    browser.name.should be == "Firefox"
    browser.version.should be == "21.0"
  end

  it 'can return a list of page objects' do
    page_objects = archive.pages
    page_objects.size.should be 1
    page_objects.first.class.should be HttpArchive::Page
    page_objects.first.started_datetime.should == "2013-05-28T22:16:19.883+02:00"
    page_objects.first.id.should == "page_50735"
    page_objects.first.title.should == "Software is hard"
    page_objects.first.on_content_load.should be 4994
    page_objects.first.on_load.should be 6745
  end

  it 'can return a list of entry objects' do
    entry_objects = archive.entries
    entry_objects.size.should be 26
    entry_objects.first.class.should be HttpArchive::Entry
  end

  its 'entry objects have pageref data' do
    entry_objects = archive.entries
    entry_objects.first.pageref.class.should be String
    entry_objects.first.pageref.should == "page_50735"
  end

  its 'entry objects have started datetime data' do
    entry_objects = archive.entries
    entry_objects.first.started_datetime.class.should be String
    entry_objects.first.started_datetime.should == "2013-05-28T22:16:19.883+02:00"
  end

  its 'entry objects have duration data' do
    entry_objects = archive.entries
    entry_objects.first.time.class.should be Fixnum
    entry_objects.first.time.should == 54
  end

  its 'entry objects have objects with request data' do
    entry_objects = archive.entries

    entry_objects.first.request.class.should be HttpArchive::Request

    entry_objects.first.request.http_method.class.should be String
    entry_objects.first.request.http_method.should == "GET"

    entry_objects.first.request.url.class.should be String
    entry_objects.first.request.url.should == "http://www.janodvarko.cz/"

    entry_objects.first.request.http_version.class.should be String
    entry_objects.first.request.http_version.should == "HTTP/1.1"

    entry_objects.first.request.cookies.class.should be Array
    entry_objects.first.request.cookies.should == []

    entry_objects.first.request.query_string.class.should be Array
    entry_objects.first.request.query_string.should == []

    entry_objects.first.request.headers_size.class.should be Fixnum
    entry_objects.first.request.headers_size.should == 316

    entry_objects.first.request.body_size.class.should be Fixnum
    entry_objects.first.request.body_size.should == -1

    entry_objects.first.request.headers.class.should be Hash
    entry_objects.first.request.headers['Host'].should == "www.janodvarko.cz"
    entry_objects.first.request.headers['User-Agent'].should == "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:21.0) Gecko/20100101 Firefox/21.0"
    entry_objects.first.request.headers['Accept'].should == "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    entry_objects.first.request.headers['Accept-Language'].should == "de-de,de;q=0.8,en-us;q=0.5,en;q=0.3"
    entry_objects.first.request.headers['Accept-Encoding'].should == "gzip, deflate"
    entry_objects.first.request.headers['Connection'].should == "keep-alive"
  end

  its 'entry objects have objects with response data' do
    entry_objects = archive.entries

    entry_objects.first.response.class.should be HttpArchive::Response

    entry_objects.first.response.status.class.should be Fixnum
    entry_objects.first.response.status.should == 302

    entry_objects.first.response.status_text.class.should be String
    entry_objects.first.response.status_text.should == "Moved Temporarily"

    entry_objects.first.response.http_version.class.should be String
    entry_objects.first.response.http_version.should == "HTTP/1.1"

    entry_objects.first.response.cookies.class.should be Array
    entry_objects.first.response.cookies.should == []

    entry_objects.first.response.content.class.should be Hash
    entry_objects.first.response.content.should == {"mimeType"=>"text/html", "size"=>0}

    entry_objects.first.response.redirect_url.class.should be String
    entry_objects.first.response.redirect_url.should == "blog/index.php"

    entry_objects.first.response.headers_size.class.should be Fixnum
    entry_objects.first.response.headers_size.should == 281

    entry_objects.first.response.body_size.class.should be Fixnum
    entry_objects.first.response.body_size.should == 0

    entry_objects.first.response.headers.class.should be Hash
    entry_objects.first.response.headers['Date'].should == "Tue, 28 May 2013 20:16:21 GMT"
    entry_objects.first.response.headers['Server'].should == "Apache"
    entry_objects.first.response.headers['Location'].should == "blog/index.php"
    entry_objects.first.response.headers['Cache-Control'].should == "max-age=7200"
    entry_objects.first.response.headers['Expires'].should == "Tue, 28 May 2013 22:16:21 GMT"
    entry_objects.first.response.headers['Content-Length'].should == "0"
    entry_objects.first.response.headers['Keep-Alive'].should == "timeout=5, max=50"
    entry_objects.first.response.headers['Connection'].should == "Keep-Alive"
    entry_objects.first.response.headers['Content-Type'].should == "text/html"
  end

  its 'entry objects have cache data' do
    entry_objects = archive.entries
    entry_objects.first.cache.class.should be Hash
    entry_objects.first.cache.should == {}
  end

  its 'entry objects have timings data' do
    entry_objects = archive.entries
    entry_objects.first.timings.class.should be Hash
    entry_objects.first.timings.should == {"blocked"=>15, "dns"=>0, "connect"=>0, "send"=>0, "wait"=>39, "receive"=>0}
  end

  its 'entry objects have the server-ip-address' do
    entry_objects = archive.entries
    entry_objects.first.server_ip_address.class.should be String
    entry_objects.first.server_ip_address.should == "91.239.200.165"
  end

  its 'entry objects have data on the connection' do
    entry_objects = archive.entries
    entry_objects.first.connection.class.should be String
    entry_objects.first.connection.should == "80"
  end
end


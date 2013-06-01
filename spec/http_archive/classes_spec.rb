require_relative '../spec_helper'

describe HttpArchive::Creator do
  it 'has a name and version' do
    creator = HttpArchive::Creator.new
    creator.respond_to?(:name).should be true
    creator.respond_to?(:version).should be true
  end
end

describe HttpArchive::Browser do
  it 'has a name and version' do
    browser = HttpArchive::Browser.new
    browser.respond_to?(:name).should be true
    browser.respond_to?(:version).should be true
  end
end

describe HttpArchive::Page do
  it 'has started datetime, id, title, and load times' do
    page = HttpArchive::Page.new
    page.respond_to?(:started_datetime).should be true
    page.respond_to?(:id).should be true
    page.respond_to?(:title).should be true
    page.respond_to?(:on_content_load).should be true
    page.respond_to?(:on_load).should be true
  end
end

describe HttpArchive::Entry do

  let(:entry) { HttpArchive::Entry.new }

  it 'has info on pageref, started datetime, duration, request and response' do
    entry.respond_to?(:pageref).should be true
    entry.respond_to?(:started_datetime).should be true
    entry.respond_to?(:time).should be true
    entry.respond_to?(:request).should be true
    entry.respond_to?(:response).should be true
  end

  it 'has info on cache, timings, ip-address and connection' do
    entry.respond_to?(:cache).should be true
    entry.respond_to?(:timings).should be true
    entry.respond_to?(:server_ip_address).should be true
    entry.respond_to?(:connection).should be true
  end
end

describe HttpArchive::Request do

  let(:request) { HttpArchive::Request.new }

  it 'has info on method, url, http version and cookies' do
    request.respond_to?(:http_method).should be true
    request.respond_to?(:url).should be true
    request.respond_to?(:http_version).should be true
    request.respond_to?(:cookies).should be true
  end

  it 'has info on query-string, headers, header-size and body-size' do
    request.respond_to?(:query_string).should be true
    request.respond_to?(:headers).should be true
    request.respond_to?(:headers_size).should be true
    request.respond_to?(:body_size).should be true
  end

end


describe HttpArchive::Response do

  let(:response) { HttpArchive::Response.new }

  it 'has info on status, statusText, http-version, cookies, headers' do
    response.respond_to?(:status).should be true
    response.respond_to?(:status_text).should be true
    response.respond_to?(:http_version).should be true
    response.respond_to?(:cookies).should be true
    response.respond_to?(:headers).should be true
  end

  it 'has info on content, redirect-url, headers-size and body-size' do
    response.respond_to?(:content).should be true
    response.respond_to?(:redirect_url).should be true
    response.respond_to?(:headers_size).should be true
    response.respond_to?(:body_size).should be true
  end

end

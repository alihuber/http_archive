# http_archive

Interaction with HTTP Archives, loosely following the interface of the Archive::HAR Perl module.
This Ruby library provides an API to HTTP Archive (.har) files. .har files are JSON-formatted files which contain data about browser interaction with a web page, such as load data, cookie data, load times and URLs of artifacts.

More on HTTP Archives:   
[Wikipedia](http://en.wikipedia.org/wiki/.har)   
[HAR Specification](https://dvcs.w3.org/hg/webperf/raw-file/tip/specs/HAR/Overview.html)   

## Installation

    $ gem install http_archive

to use in your script:

    require 'http_archive'


## Usage

http_archive encapsulates all parts of a .har-file as an 'archive' object and fields of that object.
To start, you create an HttpArchive::Archive object with a String or File as parameter like so:

    archive = HttpArchive::Archive.new(File.open('/myfile.har', 'r'))

The 'archive' object now holds data from the archive as attributes, namely the following fields which are objects themselves:

* A 'browser' object with 'name' and 'version' fields
* A 'creator' object with 'name' and 'version' fields
* A 'pages'-array with 'page' objects
* An 'entries'-array with 'entry' objects

A 'page' object holds data about the page interaction as a whole: When the interaction started, page title, overall load time and so forth. An 'entry' object holds information about every interaction made for that page, such as: duration, request  and response data, duration, server information...

To interact with that data, you query the 'archive' object. Examples:

    puts archive.browser.name # => "Firefox"
    puts archive.creator.name # => "Firebug"
    all_pages = archive.pages # normally just one
    puts all_pages.first.on_load # => 6745, 6.7 seconds load time

The 'entry' objects hold data of the requests and responses as objects as well, with the header data as a Hash:

    first_entry = archive.entries.first
    puts first_entry.request.http_method # => "GET"
    puts first_entry.request.headers['Connection'] # => "keep-alive"
    # More interesting stuff is here:
    puts first_entry.response.content # => {"mimeType"=>"text/html", "size"=>0}
    puts first_entry.response.status # => 200
    puts page.entry.time # => 54

For more info, see the [docs](http://rubydoc.info/github/alihuber/http_archive/master/index) for each class.
To summarize the data, http_archive can print out a table representation like the one you are used to from Firebug et cetera:

    archive.print_table

gives you this:

    Metrics for: 'Software is hard', 26 Requests, 0.36MB downloaded. Load time: 6.745s

    GET http://www.janodvarko.cz/        302 Moved Temporarily    0.0 KB     0.054s
    GET /index.php                       301 Moved Permanently    0.0 KB     0.469s
    GET http://www.janodvarko.cz/blog/   200 OK                   52.95 KB   2.593s
    GET /l10n.js?ver=20101110            200 OK                   0.31 KB    0.065s
    GET /prototype.js?ver=1.6.1          200 OK                   139.85 KB  1.06s
    GET /wp-scriptaculous.js?ver=1.8.3   200 OK                   2.94 KB    0.136s
    GET /effects.js?ver=1.8.3            200 OK                   38.47 KB   0.665s
    GET /geshi.css                       200 OK                   1.03 KB    0.261s
    GET /lightbox.css                    200 OK                   1.42 KB    0.269s
    GET /lightbox.js                     200 OK                   23.84 KB   0.55s
    GET /rss.gif                         200 OK                   0.62 KB    1.114s
    GET /x.png                           200 OK                   1.37 KB    1.151s
    GET /useincommandline.png            200 OK                   21.55 KB   2.488s
    GET /red-text.png                    200 OK                   18.97 KB   2.778s
    GET /simple-log.png                  200 OK                   27.14 KB   3.135s
    GET /start-button.png                200 OK                   11.29 KB   2.29s
    GET /wordpress.gif                   200 OK                   0.52 KB    2.316s
    GET /creativebits.gif                200 OK                   0.34 KB    2.323s
    GET /urchin.js                       200 OK                   22.68 KB   1.476s
    GET /style.css                       200 OK                   9.24 KB    0.43s
    GET /quote.gif                       200 OK                   1.62 KB    1.716s
    GET /sidebar_top.gif                 200 OK                   0.11 KB    1.767s
    GET /sidebar_bottom.gif              200 OK                   0.11 KB    1.797s
    GET /&utmac=UA-3586722-1&utmcc=__u   200 OK                   0.04 KB    1.318s
    GET /loading.gif                     200 OK                   2.77 KB    0.071s
    GET /closelabel.gif                  200 OK                   0.98 KB    0.089s



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

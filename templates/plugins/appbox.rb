require 'rubygems'
require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'digest/md5'

module Jekyll
  class AppBox < Liquid::Tag

    @id = ''
    @store = ''
    @style = ''
    
    def initialize(tag_name, markup, tokens)
      super
      @result = Hash.new

      @resultarray = ['icon', 'name', 'url', 'version', 'price', 'developer', 'developerurl','rating','screenshots']

      @cachefolder = File.expand_path "../.appboxcache", File.dirname(__FILE__)
      FileUtils.mkdir_p @cachefolder

      if markup =~ /([A-Za-z]+)(\s[A-Za-z]+\s|\s)([A-Za-z._0-9]+)/i
        @id = $3.strip
        @style = $2.strip
        @store = $1.strip
      else
        puts "Error with Markup. Your Values -- Id: #{@id} -- Style: #{@style} -- Store: #{@store}"
      end
    end

    def render(context)
      # Get ID of post to generate identifying MD5 hash
      @post_id = context["page"]["id"]
      # make sure to pass only posts with id
      unless @post_id.nil?
        if File.exist? get_cached_file(@store, @id, @post_id)
          get_cached_data(@id)
        else
          if @store == 'appstore'
            apple_fetch_data(@id)
          elsif @store == 'googleplay'
            googleplay_fetch_data(@id)
          end
        end

        out = ''
        out += get_small_style

        if @style == 'screenshots'
          out += get_screenshot_style
        end
        out += get_footer

        %(#{out})
      end
    end


    def get_small_style

      small = ''
      small +=  "<p><div class=\"appbox\"><a class=\"appbutton\" href=\"#{@result["url"]}\">"
      if @store == 'appstore'
        small += "Go to <br />AppStore"
      elsif @store == 'googleplay'
        small += "Go to <br /> PlayStore"
      end
      small += "</a>"
      small += "<div><a href=\"#{@result["url"]}\">"
      small +=  "<img class=\"appicon\" src=\"#{@result["icon"]}\" /></a></div>"
      small +=  "<div class=\"appdetails\"><div class=\"apptitle\"><a href=\"#{@result["url"]}\">#{@result["name"]}</a></div>"
      small +=  "<div class=\"developer\"><a href=\"#{@result["developerurl"]}\">#{@result["developer"]}</a></div>"
      small +=  "<div class=\"price\">#{@result["price"]} #{get_rating_stars(@result["rating"])}</div>"
      small +=  "</div>"
      small
    end

    def get_footer
      footer = ''
      footer += "</div></p>"
      footer
    end

    def get_screenshot_style
      screenshots = ''

      screenshots += "<div class=\"screenshots\"><div class=\"slider\"><ul>"
      unless @result["screenshots"].nil?
        @result["screenshots"].each do |screenshot|
          screenshots += "<li><img src=\"#{screenshot}\" /></li>"
        end
      end
      screenshots += "</ul></div></div>"
      screenshots
    end

    def get_rating_stars(value)
      stars = ''
      value.to_i.times do |star|
        stars += "<span class=\"rating star\"></span>"
      end
      unless value.modulo(1) < 0.5
        stars += "<span class=\"rating half-star\"></span>"
      end
      halfstar = 0
      halfstar = 1 if value.modulo(1) >= 0.5
      (5 - value.to_i - halfstar).times do |emptystar|
        stars += "<span class=\"rating unstar\"></span>"
      end
      stars
    end

    def apple_fetch_data(app_id)
      requestarray = ['artworkUrl512','trackName','trackViewUrl','version','formattedPrice','artistName','artistViewUrl', 'averageUserRatingForCurrentVersion']

      url = "http://itunes.apple.com/lookup?id=#{app_id}"
      resp = Net::HTTP.get_response(URI.parse(url))
      app_data = JSON.parse resp.body

      if app_data["results"][0].has_key?("ipadScreenshotUrls")
        requestarray << "ipadScreenshotUrls"
      else
        requestarray << "screenshotUrls"
      end


      @resultarray.zip(requestarray).each do |result,request|
        @result[result] = app_data["results"][0][request]
      end

      save_cached_data(get_cached_file(@store, app_id, @post_id))
    end

    def googleplay_fetch_data(app_id)
      base_url = 'https://play.google.com'

      doc = Nokogiri::HTML(open("#{base_url}/store/apps/details?id=#{app_id}"), nil, 'utf-8')

      # requestarray hints:
      # 1) App Icon e.g. big icon in Chrome Webstore
      # 2) Name of the app
      # 3) URL to the app
      # 4) Versionnumber of the app
      # 5) Price of the app
      # 6) Developername
      # 7) Developer URL
      # 8) Rating value
      # 9) Array of screenshots

      requestarray = [ doc.css("div.cover-container img").first['src'],
                        doc.css("div.info-container div.document-title div").first.content,
                        base_url + "/store/apps/details?id=#{app_id}",
                        doc.css("div[itemprop=softwareVersion]").first.content.strip,
                        doc.css("meta[itemprop=price]").first['content'],
                        doc.css("div.info-container div a.document-subtitle").first.content,
                        base_url + doc.css("div.info-container div a.document-subtitle").first['href'],
                        doc.css("div.tiny-star div.current-rating").first['style'][/\d+\.\d+/].to_f.round(1) / 100 * 5, 
                        doc.css("div.thumbnails img.screenshot").collect {|thumb| thumb['src']}
                         ]
      @resultarray.zip(requestarray).each do |result, request|
        @result[result] = request
      end

      save_cached_data(get_cached_file(@store, app_id, @post_id))
    end

    def get_cached_data(app_id)
      cached_file = get_cached_file(@store, app_id, @post_id)
      @result = JSON.parse File.read cached_file if File.exist? cached_file
      return nil if @result.nil?
    end

    def save_cached_data(cached_file)
      File.open(cached_file, "w") do |file|
        file.write @result.to_json
      end
    end

    def get_cached_file(store, app_id, post_id)
      File.join @cachefolder, "#{store}_#{app_id}-#{Digest::MD5.hexdigest(post_id)}.cache"
    end

  end
end

Liquid::Template.register_tag('appbox', Jekyll::AppBox)


require 'nokogiri'
require 'open-uri'
require 'image_size'
require 'yaml'

class AppleTvBase

  def initialize(medium)
    config = YAML.load_file("config/stage.yml")
    environment = config["urls"]["apple_tv"]

    puts "taken from config #{environment}"
    if medium.eql?'atv'
      @medium = medium
      Capybara.configure do |config|
        puts "Found it"
        config.run_server = false
        config.app_host   = environment
        @base_url = environment
        #Capybara.javascript_driver = :poltergeist
      end
    end
  end

  def xml_validation(url)
    begin
      bad_doc = Nokogiri::XML(open(url)) { |config| config.strict }
    rescue Nokogiri::XML::SyntaxError => e
      puts "caught exception: #{e}"
    end
  end

  def verify_main_site
    counter = 0
    nodeset = get_urls

    while counter < nodeset.length
      xml_validation(nodeset[counter].text)
      puts "now checking for #{nodeset[counter].text}"
      counter+=1
      unless nodeset[counter].nil?
        #@driver.get nodeset[counter].text
        xml_validation(nodeset[counter].text)
      end
    end
  end

  def get_urls
    #IGNORE CERTIFICATES: @doc = Nokogiri::HTML(open(my_url,  :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
    #@doc = Nokogiri::HTML(open(my_url,  :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

    if @medium.eql?'super'
      navigation_main_url = @base_url + "super/navigation"
    else
      navigation_main_url = @base_url + "/start/navigation"
    end
    puts "Found navigation URL: #{navigation_main_url}"

    xml_validation(navigation_main_url)
    doc = Nokogiri::XML(open(navigation_main_url))
    nodeset = doc.xpath('//url')
    nodeset.map {|element| element["url"]}.compact
    nodeset
  end

  def verify_super_start_availability
    start_time = Time.now
    urls = get_urls
    text_to_write_to_file = ""

    urls.each do|url|
      #TODO: fjern hardkoding
      unless (url.text.include?'epgtoday') || (url.text.include?'help')
        url = url.text
        puts "now navigating #{url}"
        #@driver.get url
        doc = Nokogiri::XML(open(url))

        str1_markerstring = "'("
        str2_markerstring = ")'"

        string = doc.xpath("//*/@onPlay").to_s
        strings = string.split(';')
        strings.each do|elem|
          id_element = elem[/#{str1_markerstring}(.*?)#{str2_markerstring}/m, 1].to_s
          if id_element == id_element.upcase
            #Now verifying prog ids
            puts id_element
            text_to_write_to_file+=id_element +"\n"

            unless false# is_available(id_element)
              #@test_receipt.add_error(id_element,'Element does not have a valid id')
              #TODO: Failure check
            end
          else
            unless id_element.eql?'nrksuper'
              #TODO: add check for episodes /get season_id
            end
          end
        end
      end
    end

    end_time = Time.now - start_time
    puts "Elapsed time: #{end_time}"
    puts "This is the list you've created with prog ids: "
    puts text_to_write_to_file
  end

  def get_paths
    url = @base_url + "/paths"
    #@driver.get url
    doc = JSON.parse(open(url).read)
  end

  def check_non_buildable_paths
    doc = get_paths
    doc.each do|elem,value|
      if ['live','superepg'].include? elem
        puts elem,value
        xml_validation(value)
      elsif elem.eql?'epoch'
        #TODO: what to check on this element?
        puts "validate epoch"
      end
    end
  end

  def verify_pages_from_paths
    #TODO remove hardcoded progIDs
    paths = get_paths
    paths.each do|elem,value|
      if elem.eql?'player'
        puts "Test player: player()"
        if @medium.eql?'super'
          puts "test medium in super: Yo dawg"
          tv_channel = 'nrksuper'
          test_path_endpoint(tv_channel,value)
        end
      elsif elem.eql?'playerBySeries'
        puts "Test playerBySeries"
        if @medium.eql?'super'
          series = 'jenter'
        else
          series = 'side-om-side'
        end
        test_path_endpoint(series,value)
      elsif elem.eql?'playerlive'
        puts "playerLive"
        if @medium.eql?'super'
          test_path_endpoint('nrksuper',value)
        else
          test_path_endpoint('nrk1',value)
        end
      elsif elem.eql?'details'
        puts "by details"
        if @medium.eql?'super'
          test_path_endpoint('MSUB15500415',value)
        end
      elsif elem.eql?'series'
        puts value

      elsif elem.eql?'seriesLatestEpisode'
        puts value
      elsif elem.eql?'season'
        puts value
      elsif elem.eql?'seasonByEpisode'
        puts value
      elsif elem.eql?'live'
        puts value
      elsif elem.eql?'livebuffer'
        puts value
      elsif elem.eql?'epg'
        puts value
      elsif elem.eql?'superepg'
      end
    end
  end

  def test_path_endpoint(tv_channel,path)
    path = path.sub!(path.split('/')[-1],"") + tv_channel
    puts "path to be tested #{path}"
    xml_validation(path)
  end


end
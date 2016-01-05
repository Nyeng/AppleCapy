require 'nokogiri'
require 'open-uri'
require 'image_size'


class AppleTvBase

  def initialize(medium)
    if medium.eql?'atv'
      @medium = medium
      Capybara.configure do |config|
        puts "Found it"
        config.run_server = false
        config.app_host   = 'https://atvstage.nrk.no'
        @base_url = 'https://atvstage.nrk.no'
        #Capybara.javascript_driver = :poltergeist
      end
     #visit '/'
     # sleep 10
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

end
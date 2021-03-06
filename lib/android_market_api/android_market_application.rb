# Copyright 2011 by Helder Vasconcelos (heldervasc@bearstouch.com).
# All rights reserved.

# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.

require 'rubygems'
require 'open-uri'
require 'hpricot' 

class AndroidMarketApplication 
    
  attr_accessor :package, :language,:name, :current_version,:price, :ratting_value,:ratting_count, :updated,:sdk_required, :category,:downloads, :size,:contentRating,:description,:screenshots,:developer_name,:icon,:update_text
    
  @@debug=0
  ###########################################################################################
  #  Contructor: Example Usage AndroidMarketApplication.new("com.bearstouch.smsscheduler")
  ############################################################################################
  def initialize(package,language='en')
    
    @package=package
    @language=language;            
    @name=""              # Application Name
    @current_version=""    # Application Current Version
    @price=""              # Application Price
    @ratting_value=""      # Ratting Value
    @ratting_count=""      # Nr of Votes
    @updated=""           # Last Upfate datetime
    @sdk_required=""      # SDK Required
    @category=""          # Category
    @downloads=""         # Ratting 
    @size=""               # Application Size
    @contentRating=""     # Content Ratting
    @description=""       # Application description
    @developer_name=""    # Developer Name 
    @icon=""              # Icon URL 
    @screenshots=Array.new
    @update_text=Array.new
    parseInAndroidMarket(language) 
  end  
  
  ############################################
  # =>  Parse Default Page for your localization from Android Market 
  ############################################
  def parseInAndroidMarket(language)
    
    url="https://market.android.com/details?id="+@package+"&hl="+language  
    puts "Getting URL="+url if @@debug == 1
    doc = Hpricot(open(url,'User-Agent' => 'ruby'))  
    fill_current_version(doc.root)  
    fill_ratting_value(doc.root)
    fill_ratting_count(doc.root)
    fill_updated_at(doc.root)
    fill_sdk_required(doc.root)
    fill_category(doc.root)
    fill_downloads(doc.root)
    fill_size(doc.root)
    fill_price(doc.root)
    fill_content_rating(doc.root)
    fill_application_name(doc.root)
    fill_description(doc.root)
    fill_screenshots(doc.root)
    fill_developer_name(doc.root)
    fill_icon(doc.root)    
    fill_changed_text(doc.root)
    
  end  
  
  def fill_application_name(doc)
     element=doc.at("dl[@class='doc-metadata-list']/meta[@itemprop='name']")
     if element
       @name=element['content']
       puts "Apllication name ="+@name.to_s  if @@debug == 1
     end
  end
  
  def fill_current_version(doc)    
    element=doc.at("dl[@class='doc-metadata-list']/dd[@itemprop='softwareVersion']")
    if element 
     @current_version=element.inner_html
     puts "Apllication Version="+@current_version.to_s if @@debug == 1
    end
  end
  
  def fill_price(doc)
    element=doc.at("dl[@class='doc-metadata-list']/dd[@itemprop='offers']/span[@itemprop='price']")
    if element 
      @price=element.inner_html
      puts "Apllication Price="+@price.to_s if @@debug == 1
    end    
  end
  
  def fill_ratting_value(doc)
    element=doc.at("dl[@class='doc-metadata-list']/dd[@itemprop='aggregateRating']/div[@itemprop='ratingValue']")
    if element 
      @ratting_value=element['content']
      puts "Apllication Ratting Value ="+@ratting_value.to_s if @@debug == 1
    end
  end
  
  def fill_ratting_count(doc)
    element=doc.at("dl[@class='doc-metadata-list']/dd[@itemprop='aggregateRating']/span[@itemprop='ratingCount']")
    if element 
      @ratting_count=element.inner_html
      puts "Apllication ratting_count="+@ratting_count.to_s if @@debug == 1
    end
  end
  
  def fill_updated_at(doc) 
    element=doc.at("dl[@class='doc-metadata-list']/dd/time[@itemprop='datePublished']")
    if element 
      @updated=element.inner_html
      puts "Apllication updated="+@updated.to_s if @@debug == 1
    end
  end
  
  def fill_sdk_required(doc)
    element=doc.at("dl[@class='doc-metadata-list']/dt[@itemprop='operatingSystems']")
    if element 
      @sdk_required=element.next_node.inner_html
      puts "Apllication SDK="+@sdk_required.to_s   if @@debug == 1
    end
  end
  
  def fill_category(doc)
     #@category=doc.at("dl[@class='doc-metadata-list']/dt[@itemprop='operatingSystems']").next_node.inner_html
    #  puts "Apllication category="+@category.to_s   if @@debug == 1
  end

  def fill_downloads(doc)
    element=doc.at("dd[@itemprop='numDownloads']")
    if element 
      @downloads=element.children.first
      puts "Apllication install category="+@downloads.to_s if @@debug == 1
    end
  end

  def fill_size(doc)
    element=doc.at("dl[@class='doc-metadata-list']/dd[@itemprop='fileSize']")
    if element 
      @size=element.inner_html
      puts "Apllication Size="+@size.to_s if @@debug == 1
    end
  end
  
  def fill_content_rating(doc)
    element=doc.at("dl[@class='doc-metadata-list']/dd[@itemprop='contentRating']")
    if element 
      @contentRating=element.inner_html
      puts "Apllication Content Rating="+@contentRating.to_s if @@debug == 1
    end
  end

  def fill_description(doc)
    element=doc.at("div[@id='doc-original-text']")
    if element
      @description=element.inner_html
      puts "Apllication Description ="+@description.to_s   if @@debug == 1
    end
  end
   
  def fill_screenshots(doc)
    element_ar=(doc/"div[@class='screenshot-carousel-content-container']/img")
    if element_ar 
      element_ar.each  do |img|         
        puts "addding "+img['src'].to_s if @@debug == 1   
        @screenshots.push(img['src'].to_s)
      end
    end
  end

  def fill_developer_name(doc) 
    element=doc.at("a[@class='doc-header-link']")
    if element
      @developer_name=element.inner_html
      puts "Apllication Author= "+@developer_name.to_s if @@debug == 1
    end
  end

  def fill_icon(doc)    
    element=doc.at("div[@class='doc-banner-icon']/img")
    if element 
      @icon=element['src']
      puts "Apllication Icon= "+@icon.to_s if @@debug == 1
    end
  end
  
  def fill_changed_text(doc)  
    element_ar=(doc/"div[@class='doc-whatsnew-container']/ol/li")  
    if element_ar 
     element_ar.each  do |parag|
        puts "Apllication Update= "+parag.inner_html if @@debug == 1
        @update_text << parag.inner_html
     end
    end
  end
   
  private :fill_current_version, :fill_ratting_value, :fill_ratting_count,:fill_updated_at,:fill_sdk_required,:fill_category,:fill_downloads,:fill_size,:fill_price,:fill_content_rating,:fill_application_name,:fill_description,:fill_screenshots,:fill_developer_name,:fill_icon,:fill_changed_text,:parseInAndroidMarket
   
  def to_s()
    puts "-------------------------------------------------------------"
    puts " Application Name = "+@name.to_s
    puts " Application Package = "+@package.to_s
    puts " Application Current Version = "+@current_version.to_s
    puts " Application Price = "+@price.to_s
    puts " Application Ratting Value = "+@ratting_value.to_s
    puts " Application Ratting Count = "+@ratting_count.to_s
    puts " Application Updated = "+@updated.to_s
    puts " SDK required = "+@sdk_required.to_s
    puts " Category = "+@category.to_s
    puts " Nr of Downloads = "+@downloads.to_s
    puts " Size = "+@size.to_s
    puts " Content Ratting = "+@contentRating.to_s
    puts " Application description = "+@description.to_s
    puts " Developer Name = "+@developer_name.to_s
    puts " Icon URL = "+@icon.to_s
    puts "-------------------------------------------------------------"
  end  
  
end  



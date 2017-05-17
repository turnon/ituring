require 'open-uri'
require 'nokogiri'

module Ituring
  class Book

    attr_reader :url, :name, :tags, :status,
      :img,
      :approaches, :ebook_formats, :ebook_price, :hard_copy_price,
      :series, :date, :isbn, :org_name, :org_isbn

    def initialize node
      @url = URL + node.at_css('a')['href']
      get_detail
    rescue => e
      STDERR.puts "#{url} : #{e}"
      raise e
    end

    def get_detail
      detail = Nokogiri::HTML(open url)
      @name = detail.at_css('h2').text
      @tags = detail.css('.tags a').map(&:text)
      @status = detail.css('.book-status .label').text
      @img = detail.at_css('.page-book-head .book-img img')['src']
      @approaches = detail.css('.buy-btns a').map(&:text)
      get_price detail
      get_publish_info detail
    end

    def get_price detail_page
      detail_page.
        css('.book-approaches dl').
        each do |dl|
          dd = dl.at_css('dd')
          case dl.at_css('dt').text
          when '电子书'
            @ebook_price = dd.text.gsub(/[^\d\.]/, '').to_f
          when '格式'
            @ebook_formats = dd.text.split(/\//).map(&:strip)
          when '纸质版定价'
            @hard_copy_price = dd.text.gsub(/[^\d\.]/, '').to_f
          end
        end
    end

    def get_publish_info detail_page
      detail_page.
        css('.publish-info li').
        each do |li|
          case li.at_css('strong').text
          when '系列书名'
            @series = extract_info li
          when '出版日期'
            @date = extract_info li
          when '书　　号'
            @isbn = extract_info(li).gsub(/[^\d-]/, '')
          when '原书名'
            @org_name = extract_info li
          when '原书号'
            @org_isbn = extract_info(li).gsub(/[^\d-]/, '')
          end
        end
    end

    def extract_info li
      a = li.at_css('a')
      a ? a.text : li.inner_html().gsub(/.*<\/strong>/, '')
    end

    def marshal_dump
      instance_variables.each_with_object({}) do |name, hash|
        hash[name[1..-1]] = instance_variable_get name
      end
    end

    def marshal_load dump
      dump.each do |k, v|
        instance_variable_set "@#{k}", v
      end
    end
  end
end

require 'open-uri'
require 'nokogiri'

module Ituring
  class Book

    attr_reader :url, :name, :tags, :status, :approaches, :ebook_price, :hard_copy_price

    def initialize node
      @url = URL + node.at_css('a')['href']
      get_detail
    end

    def get_detail
      detail = Nokogiri::HTML(open url)
      @name = detail.at_css('h2').text()
      @tags = detail.css('.tags a').map(&:text)
      @status = detail.css('.book-status .label').text()
      @approaches = detail.css('.buy-btns a').map(&:text)
      @ebook_price, @hard_copy_price = detail.
        css('.book-approaches dd').
        map(&:text).
        map(&:strip).
        select{|str| str =~ /\d/}.
        map{|p| p.gsub(/[^\d\.]/, '').to_f}
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

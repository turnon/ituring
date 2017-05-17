require "ituring/version"
require "ituring/book"
require "page_by_page"
require "parallel"

module Ituring

  URL = 'http://www.ituring.com.cn'
  MAX = 999999999999

  def self.newest pages: MAX, books: MAX
    pages = books / 20 if books < MAX

    nodes = ::PageByPage.fetch do
      url 'http://www.ituring.com.cn/book?tab=book&sort=new&page=<%= n %>'
      selector '.block-books li'
      from 0
      to pages
      threads Parallel.processor_count
    end

    nodes = nodes[0...books]

    pg = Progress.new nodes.size

    Parallel.map(nodes, in_threads: Parallel.processor_count) do |node|
      pg.update
      Book.new node
    end
  end

  def self.dump path
    books = newest
    File.open(Pathname.new(path), 'w') do |f|
      str = Marshal.dump books
      f.puts str
    end
    books
  end

  def self.load path
    str = File.read Pathname.new(path)
    Marshal.load str
  end

  class Progress
    def initialize total
      @total, @count, @lock = total, 0, Mutex.new
    end

    def update
      @lock.synchronize do
        @count = @count.succ
        printf "\r%s => %s", Time.now.strftime('%F %T'), "#{@count}/#{@total}"
      end
    end
  end


end

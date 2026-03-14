#!/usr/bin/env ruby

require "fileutils"
require "optparse"

REPO = "https://github.com/kilate-foss/mate"

options = {
      debug: false,
      install: false
}

OptionParser.new do |opts|
      opts.banner = "Usage: build.rb [-d]"

      opts.on("-d", "--debug", "Build in Debug mode") do
            options[:debug] = true
      end

      opts.on("-i", "--install", "Installs the library") do
            options[:install] = true
      end
end.parse!

pwd = File.expand_path(File.dirname(__FILE__))
src_include = File.join(pwd, ".mate/include/mate")
dst_include = File.join(pwd, "Sources/CMate/include/mate")

def prepare_headers(pwd, src_include, dst_include)
      puts "Cloning repository..."
      FileUtils.rm_rf(File.join(pwd, ".mate"))
      system("git clone #{REPO} .mate") or abort("Git clone failed")

      puts "Copying headers..."

      FileUtils.rm_rf(dst_include)
      FileUtils.mkdir_p(dst_include)

      FileUtils.cp_r(Dir.glob("#{src_include}/*"), dst_include)

      puts "Headers copied."
end

prepare_headers(pwd, src_include, dst_include)

build_mode = options[:debug] ? "debug" : "release"
puts "Building Swift package (#{build_mode})..."

system("swift build -c #{build_mode}") or abort("Swift build failed")

if options[:install]
      PREFIX = ENV["PREFIX"] || "/usr"
      LIBDIR = "#{PREFIX}/mate/native_libs/libmatenative.so"
      FileUtils.mkdir_p("#{PREFIX}/mate/native_libs/")
      FileUtils.cp_r(".build/#{build_mode}/libMateNative.so", LIBDIR)
end

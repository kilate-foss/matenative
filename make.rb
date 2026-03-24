#!/usr/bin/env ruby

require "fileutils"
require "optparse"

REPO = "https://github.com/der-foss/derKilate"

options = {
      debug: false,
      install: false,
      clean: false
}

OptionParser.new do |opts|
      opts.banner = "Usage: build.rb [-d]"

      opts.on("-d", "--debug", "Build in Debug mode") do
            options[:debug] = true
      end

      opts.on("-c", "--clean", "Build in Debug mode") do
            options[:clean] = true
      end

      opts.on("-i", "--install", "Installs the library") do
            options[:install] = true
      end
end.parse!

pwd = File.expand_path(File.dirname(__FILE__))
src_include = File.join(pwd, ".kilate/include/kilate")
dst_include = File.join(pwd, "Sources/CKilate/include/kilate")

def prepare_headers(pwd, src_include, dst_include)
      puts "Cloning repository..."
      FileUtils.rm_rf(File.join(pwd, ".kilate"))
      system("git clone #{REPO} .kilate") or abort("Git clone failed")

      puts "Copying headers..."

      FileUtils.rm_rf(dst_include)
      FileUtils.mkdir_p(dst_include)

      FileUtils.cp_r(Dir.glob("#{src_include}/*"), dst_include)

      puts "Headers copied."
end

prepare_headers(pwd, src_include, dst_include) if options[:clean]

build_mode = options[:debug] ? "debug" : "release"
puts "Building Swift package (#{build_mode})..."

system("swift build -c #{build_mode}") or abort("Swift build failed")

if options[:install]
      PREFIX = ENV["PREFIX"] || "/usr"
      LIBDIR = "#{PREFIX}/kilate/native_libs/libkilatenative.so"
      FileUtils.mkdir_p("#{PREFIX}/kilate/native_libs/")
      FileUtils.cp_r(".build/#{build_mode}/libKilateNative.so", LIBDIR)
end

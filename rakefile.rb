require 'rake/testtask'
require 'rake/clean'

def version
  @version ||= begin
    `git describe --tags --always --dirty --long`.strip
  rescue
    'unknown'
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

file "dotgame/version.rb" do |t|
  File.open(t.name, "w") do |f|
    f.puts "module DotGame"
    f.puts "  VERSION = '#{version}'"
    f.puts "end"
  end
end

file "dotgame.rb" => "dotgame/version.rb"

file "dotgame.exy" => FileList['dotgame.rb', 'dotgame/**/*.rb'] do
  sh "mkexy dotgame.rb --help"
end

file "dotgame.exe" => 'dotgame.exy' do
  sh "exerb dotgame.exy"
  sh "upx dotgame.exe"
end

file "dotgame-#{version}.zip" => %w[dotgame.exe] do
  begin
    require 'archive/zip'
  rescue LoadError
    require 'rubygems'
    require 'archive/zip'
  end
  
  if File.exist?("dotgame-#{version}.zip")
    File.unlink("dotgame-#{version}.zip")
  end
  
  Archive::Zip.open("dotgame.zip", :r) do |orig|
    Archive::Zip.open("dotgame-#{version}.zip", :w) do |out|
      orig.each do |e|
        if e.zip_path =~ /bin\/dotgame.exe\z/i
          # replace with newer one
          out << Archive::Zip::Entry.from_file("dotgame.exe", {:zip_path => e.zip_path})
        else
          out << e
        end
      end
    end
  end
end

desc "exerb"
task "exe" => 'dotgame.exe'

desc "zip"
task "zip" => "dotgame-#{version}.zip"

CLEAN.include FileList['dotgame.exe', 'dotgame-*.zip', 'dotgame/version.rb']

desc 'Default: run tests'
task :default => [:test]

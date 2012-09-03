require 'rake/testtask'
require 'rake/clean'

def version
  @version ||= begin
    File.exist?('dotgame.rb') and
    File.read('dotgame.rb') =~ /^\s*VERSION\s*=\s*"([^"]+)/ and
    $1 or "unknown"
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

file "dotgame.exe" => FileList['dotgame.exy', 'dotgame.rb', 'dotgame/**/*.rb'] do
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

task "exe" => 'dotgame.exe'
task "zip" => "dotgame-#{version}.zip"

CLEAN.include 'dotgame.exe', FileList['dotgame-*.zip']

desc 'Default: run tests'
task :default => [:test]

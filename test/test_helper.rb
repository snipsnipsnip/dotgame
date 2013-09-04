require 'rubygems'
require 'shoulda/context'
require 'mocha'

%w[win32console redgreen].each do |lib|
  begin
    require lib
  rescue LoadError
    warn "load failed: #{lib}"
  end
end

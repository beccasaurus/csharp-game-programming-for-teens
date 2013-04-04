# Serve up the root directory
run Rack::Directory.new File.dirname(__FILE__)

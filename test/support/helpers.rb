# Load all helper files
helpers_dir = File.expand_path('../helpers', __FILE__)
Dir["#{helpers_dir}/*.rb"].each {|f| require f}

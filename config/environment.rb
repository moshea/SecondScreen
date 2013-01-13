# Load the rails application
require File.expand_path('../application', __FILE__)
require 'open-uri'
require 'mocha/setup'

# this is a terrible terrible hack to get the absolute path
# in the image url on json responses. TODO: remove!
IMAGE_HOST = "http://192.168.0.196:3000"
# Initialize the rails application
SecondScreen::Application.initialize!

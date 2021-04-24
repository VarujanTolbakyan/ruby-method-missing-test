require 'json'
require_relative './mixture'

class JsonDb
  include DefineCustomClass
  
  def initialize(json_filename)
    @json_filename = json_filename
  end

  attr_reader :json_filename
  
  def data
    @data ||= JSON.parse(IO.read(json_filename))
  end
  
  # Use this method to store updated properties on disk
  def serialize
    IO.write(json_filename, data.to_json)
  end
  
  private

  def method_missing(method_name, *args, &block)
    method_name = method_name.to_s
    if method_name.include? '='
      data[method_name.sub('=', '')] = args.first
    else
      create_property_named_class(method_name, data[method_name])
      data[method_name]
    end
  end
  
end

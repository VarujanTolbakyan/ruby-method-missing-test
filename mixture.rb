require 'active_support/inflector'

module DefineCustomClass

  def dynamically_create_class(class_name)
    return Object.const_get(class_name) if Object.const_defined?(class_name)

    Object.const_set(class_name, Class.new)
  end

  def create_property_named_class(class_prop_value, data_obj)
    class_prop_value = class_prop_value.singularize.capitalize
    return unless data_obj.is_a?(Array)

    data_obj.each { |obj| obj['class'] = class_prop_value }
  end

end

class Hash
  include DefineCustomClass

  undef_method :class

  private

  def method_missing(method_name, *args)
    method_name = method_name.to_s
    if method_name == 'class'
      dynamically_create_class(self['class'])
    else
      if method_name.include? '='
        self[method_name.sub('=', '')] = args.first
      else
        create_property_named_class(method_name, self[method_name])
        self[method_name]
      end
    end
  end

end

class NilClass
  
  private
  
  def method_missing(method_name, *args)
    self
  end

end

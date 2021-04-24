class Hash

  private

  def method_missing(method_name, *args)
    method_name = method_name.to_s
      if method_name.include? '='
        self[method_name.sub('=', '')] = args.first
      else
        self[method_name]
      end
  end

end

class NilClass
  
  private
  
  def method_missing(method_name, *args)
    self
  end
  
end
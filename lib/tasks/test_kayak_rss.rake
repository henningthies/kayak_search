desc "bug reverse_merge!"
task(:reverse_merge) do
  
  options = {
    :attr1 => "generic string"
  }
  
  def some_method(options = {})
    default_options = {
      :attr1 => "default string",
      :attr2 => "another string"
    }
    options.reverse_merge!(default_options)

    puts "*** options INSIDE the method call :"
    puts options.inspect
  end
  
  puts "*** options BEFORE the method call :"
  puts options.inspect
  
  some_method(options)
  
  puts "*** options AFTER the method call :"
  puts options.inspect
  
end

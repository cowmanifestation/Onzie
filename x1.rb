class Foo
  def initialize(params)
    @params = params
  end

  attr_reader :params

  def bar
    params[:chenoa]
  end
end

a = Foo.new(:chenoa => "Is a mexican")
puts a.bar

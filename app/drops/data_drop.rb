class DataDrop < Liquify::Drop
  def initialize(page)
    @fields = {}

    page.fields.each do |field|
      method = field.input_name
      @fields[method] = field.value
    end
  end

  def invoke_drop(method)
    if @fields.include? method
      @fields[method]
    else
      before_method(method)
    end
  end

  def to_liquid
    self
  end

  alias :[] :invoke_drop
end

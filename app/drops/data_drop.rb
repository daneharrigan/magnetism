class DataDrop < Liquid::Drop
  def initialize(page)
    field_names = page.fields.map(&:name)
    field_keys = page.fields.map(&:input_name)
    @fields = Hash[field_keys.zip]

    page.data.all(:conditions => { :field_name => field_names }).each do |datum|
      index = field_names.index datum.field_name
      key = field_keys[index]

      @fields[key] = datum.entry.try(:value)
    end
  end


  def invoke_drop(key)
    @fields[key]
  end

  alias :[] :invoke_drop
end

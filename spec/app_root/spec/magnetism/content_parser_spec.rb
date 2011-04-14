require 'spec_helper'

describe Magnetism::ContentParser do
  context 'when textile is entered' do
    it 'returns rendered html' do
      content = <<-STR
h1. Header 1

Paragraph 1
      STR

      output = Magnetism::ContentParser.new(content).invoke

      output.should =~ /<h1>Header 1<\/h1>/
      output.should =~ /<p>Paragraph 1<\/p>/
    end
  end

  context 'when the <m:code> block is entered' do
    it 'returns rendered html' do
      content = <<-STR
<m:code lang="ruby">
def foo(params)
  puts params.inspect
end
</m:code>
      STR

      output = Magnetism::ContentParser.new(content).invoke
      output.should =~ /<div class="code">/
      # the br tags are caused by RedCloth
      output.should_not =~ /<div class="code">.*<br \/>.*<\/div>/
    end
  end
end

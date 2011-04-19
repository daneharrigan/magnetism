require 'spec_helper'

describe Comment do
  it { should belong_to(:page) }
  it { should validate_presence_of(:author_ip) }
  it { should validate_presence_of(:body) }

  describe '#gravatar' do
    it 'returns the URL to the gravatar image' do
      comment = Factory.build(:comment)

      hash_value = Digest::MD5.hexdigest(comment.author_email)
      url = "http://gravatar.com/avatar/#{hash_value}"

      comment.gravatar.should == url
    end
  end

  describe '#comment' do
    before(:each) do
      content = <<-STR
Paragraph 1

Paragraph 2 <a href="#">Link 1</a>

Paragraph 3 with <em>italics</em>

Paragraph 4 with <strong>strong</strong>

<blockquote>
  Block quote 1
</blockquote>

<pre>Pre 1</pre>

<code>Code 1</code>

<h1>Not Here</h1>
<h2>Not Here</h2>
<div id="not-here">Not Here</div>
      STR

      @comment = Comment.new(:body => content)
    end

    it 'adds p tags' do
      @comment.body.should =~ /<p>.*<\/p>/m
    end

    it 'allows a href' do
      @comment.body.should =~ /<a href="#">Link 1<\/a>/m
    end

    it 'allows strong' do
      @comment.body.should =~ /<strong>strong<\/strong>/m
    end

    it 'allows em' do
      @comment.body.should =~ /<em>italics<\/em>/m
    end

    it 'allows blockquote' do
      @comment.body.should =~ /<blockquote>.*<\/blockquote>/m
    end

    it 'allows pre' do
      @comment.body.should =~ /<pre>.*<\/pre>/m
    end

    it 'allows code' do
      @comment.body.should =~ /<code>.*<\/code>/m
    end

    it 'does not allow h1' do
      @comment.body.should_not =~ /<h1>Not Here<\/h1>/m
    end

    it 'does not allow h2' do
      @comment.body.should_not =~ /<h2>Not Here<\/h2>/m
    end

    it 'does not allow div' do
      @comment.body.should_not =~ /<div id="not-here">Not Here<\/div>/m
    end
  end
end

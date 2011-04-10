Factory.define :comment do |f|
  f.sequence(:author_name)  { |n| "Author Name - #{n}" }
  f.sequence(:author_email) { |n| "author.name.#{n}@example.com" }
  f.sequence(:author_ip)    { |n| "10.0.0.#{n}" }
  f.sequence(:body)         { |n| "Comment Body - #{n}" }
end

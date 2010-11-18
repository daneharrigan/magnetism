Factory.define :user do |f|
  f.name 'John Doe'
  f.password 'password'
  f.password_confirmation 'password'
  f.sequence(:email) { |n| "john-doe-#{n}@example.com" }
  f.email_confirmed true  
end
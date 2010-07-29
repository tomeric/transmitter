Factory.define :application do |f|
  f.sequence(:name) { |n| "Application #{n}" }
  f.url             { Faker::Internet.url    }
end

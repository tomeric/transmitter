Factory.define :notifier do |f|
  f.sequence(:queue) { |n| "queue_#{n}"    }
  f.endpoint         { Faker::Internet.url }
  f.association(:application)
end

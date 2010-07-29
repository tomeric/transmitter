Factory.define :notification do |f|
  f.sequence(:queue) { |n| "queue_#{n}" }
  f.message          { "{ id: '1' }"    }
end

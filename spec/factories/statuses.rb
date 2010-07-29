# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :status do |f|
  f.association(:notification)
  f.association(:application)
  f.notifier_id { |status| Factory(:notifier, :application => status.application).id }
end

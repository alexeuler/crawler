FactoryGirl.define do
  factory :post do
    sequence (:owner_id) { |n| (n + 2)/3 }
    sequence (:vk_id) { |n| (n + 2) % 3 + 1 }
  end
end
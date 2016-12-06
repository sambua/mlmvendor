FactoryGirl.define do
  factory :item do
    sequence(:title) { |n| "Product name #{n}"}
    sequence(:slug) { |n| "product-name-#{n}"}
    price 1.5
    excerpt "Short description of product"
    description "Long description of product"

    factory :inactive_item, class: Item do
      status 0
      title "Not Active Product Title"
    end

    factory :active_item, class: Item do
      status 1
      title "Active Product"
    end

  end
end

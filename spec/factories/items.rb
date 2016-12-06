FactoryGirl.define do
  factory :item do
    sequence(:title) { |n| "Product name #{n}"}
    sequence(:slug) { |n| "product-name-#{n}"}
    status 1
    price 1.5
    excerpt "Short description of product"
    description "Long description of product"

    factory :draft_item, class: Item do
      status 0
    end

  end
end

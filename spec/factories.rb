FactoryGirl.define do

  factory :product do
    name "Awesome t-shirt"
    quantity  50
    tags "t-shirts, fashion, tops"
    categories { build_list :category, 1 }
  end

  factory :category do
    name "T-Shirts"
  end

end
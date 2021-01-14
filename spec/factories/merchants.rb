FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
    status { Faker::Number.between(from: 0, to: 1) }
  end
end

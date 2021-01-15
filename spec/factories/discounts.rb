FactoryBot.define do
  factory :discount do
    name { Faker::TvShows::StrangerThings.character }
    percentage { Faker::Number.between(from: 0, to: 100) }
    minimum { Faker::Number.between(from: 1, to: 20) }
  end
end

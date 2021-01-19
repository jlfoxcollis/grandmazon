FactoryBot.define do
  factory :discount do
    name { Faker::TvShows::StrangerThings.character }
    percentage { Faker::Number.between(from: 0, to: 15) }
    minimum { Faker::Number.between(from: 1, to: 5) }
  end

end

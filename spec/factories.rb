FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "foobar1"
    password_confirmation "foobar1"
  end

  factory :rating, :class => Rating do
    score 10
  end

  factory :rating2, :class => Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :beer do
    name "anonymous"
    brewery
    style "Porter"
  end

  factory :beer_stub, :class => Beer do
    name "anonymous"
    brewery
  end
end
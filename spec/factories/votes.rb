FactoryBot.define do
  factory :vote do
    user 
    val 1
  end

  factory :invalid_vote, class: 'Vote' do
    user
    value 2
  end
end

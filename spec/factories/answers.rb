FactoryGirl.define do
  
  sequence :body do |n|
    "Answer #{n} text"
  end

  factory :answer do
    question
    body "My answer"
    user
  end

  factory :invalid_answer, class: "Answer" do
    bidy nil
  end
end

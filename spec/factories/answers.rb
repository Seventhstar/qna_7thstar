FactoryGirl.define do
  factory :answer do
    question
    body "My answer"
    user
  end

  factory :invalid_answer, class: "Answer" do
    bidy nil
  end
end

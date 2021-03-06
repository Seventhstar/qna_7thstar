FactoryBot.define do
  sequence :title do |n|
    "testquestion #{n}"
  end

  factory :question do
    title
    body "MyText"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    bidy nil
    user
  end
end

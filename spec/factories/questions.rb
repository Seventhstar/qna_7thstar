FactoryGirl.define do
  sequence :title do |n|
    "testquestion #{n}"
  end

  factory :question do
    title "MyString"
    body "MyText"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    bidy nil
    user
  end
end

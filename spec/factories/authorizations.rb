FactoryBot.define do
  factory :authorization do
    user
    provider "github"
    uid "11223344"
  end
end

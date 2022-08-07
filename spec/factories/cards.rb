# == Schema Information
#
# Table name: cards
#
#  id           :bigint           not null, primary key
#  column       :string
#  issue_number :integer
#  note         :text
#  project      :string
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :card do
    issue_number { 1 }
    project { "MyString" }
    column { "MyString" }
    status { "MyString" }
    note { "MyText" }
  end
end

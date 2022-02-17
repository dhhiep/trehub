# == Schema Information
#
# Table name: configurations
#
#  id         :bigint           not null, primary key
#  key        :string           not null
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_configurations_on_key  (key) UNIQUE
#
FactoryBot.define do
  factory :configuration do
    key { "MyString" }
    value { "MyText" }
  end
end

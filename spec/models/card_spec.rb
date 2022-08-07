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
require 'rails_helper'

RSpec.describe Card, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

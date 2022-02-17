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
require 'rails_helper'

RSpec.describe Configuration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

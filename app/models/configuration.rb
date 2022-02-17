# frozen_string_literal: true

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
class Configuration < ApplicationRecord
  KEYS = %i[github_issue_updated_at].freeze

  validates :key, presence: true, uniqueness: true

  class << self
    KEYS.each do |method_name|
      define_method method_name do
        find_by_key(key_formatter(method_name))&.value
      end

      define_method "#{method_name}=" do |data|
        record = where(key: key_formatter(method_name)).first_or_initialize
        record.value = data
        record.save!

        record.value
      end
    end

    private

    def key_formatter(key)
      key.to_s.parameterize
    end
  end
end

# frozen_string_literal: true

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
class Card < ApplicationRecord
  belongs_to :issue, foreign_key: :issue_number, primary_key: :number, class_name: 'GithubIssue', optional: true
end

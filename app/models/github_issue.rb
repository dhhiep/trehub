# frozen_string_literal: true

# == Schema Information
#
# Table name: github_issues
#
#  id         :bigint           not null, primary key
#  assignees  :string
#  created_by :string
#  due_date   :string
#  favourite  :boolean          default(FALSE)
#  label      :string
#  milestone  :datetime
#  name       :string
#  number     :integer
#  pr_closed  :integer          default(0)
#  pr_opening :integer          default(0)
#  pr_url     :string
#  status     :string
#  track      :boolean          default(FALSE)
#  verified   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_issues_on_number  (number) UNIQUE
#
class GithubIssue < ApplicationRecord
  # Constants
  BACKLOG_DATE = Time.new(2000)
  LABELS = %w[backend web kitchen mobile bug android ios enhancement devops documentation].freeze
  PROJECT_STATUSES = {
    in_progress: ['Fixed, need Build/Deploy', 'To Do', nil, 'In Progress', 'Test Failed'],
    ready_to_test: ['Verified on DEV', 'Fixed, need Build/Deploy', 'Ready to Test'],
    finished: ['Done'],
  }.freeze

  # Attributes

  # Associations
  has_one :card, foreign_key: :issue_number, primary_key: :number

  # Validates
  validates :number, uniqueness: true

  # Callbacks
  before_create :update_track_flag

  # Scopes
  scope :active, -> {
    joins(:card).where(
      card: {
        column: (PROJECT_STATUSES[:in_progress] + PROJECT_STATUSES[:ready_to_test]).compact
      }
    )
  }

  # Class Methods
  class << self
    def pr_opening_counter
      where(track: true).sum(:pr_opening)
    end

    def milestones
      pluck(:milestone).uniq.compact.sort.reverse
    end

    def assignees
      pluck(:assignees).uniq.join(', ').split(', ').uniq
    end
  end

  # Delegate Methods

  # Instances Methods
  def trello_name
    "#{name} ##{number}"
  end

  def display_milestone
    milestone == GithubIssue::BACKLOG_DATE ? 'BACKLOG' : milestone&.strftime('%F')
  end

  private

  def update_track_flag
    self.track = should_track?
  end

  def should_track?
    return false if status == 'closed'

    whitelist_labels = %i[web backend mobile_web]
    matched_labels =
      label.split(', ').select do |lb|
        whitelist_labels.include?(lb.to_sym)
      end

    matched_labels.any?
  end
end

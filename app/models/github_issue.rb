# frozen_string_literal: true

class GithubIssue < ApplicationRecord
  validates :number, uniqueness: true

  before_create :update_track_flag

  BACKLOG_DATE = Time.new(2000)

  PROJECT_STATUSES = {
    in_progress: ['Fixed, need Build/Deploy', 'To Do', nil, 'In Progress', 'Test Failed'],
    ready_to_test: ['Verified on DEV', 'Fixed, need Build/Deploy', 'Ready to Test'],
    finished: ['Done'],
  }.freeze

  LABELS = %w[backend web mobile bug android ios enhancement devops documentation].freeze

  class << self
    def sync_remote_issues(total_pages: 1, per_page: 100)
      issues = Github::Fetcher.new.fetch(total_pages: total_pages, per_page: per_page)
      issues.each do |issue_number, issue_data|
        puts "Processing issue ##{issue_number} ..."

        record = where(number: issue_number).first_or_initialize

        data = {
          name: issue_data[:name],
          status: issue_data[:status],
          assignees: issue_data[:assignees].map { |assignee| assignee[:name] }.join(', '),
          label: issue_data[:labels].map { |label| label[:name] }.join(', '),
          milestone: issue_data[:milestone] || BACKLOG_DATE,
          project_column: issue_data[:project_column],
          project_name: issue_data[:project_name],
          pr_opening: issue_data.dig(:pull_requests, :total_open_pull_requests).to_i,
          pr_closed: issue_data.dig(:pull_requests, :total_merged_pull_requests).to_i,
          created_by: issue_data[:created_by],
        }

        record.update(data)
      end
    end

    def milestones
      pluck(:milestone).uniq.compact.sort.reverse
    end

    def assignees
      pluck(:assignees).uniq.join(', ').split(', ').uniq
    end
  end

  def trello_name
    "#{name} ##{number}"
  end

  def display_milestone
    milestone == GithubIssue::BACKLOG_DATE ? 'BACKLOG' : milestone&.strftime('%F')
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

  private

  def update_track_flag
    self.track = should_track?
  end
end

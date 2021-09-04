# frozen_string_literal: true

class GithubIssue < ApplicationRecord
  validates :number, uniqueness: true

  before_create :update_track_flag

  class << self
    def sync_remote_issues
      issues = Github::Fetcher.new.fetch
      issues.each do |issue_number, issue_data|
        puts "Processing issue ##{issue_number} ..."

        record = where(number: issue_number).first_or_initialize

        data = {
          name: issue_data[:name],
          status: issue_data[:status],
          assignees: issue_data[:assignees].map { |assignee| assignee[:name] }.join(', '),
          label: issue_data[:labels].map { |label| label[:name] }.join(', '),
          milestone: issue_data[:milestone],
          project_column: issue_data[:project_column],
          project_name: issue_data[:project_name],
        }

        record.update(data)
      end
    end

    def milestones
      pluck(:milestone).uniq
    end
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

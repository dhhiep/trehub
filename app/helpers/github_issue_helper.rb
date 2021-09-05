# frozen_string_literal: true

module GithubIssueHelper
  def github_issue_milestones_options
    GithubIssue.milestones.map do |milestone|
      [milestone, milestone.to_i]
    end
  end

  def github_issue_assignee_options
    GithubIssue.assignees.map do |assignee|
      [assignee, assignee]
    end
  end

  def github_issue_project_status_options
    GithubIssue::PROJECT_STATUSES.map do |key, _value|
      [key.to_s.gsub('_', ' ').titleize, key]
    end
  end

  def github_issue_labels_options
    GithubIssue::LABELS.map do |label|
      [label.to_s.gsub('_', ' ').titleize, label]
    end
  end
end

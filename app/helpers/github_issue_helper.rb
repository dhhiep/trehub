# frozen_string_literal: true

module GithubIssueHelper
  def github_issue_milestones_options
    GithubIssue.milestones.map do |milestone|
      next ['BACKLOG', milestone.to_i] if milestone == GithubIssue::BACKLOG_DATE

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

  def display_project_status(status)
    html_class =
      case status
      when 'To Do'
        :secondary
      when 'In Progress'
        :success
      when 'Test Failed'
        :danger
      when 'Fixed, need Build/Deploy'
        :info
      when 'Ready to Test'
        :warning
      when 'Testing'
        :warning
      when 'Verified on DEV'
        :success
      when 'Deployed to LIVE'
        :secondary
      when 'Done'
        :primary
      else
        status = "#{status} (Unknown)"
        :primary
      end

    <<-HTML
      <span class="btn btn-sm btn-#{html_class}">#{status}</span>
    HTML
  end

  def display_assignees(assignees)
    assignees.split(', ').map { |name| nick_name(name) }.join("\n")
  end

  def display_pull_requests(github_issue)
    pr_text = "#{github_issue.pr_opening}/#{github_issue.pr_closed}"

    color_tag =
      if github_issue.pr_opening.to_i.positive?
        :success
      elsif github_issue.pr_closed.to_i.positive?
        :primary
      else
        :secondary
      end

    <<-HTML
      <span class="btn btn-sm btn-#{color_tag}">#{pr_text}</span>
    HTML
  end

  def nick_name(name)
    nick_names[name].presence || name
  end

  def nick_names
    @nick_names ||= {
      "chaule1986" => 'a Châu',
      "Mylii" => 'Linh',
      "thanh2fooder" => 'Thanh',
      "thudong2x" => 'Thu',
      "hiep2fooder" => 'Hiep',
      "yenle89" => 'c Yến',
      "khangvu88" => 'a Khang',
      "longtrieu" => 'a Long',
      "GiaTran2501" => 'Gia',
      "trmaingn" => 'Mai',
      "chinhhoangfooder" => 'Chính',
      "khoa-nguyen-fooder-io" => 'a Khoa',
      "long2fooder" => 'a Long',
    }
  end
end

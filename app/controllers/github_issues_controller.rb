# frozen_string_literal: true

class GithubIssuesController < BaseController
  before_action :find_github_issue, only: %i[show edit update destroy toggle_track toggle_verified toggle_favourite]
  before_action :default_ransack_filter, only: %i[index]

  def index
    @q = GithubIssue.ransack(ransack_query)
    @github_rate_limit = Github::Api::Base.new.client.rate_limit
    @github_issues = @q.result.order(number: :desc).page(params[:page]).per(100)
  end

  def show; end

  def new
    @github_issue = GithubIssue.new
  end

  def edit; end

  def create
    @github_issue = GithubIssue.new(github_issue_params)

    if @github_issue.save
      redirect_to github_issue_path(@github_issue),
                  notice: 'Github Issue was successfully created.'
    else
      render :new
    end
  end

  def update
    if @github_issue.update(github_issue_params)
      redirect_to github_issue_path(@github_issue),
                  notice: 'Github Issue was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @github_issue.destroy
    redirect_to github_issues_path,
                notice: 'Github Issue was successfully destroyed.'
  end

  def toggle_track
    @github_issue.update(track: !@github_issue.track)

    render :issue_row_updater_js
  end

  def toggle_verified
    @github_issue.update(verified: !@github_issue.verified)

    render :issue_row_updater_js
  end

  def toggle_favourite
    @github_issue.update(favourite: !@github_issue.favourite)

    render :issue_row_updater_js
  end

  def mark_all_verified
    GithubIssue.update_all(verified: true)

    redirect_back(fallback_location: github_issues_path)
  end

  def fetch_github_issues
    Github::Issues::Fetcher.call

    redirect_back(fallback_location: github_issues_path)
  end

  def fetch_project_cards
    Github::Projects::Fetcher.call

    redirect_back(fallback_location: github_issues_path)
  end

  private

  def find_github_issue
    @github_issue = GithubIssue.find(params[:id])
  end

  def github_issue_params
    params.require(:github_issue).permit(:name, :number, :status, :assignees, :label, :milestone, :track)
  end

  def default_ransack_filter
    return if params[:default] != 'true'

    params[:q] ||= {}
    params[:q].merge!(label_cont_any: default_labels(params))
    params[:q][:status_eq] = :open if params[:q][:status_eq].nil?
    params[:q][:card_column_in] = :in_progress if params[:q][:card_column_in].nil?
    params[:q][:milestone_eq] = GithubIssue.milestones.first.to_i if params[:q][:milestone_eq].nil?
    params[:q][:favourite_eq] = true if params[:focused] == 'true'
  end

  def ransack_query
    query = params[:q].clone
    return query if query.blank?

    milestone = query[:milestone_eq]
    query[:milestone_eq] = Time.at(milestone.to_i) if milestone.present?

    card_column = query[:card_column_in]
    query[:card_column_in] = GithubIssue::PROJECT_STATUSES[card_column.to_sym] if card_column.present?

    assignees = query[:assignees_cont_any]
    query[:assignees_cont_any] = assignees.select(&:present?) if assignees.present?

    label_any = query[:label_cont_any]
    query[:label_cont_any] = label_any.select(&:present?) if label_any.present?

    label_all = query[:label_cont_all]
    query[:label_cont_all] = label_all.select(&:present?) if label_all.present?

    query
  end

  def default_labels(params)
    return %i[backend] if params[:backend] == 'true'
    return %i[web] if params[:web] == 'true'
    return %i[web backend] if params[:q][:label_cont_any].nil?

    params[:q][:label_cont_any]
  end
end

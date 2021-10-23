# frozen_string_literal: true

class GithubRepositoriesController < BaseController
  before_action :find_github_repository, only: %i[toggle_track toggle_verified]
  before_action :default_ransack_filter, only: %i[index]

  def index
    @q = GithubRepository.ransack(ransack_query)
    @github_repositories = @q.result.order(:name).page(params[:page]).per(100)
  end

  def toggle_track
    @repository.update(track: !@repository.track)

    redirect_back(fallback_location: github_repositories_path)
  end

  def toggle_verified
    @repository.update(verified: !@repository.verified)

    redirect_back(fallback_location: github_repositories_path)
  end

  def mark_all_verified
    GithubRepository.update_all(verified: true)

    redirect_back(fallback_location: github_issues_path)
  end

  def fetch_github_repositories
    GithubRepository.sync_remote_repos

    redirect_back(fallback_location: github_repositories_path)
  end

  private

  def find_github_repository
    @repository = GithubRepository.find(params[:id])
  end

  def default_ransack_filter
    return if params[:default] != 'true'

    params[:q] ||= {}
    params[:q][:track_true] = true if params[:q][:track_true].nil?
    params[:q][:pr_opening_gt] = 0 if params[:q][:pr_opening_gt].nil?
  end

  def ransack_query
    query = params[:q].clone
    return query if query.blank?

    query
  end
end

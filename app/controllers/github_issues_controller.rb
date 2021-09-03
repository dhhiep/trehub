# frozen_string_literal: true

class GithubIssuesController < BaseController
  before_action :find_github_issue, only: %i[show edit update destroy]

  def index
    @github_issues = GithubIssue.all.page(params[:page])
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

  private

  def find_github_issue
    @github_issue = GithubIssue.find(params[:id])
  end

  def github_issue_params
    params.require(:github_issue).permit(:name, :number, :status, :assignees, :label, :milestone, :track)
  end
end

require 'rails_helper'

RSpec.describe "github_issues/show", type: :view do
  before(:each) do
    @github_issue = assign(:github_issue, GithubIssue.create!(
      name: "Name",
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/GithubIssue Code/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(//)
  end
end

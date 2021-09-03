# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "github_issues/edit", type: :view do
  before(:each) do
    @github_issue = assign(:github_issue, GithubIssue.create!(
      name: "MyString",
    ))
  end

  it "renders the edit github_issue form" do
    render

    assert_select "form[action=?][method=?]", github_issue_path(@github_issue), "post" do
      assert_select "input[name=?]", "github_issue[name]"
    end
  end
end

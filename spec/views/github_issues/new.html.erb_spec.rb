# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "github_issues/new", type: :view do
  before(:each) do
    assign(:github_issue, GithubIssue.new(
      name: "MyString",
    ))
  end

  it "renders new github_issue form" do
    render

    assert_select "form[action=?][method=?]", github_issues_path, "post" do
      assert_select "input[name=?]", "github_issue[name]"
    end
  end
end

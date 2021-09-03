# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "github_issues/index", type: :view do
  before(:each) do
    assign(:github_issues, [
      GithubIssue.create!(
        name: "Name",
      ),
    ])
  end

  it "renders a list of github_issues" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
  end
end

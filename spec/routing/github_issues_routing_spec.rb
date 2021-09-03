# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubIssuesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/github_issues").to route_to("github_issues#index")
    end

    it "routes to #new" do
      expect(get: "/github_issues/new").to route_to("github_issues#new")
    end

    it "routes to #show" do
      expect(get: "/github_issues/1").to route_to("github_issues#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/github_issues/1/edit").to route_to("github_issues#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/github_issues").to route_to("github_issues#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/github_issues/1").to route_to("github_issues#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/github_issues/1").to route_to("github_issues#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/github_issues/1").to route_to("github_issues#destroy", id: "1")
    end
  end
end

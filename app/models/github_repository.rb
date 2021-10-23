# frozen_string_literal: true

class GithubRepository < ApplicationRecord
  class << self
    def pr_opening_counter
      where(track: true).sum(:pr_opening)
    end

    def sync_remote_repos
      Github::Api::Repository.all.each do |repo|
        puts "Processing repo ##{repo[:name]} ..."

        data = {
          repo_id: repo[:repo_id],
          name: repo[:name],
          url: repo[:url],
          pr_opening: repo[:pr_opening],
        }

        record = where(repo_id: data[:repo_id]).first_or_initialize
        record.update(data)
      end
    end
  end
end

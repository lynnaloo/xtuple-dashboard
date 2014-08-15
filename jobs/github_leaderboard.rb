# coding: utf-8
require "faraday"
require 'dotenv'
require 'rest-client'
require 'json'
require 'date'

Dotenv.load

user   = ENV['GITHUB_USER']
org    = ENV['GITHUB_ORG']
token  = ENV['GITHUB_TOKEN']
label  = 'haxtuple'

## the endpoint we'll be hitting
uri = "https://api.github.com/orgs/#{org}/issues?state=closed&filter=all&labels=#{label}&access_token=#{token}"

SCHEDULER.every '1m', :first_in => 0 do |job|
    response = RestClient.get uri
    issues = JSON.parse(response.body)
    issue_counts = Hash.new({ value: 0 })

    issues.each do |issue|
      # we only care about pull requests
      if issue['pull_request']
        if issue['user']
          person = issue['user']
          login = person['login']
          avatar = person['avatar_url']
          issue_counts[login] = { label: login, avatar_url: avatar,
            value: issue_counts[person['login']][:value] + 1}
        end
      end
    end

    # sort by value
    sorted = issue_counts.values.sort_by { |hsh| -hsh[:value] }

    # todo - sort these
    send_event('leaderboard', { items: sorted })

end # SCHEDULER

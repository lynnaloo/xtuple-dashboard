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

## Change this if you want to run more than one set of issue widgets
event_name = "git_issues_labeled_defects"

## the endpoint we'll be hitting
uri = "https://api.github.com/orgs/#{org}/issues?state=closed&filter=all&labels=#{label}&access_token=#{token}"

SCHEDULER.every '5m', :first_in => 0 do |job|
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
          issue_counts[login] = { label: login, avatar_url: avatar, value: issue_counts[person['login']][:value] + 1}
        end
      end
    end

    send_event('leaderboard', { items: issue_counts.values })

end # SCHEDULER

# coding: utf-8
require 'dotenv'
require 'github_api'

Dotenv.load

user   = ENV['GITHUB_USER']
org    = ENV['GITHUB_ORG']
token  = ENV['GITHUB_TOKEN']
label  = 'haxtuple'

github = Github.new(
  :oauth_token => token
)

SCHEDULER.every '2m', :first_in => 0 do |job|
    issues = github.issues.list(
      :org => org,
      :per_page => 100,
      :auto_pagination => true,
      :filter => 'all',
      :labels => label,
      :state => 'closed'
    )
    issue_counts = Hash.new(
      {
        value: 0
      }
    )

    issues.each do |issue|
      # we only care about pull requests
      if issue['pull_request']
        person = issue['user']
        login = person['login']
        avatar = person['avatar_url']
        issue_counts[login] = { label: login, avatar_url: avatar,
          value: issue_counts[person['login']][:value] + 1}
      end
    end

    # sort by value, descending
    sorted = issue_counts.values.sort_by { |issue| -issue[:value] }

    send_event('leaderboard', { items: sorted })

end

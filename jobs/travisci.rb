require 'travis'
require 'travis/pro'

def update_builds(repository, config)
  builds = []
  repo = nil

  if config["type"] == "pro"
    Travis::Pro.access_token = config["auth_token"]
    repo = Travis::Pro::Repository.find(repository)
  else  # Standard namespace
    Travis.access_token = config["auth_token"]
    repo = Travis::Repository.find(repository)
  end

  build = repo.last_build
  build_info = {
    label: "Build #{build.number}",
    value: "[#{build.branch_info}], #{build.state} in #{build.duration}s",
    state: build.state
  }
  builds << build_info

  builds
end

config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/travisci.yml'
config = YAML::load(File.open(config_file))

SCHEDULER.every('2m', first_in: '1s') {
  config.each do |type, type_config|
    unless type_config["repositories"].nil?
      type_config["repositories"].each do |data_id, repo|
        send_event(data_id, { items: update_builds(repo, type_config) })
      end
    else
      puts "No repositories for travis.#{type}"
    end
  end
}

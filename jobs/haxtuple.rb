
SCHEDULER.every '5m' do

  # Bug fixers
  tuplers = [
    {:label=>"Jeff Gunderson", :value=>1},
    {:label=>"Steve Hackbarth", :value=>1},
    {:label=>"Mark Gummo", :value=>1}
  ]

  # Extension builders
  extensions = [
    {:label=>"Juliana Louback", :value=>"JS Communicator", :url=>"https://github.com/xtuple/xtuple/issues/1702"},
    {:label=>"Stanley Zheng", :value=>"xTuple-Yo", :url=>"https://github.com/stanzheng/xTuple-Yo"},
    {:label=>"Steve Hackbarth", :value=>"Logistify", :url=>"https://github.com/shackbarth/xtuple-extensions/tree/master/source/xtuple-logistify"},
    {:label=>"John Rogelstad", :value=>"xTuple-Quintiq", :url=>"https://github.com/jrogelstad/xtuple-quintiq"},
    {:label=>"Linda Nichols", :value=>"xTuple-Todo", :url=>"https://github.com/lynnaloo/xtuple-todo"}
  ]

  send_event('leaderboard', { items: tuplers })
  send_event('extensions', { items: extensions })
end

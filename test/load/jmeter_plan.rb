require 'ruby-jmeter'

test do

  defaults domain: 'phylo.cs.nmsu.edu'

  cache clear_each_iteration: true

  cookies

  threads 1, {ramp_time: 60, duration: 120, continue_forever: true} do

    random_timer 5000, 15000

    # <meta name="csrf-token" content="Y/Ewo6stZRBSdI9SACiG0eHk/flggkPkBb7hHreT+ks34Ct4As5HI5afMtX0/bKhaNf/FX3/Uuo1lV+AEnePTw==">
    extract name: 'authenticity_token',
            regex: 'meta name="csrf-token" content="(.*)"'

    transaction 'workflow' do
      visit name: "Homepage", url: "http://phylo.cs.nmsu.edu" do
        assert contains: 'Home | Phylotastic Portal', scope: 'main'
      end
    # end

    # transaction '02_create_list' do
      submit '/links', {
        fill_in: {
          'utf8'               => '%E2%9C%93',
          'authenticity_token' => '${__urlencode(${authenticity_token})}',
          'link[url]'          => 'https://en.wikipedia.org/wiki/Muroidea',
          "name"               => "Muroidea",
          'commit'             => 'Submit'
        }
      } do
        assert contains: 'Muroidea', scope: 'main'
        extract name: 'list_id',
                regex: 'http\:\/\/phylo\.cs\.nmsu\.edu\/lists\/(\d+)'
      end
      
      visit name: "List page", url: "http://phylo.cs.nmsu.edu/lists/${list_id}"
      
      submit '/lists/${list_id}/trees', {
        fill_in: {
          'utf8'                                => '%E2%9C%93',
          'authenticity_token'                  => '${__urlencode(${authenticity_token})}',
          'tree[list_from_service]'             => 'false',
          'tree[name]'                          => 'lt',
          'tree[species][Puijila darwini]'      => '1',
          'tree[species][Osmotherium spelaeum]' => '1',
          'commit'                              => 'Get tree'
        }
      } do
        assert contains: 'lt', scope: 'main'
      end
    end
  end
  
  view_results_tree
  summary_report
  
end.run(
  path: '/usr/local/bin/',
  file: 'jmeter.jmx',
  log: 'jmeter.log',
  jtl: 'results.jtl',
  properties: 'jmeter.properties',
  gui: true)

# test do
#   threads count: 1 do
#     visit name: "Altentee", url: "http://phylo.cs.nmsu.edu" do
#       assert contains: "Home | Phylotastic Portal"
#     end
#   end
# end.run
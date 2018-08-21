require 'ruby-jmeter'

test do

  defaults domain: 'phylo.cs.nmsu.edu'

  cache clear_each_iteration: true

  cookies

  threads 5, {ramp_time: 60, duration: 120, continue_forever: true} do

    random_timer 5000, 15000

    # <meta name="csrf-token" content="Y/Ewo6stZRBSdI9SACiG0eHk/flggkPkBb7hHreT+ks34Ct4As5HI5afMtX0/bKhaNf/FX3/Uuo1lV+AEnePTw==">
    extract name: 'authenticity_token',
            regex: 'meta name="csrf-token" content="(.*)"'

    transaction '01_visit_home_page' do
      visit '/' do
        assert contains: 'Hello,'
      end
    end

    transaction '02_create_list' do
      submit '/links', {
        fill_in: {
          'utf8'               => '%E2%9C%93',
          'authenticity_token' => '${__urlencode(${authenticity_token})}',
          'link[url]'          => 'https://en.wikipedia.org/wiki/Muroidea',
          "name"               => "Muroidea",
          'commit'             => 'Submit'
        }
      }
    end

  end

end.run(
  path: '/usr/local/bin/',
  file: 'jmeter.jmx',
  log: 'jmeter.log',
  jtl: 'results.jtl',
  properties: 'jmeter.properties')

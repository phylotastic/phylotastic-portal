require 'ruby-jmeter'

test do

  defaults domain: 'phylo.cs.nmsu.edu'

  cache clear_each_iteration: true

  cookies

  threads 50, {ramp_time: 60, duration: 120, continue_forever: true} do

    random_timer 5000, 15000

    extract name: 'authenticity_token',
            regex: 'meta content="(.+?)" name="csrf-token"'

    transaction '01_my_site_visit_home_page' do
      visit '/' do
        assert contains: 'Hello,'
      end
    end

    transaction '02_my_site_create_list' do
      submit '/links', {
        fill_in: {
          'utf8'               => '%E2%9C%93',
          'authenticity_token' => '${authenticity_token}',
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

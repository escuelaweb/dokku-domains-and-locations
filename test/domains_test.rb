require 'test_helper'

describe 'Domains' do
  before do
    TestHelper.cleanup
  end
  it 'lists available commands' do
    TestHelper.call_commands('help').must_equal <<-EOF
    domains <app>                                                         display the domains for an app
    domains:set <app> DOMAIN1 [DOMAIN2 ...]                               set one or more domains
    domains:locations <app>                                               display the subapp locations for an app
    domains:locations:set <app> LOCATION1:SUBAPP [LOCATION1:SUBAPP ...]   set one or more subapp locations
    EOF
  end

  it 'lists no domains for app without custom domains' do
    TestHelper.call_commands('domains', 'app').strip.must_equal "-----> Domains for app"
  end

  it 'add domain for and app' do 
    TestHelper.call_commands('domains:set', 'app escuelaweb.net www.escuelaweb.net')
    domains = File.read(TestHelper.dokku_root.join('app/DOMAINS'))
    domains.strip.must_equal "escuelaweb.net www.escuelaweb.net"
  end

  it 'add subapp locations for and app' do 
    TestHelper.call_commands('domains:set', 'app escuelaweb.net www.escuelaweb.net')
    domains = File.read(TestHelper.dokku_root.join('app/DOMAINS'))
    domains.strip.must_equal "escuelaweb.net www.escuelaweb.net"
    TestHelper.call_commands('domains:locations:set', 'app node-chat-server:/node-chat-server/ escuelawebve:/ve/')
    locations = File.read(TestHelper.dokku_root.join('app/LOCATIONS'))
    locations.strip.must_equal "node-chat-server:/node-chat-server/ escuelawebve:/ve/"
  end
end
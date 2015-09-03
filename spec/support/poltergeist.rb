require 'capybara/poltergeist'

Capybara.register_driver :poltergeist_custom do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_options: ['--proxy-type=socks5', '--proxy=0.0.0.0:0', '--load-images=no', '--ignore-ssl-errors=yes'])
end

Capybara.javascript_driver = :poltergeist_custom

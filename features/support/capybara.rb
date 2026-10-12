Capybara.default_driver = :rack_test

Before do
  ActionMailer::Base.deliveries.clear
end

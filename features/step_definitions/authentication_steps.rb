Given("a registered user with email {string} and password {string}") do |email, password|
  User.create!(email: email, password: password, password_confirmation: password)
end

When("I visit the home page") do
  visit root_path
end

When("I register with email {string} and password {string}") do |email, password|
  visit new_user_registration_path
  fill_in "Email", with: email
  fill_in "Password", with: password, exact: true
  fill_in "Password confirmation", with: password
  click_button "Sign up"
end

When("I sign in with email {string} and password {string}") do |email, password|
  visit new_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: password, exact: true
  click_button "Log in"
end

When("I sign out") do
  click_button "Sign out"
end

When("I request a password reset for {string}") do |email|
  visit new_user_password_path
  fill_in "Email", with: email
  click_button "Send me password reset instructions"
end

When("I follow the emailed reset link and choose password {string}") do |password|
  email = ActionMailer::Base.deliveries.last
  raise "No password reset email was delivered" unless email

  html = (email.html_part || email).body.decoded
  link = Nokogiri::HTML(html).at_css("a[href*='reset_password_token']")
  raise "The email did not contain a password reset link" unless link

  visit link["href"]
  fill_in "New password", with: password
  fill_in "Confirm new password", with: password
  click_button "Change my password"
end

Then("I should see the sign-in page") do
  assert_current_path new_user_session_path
  assert_selector "h2", text: "Log in"
end

Then("I should see the home page for {string}") do |email|
  assert_current_path root_path
  assert_selector "h1", text: "Tiny LMS"
  assert_text "Welcome, #{email}."
end

Then("I should see an authentication error") do
  assert_selector ".alert", text: /Invalid .*password/
end

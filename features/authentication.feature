Feature: User authentication
  Users must sign in before accessing Tiny LMS.

  Scenario: A visitor must sign in
    When I visit the home page
    Then I should see the sign-in page

  Scenario: A visitor creates an account
    When I register with email "new@example.test" and password "password123!"
    Then I should see the home page for "new@example.test"

  Scenario: A user signs in and signs out
    Given a registered user with email "member@example.test" and password "password123!"
    When I sign in with email "member@example.test" and password "password123!"
    Then I should see the home page for "member@example.test"
    When I sign out
    And I visit the home page
    Then I should see the sign-in page

  Scenario: An incorrect password is rejected
    Given a registered user with email "member@example.test" and password "password123!"
    When I sign in with email "member@example.test" and password "incorrect-password"
    Then I should see an authentication error
    When I visit the home page
    Then I should see the sign-in page

  Scenario: A user resets a forgotten password
    Given a registered user with email "member@example.test" and password "password123!"
    When I request a password reset for "member@example.test"
    And I follow the emailed reset link and choose password "replacement123!"
    Then I should see the home page for "member@example.test"
    When I sign out
    And I sign in with email "member@example.test" and password "replacement123!"
    Then I should see the home page for "member@example.test"

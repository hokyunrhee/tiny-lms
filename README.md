# tiny-lms

Rails 8.1.4 application with Devise authentication, Pundit authorization, and
Cucumber acceptance tests. Ruby 3.4.11 is pinned in `.ruby-version`.

## Development

```sh
bundle install
bin/rails db:prepare
bin/dev
```

In the Codex cloud environment, first activate the installed Ruby toolchain:

```sh
source /workspace/.tiny-lms-env/activate
```

The app uses SQLite, Propshaft, import maps, and Hotwire. No separate database
server or JavaScript build service is needed for the default development workflow.

## Authentication and authorization

Devise 5.0.4 configures the `User` model for registration, sign-in, password
recovery, remember-me, and password validation. Visitors are redirected to the
sign-in page; signed-in users can access the home page and sign out.

Development emails are written to `tmp/mails`. Configure the production mailer
host, delivery method, and sender before sending real password recovery emails.

Pundit 2.5.2 is included in `ApplicationController`. `HomePolicy` permits
authenticated users, and `HomeController` verifies that authorization occurred.
`ApplicationPolicy` denies actions by default. Add policies and authorization
checks as application resources are introduced; no roles are predefined.

## Tests

Following the [Cucumber Ruby installation guide](https://cucumber.io/docs/installation/ruby),
the test group uses `cucumber-rails` and `database_cleaner-active_record`.
Cucumber 11.1.1 and cucumber-rails 4.1.0 are resolved in `Gemfile.lock`.

```sh
RAILS_ENV=test bin/rails db:prepare
bundle exec cucumber
```

The scenarios in `features/authentication.feature` exercise guest access,
registration, sign-in/sign-out, invalid credentials, and password recovery.
Capybara's `rack_test` driver runs against the Rails app without an external browser.
DatabaseCleaner isolates each scenario using transactions in the test database.

```sh
bin/rails zeitwerk:check
bin/rubocop
bin/brakeman --no-pager
bin/ci
```

Cucumber runs in both `bin/ci` and the GitHub Actions test job. The generated
Minitest suite is available for future unit and integration tests.

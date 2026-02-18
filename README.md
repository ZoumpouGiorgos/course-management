Rails app for a course management portal (posts, contacts, messaging, notifications).

Ruby 3.4.8
Rails 8.1.2

System dependencies
- SQLite3 (dev/test/prod)

Database creation
- rails db:create

Database initialization
- rails db:migrate

Running locally
- bundle install
- rails db:prepare
- rails db:seed
- rails server
- visit http://localhost:3000
- log in with given credentials in console (after seeding)
- or create a new account

With Tailwind watcher:
- rails tailwindcss:watch

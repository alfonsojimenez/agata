# Àgata

[![Build
Status](https://travis-ci.org/alfonsojimenez/agata.svg?branch=master)](https://travis-ci.org/alfonsojimenez/agata)

![Àgata](/screenshot.png?raw=true)

*Àgata* is a tool which runs a fake SMTP server and captures any email sent to it.

The SMTP server runs over 1025 port and the HTTP 8080 over 8080 by
default. It is possible to configure this by modifying `config/config.exs` file.

Inspired in Ruby [mailcatcher](https://github.com/sj26/mailcatcher).

## Installation

1. `git clone git@github.com:alfonsojimenez/agata.git`
2. `mix deps.get`
3. `mix run --no-halt`
4. Open http://127.0.0.1:1080/

## Usage

You can send emails to *Àgata* through `localhost:1025`:

### Phoenix / Bamboo

Add mailer configuration to `config/config.exs` of you app:

```elixir
config :my_app, MyApp.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "localhost",
  port: 1025,
  ssl: false
```

### Rails

Configure your Rails app `development` environment to send emails to `localhost:1025`. Modify your `config/environments/development.rb` file:

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
```

### Symfony

You need to setup this environment variable to send emails to *Àgata* from your Symfony app:

```bash
MAILER_URL=smtp://localhost:1025?&username=&password=
```

### Django

Add this configuration to `settings.py` file so your Django app could send emails to *Àgata*:

```python
EMAIL_HOST = 'localhost'
EMAIL_HOST_USER = ''
EMAIL_HOST_PASSWORD = ''
EMAIL_PORT = 1025
EMAIL_USE_TLS = False
```

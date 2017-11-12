# Àgata

*Àgata* is a tool which runs a fake SMTP server and captures any email sent to it.

The SMTP server runs over 1025 port and the HTTP 8080 over 8080 by
default. It is possible to configure this by modifying `config/config.exs` 
file.

Inspired in Ruby [mailcatcher](https://github.com/sj26/mailcatcher).

## Installation

1. `git clone git@github.com:alfonsojimenez/agata.git`
2. `mix deps.get`
3. `mix run --no-halt`
4. Open http://127.0.0.1:1080/

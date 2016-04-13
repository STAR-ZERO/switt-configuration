# [Switt](https://github.com/STAR-ZERO/switt) Configuration page

## Setup

```
$ bundle install --path vendor/bundle
```

## Environment variable

* `switt_session_secret`: session secret token.
* `switt_client_id`: Foursquare client id
* `switt_client_secret`: Foursquare client secret

## Development

```
$ bundle exec rackup
```

Port 9292 is used.

## Produciton

```
$ bundle exec unicorn -c config/unicorn.rb -E production -D
```

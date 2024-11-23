# Øresund Space Collective
This is the website of [Øresund Space Collective](oresundspacecollective.com), based on a copy of `oresundspacecollective.com` from [archive.org](archive.org).

## Develop
### Prerequisites
Install [Jekyll](https://jekyllrb.com/docs/installation).
For Debian 12:
```bash
sudo apt install build-essential libffi-dev ruby-dev ruby gem
```
Add this to `~/.bashrc` to allow gem to run for a non-root user.
```sh
# Ruby exports
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
```
### Run
```bash
$ cd osc
$ bundle install
$ bundle exec jekyll serve
```

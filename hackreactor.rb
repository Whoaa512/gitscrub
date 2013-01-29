#!/usr/bin/env ruby
require 'curb'
require 'json'
require_relative 'lib/secrets.rb'

#High-level goals:
# Back up all remote repos (prob best as a separate script)
# Clone down all GH repos
# Scrub repos
# Delete remote repos
# Recreate remote repos
# Push master and all branches


GH_BASE_URL = 'https://api.github.com'
def github_get_url_resource(url)
  c = Curl::Easy.new("#{GH_BASE_URL}" + url)
  c.http_auth_types = :basic
  c.username = GH_ORG_USERNAME
  c.password = GH_ORG_PW
  c.perform
  c.body_str
end

def github_get_json(url)
  JSON.parse( github_get_url_resource(url) )
end

# Returns an array of all catalystclass repos
# We'll clone these down and run the script on each repo
def fetch_all_repo_urls
  url = "/orgs/catalystclass/repos"
  returnobj = []
  github_get_json(url).each do |object|
    returnobj << object["clone_url"]
  end
  returnobj
end

def init
  dir = Dir.mktmpdir('hackreactor-gitdir-', '/var/tmp')
  begin
    Dir.chdir dir
    ## do work
  ensure
    # Clean up the directory when we're done
    FileUtils.remove_entry_secure dir
  end
end

def back_up_remote_repos
  fetch_all_repo_urls
  # Clone each of them down to a backup dir
end

# Push a modified fork of an arbitrary repository to a user's github profile.
# http://developer.github.com/v3/repos/#list-all-repositories
def push_remote_repo
end

# Nukes local repo readmes and expunges all commit history references to them.
# https://help.github.com/articles/remove-sensitive-data

#rm -rf .git/refs/original/
#git reflog expire --expire=now --all
#git gc --prune=now
#git gc --aggressive --prune=now
#README.md
#README.rdoc

def scrub_local_repo (*filenames)

  raise ArgumentError, 'Arguments array cannot be empty' unless filenames.any?

  # No need to do file sanity check--this command is tolerant of invalid filenames
  command = "git filter-branch --index-filter 'git rm --cached --ignore-unmatch #{filenames.join(' ')}' --prune-empty --tag-name-filter cat -- --all"
  %x(#{command})
end

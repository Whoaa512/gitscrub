#!/usr/bin/env ruby
require 'curb'
require 'json'
require "./password_module.rb"

#High-level goals:
# Back up all remote repos (prob best as a separate script)
# Move READMEs (maybe wiki or elsewhere?)
# Clone down all GH repos
# Scrub repos
# Delete remote repos
# Recreate remote repos
# Push master and all branches

def ask_for_username
  puts "Please enter your github username."
  gets.chomp
end

GH_USERNAME = ask_for_username
GH_PASSWORD = ask_for_password


GH_BASE_URL = 'https://api.github.com'
def github_get_url_resource(url)
  c = Curl::Easy.new("#{GH_BASE_URL}" + url)
  c.http_auth_types = :basic
  c.username = GH_USERNAME or ask_for_username
  c.password = GH_PASSWORD or ask_for_password
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

# Backup all repos from catalystclass org
def back_up_remote_repos folder_prefix=DateTime.now
  backupdir = File.join(Dir.home, "#{folder_prefix}_git_backup")
  # make backup dir
  Dir.mkdir backupdir
  # cd into it
  Dir.chdir backupdir

  # clone down each repo into backupdir
  fetch_all_repo_urls.each do |repo|
    clone_cmd = "git clone #{repo}"
    puts "Now cloning '#{repo}'."
    %x(#{clone_cmd})
  end
end

def checkout_locally
  # checkout each branch locally
  Dir.chdir backupdir
  fetch_all_repo_names.each do |name|
    # cd into repo directory
    Dir.chdir name
    puts "Grabing remote branches for '#{name}'."
    # checkout & track each branch locally
    %x(for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master`; do
        git branch --track ${branch##*/} $branch
      done)
    # cd up to backupdir
    Dir.chdir '..'
  end
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

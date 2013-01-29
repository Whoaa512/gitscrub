gitscrub
========

What Doth It Do?
----------------

Two purposes (is probably two scripts):

HR side:
    Pulls down all repos, removes readme files and scrubs all commits/branches
    all previous commits of references to the file. Does a force push at the end.
    Backs up remote repos, too.

Student side:
    Pulls down all repos, does some magic on them, and pushes repos up to
    students' accounts


How To
------

Ideally, run this in command line:
`curl -flagz https://github.com/ndhoule/gitscrub/someurl/somefile | sh`


Basic Workflow
--------------
Where >>> is cli input, no leading char is input prompt, and ~ is program flow

HR:
>>> Curl command?
TODO: Finish this section

Student:
>>> Curl command
? Please enter the catalyst-students github password:
~ Clone all catalystclass repos to /var/temp/tempdir
? Please enter your GitHub profile name:
? If you've used alternate names in your GitHub branch names, please enter
  them here (e.g. rather than naming your branch ndhoule, you named it
  nathan):
~ Loop through each repo, merge user's branch into master and remove origin
    NOTE: Detect duplicate branch names at this point (e.g. branches named
    ndhoule-mrev and ndhoule) and present user with option. Detect which has
    more recent commits and which has more commits in its history and recommend
    based on that. Give them a skip option for each repo, too.
    *** Mracus: I think we should not upload between each repo. That will require
    students to sit there and babysit the process in case of conflicts. Let's
    build a list and let it loop through after all input has been collected ***


Other tasks
-----

- Move all README files over to GH wikis
- Scrub all ~/code directories on HR machines
- Put together a repo or GH page that gives context for these repos

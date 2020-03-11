# die-koma.org
Jekyll Code of the new website


# Installation
Short: Use [Jekyll](https://jekyllrb.com/).

Long: This may be arbitrary hard, depending on your Operating System and how fucked up your ruby installation is, to re-install ruby and install the proper version see following guides:


## Debian / Ubuntu

    # ruby installation stuff:
    sudo apt remove ruby   # um ruby einmal zu deinstallieren, eigentlich nicht nötig im idealfall
    sudo apt install ruby  # oder sudo apt --upgrade ruby
    # read output!
    # maybe you'll have to add ruby to some path and reload your bashrc
    which gem  # should lie in same folder as following:
    which ruby
    ruby --version  # should be the one installed above
    # Bundle stuff:
    cd "die-koma.org"
    git pull  # make sure to be on master, pull latest version :)
    gem install bundler   # should run successfully then
    bundle install  # you have to be in the repository
    bundle exec jekyll serve  # should run now on 127.0.0.1

## Mac
same as above but use homebrew instead of apt.


## Windows
you're lost anyways, I don't know how to handle that odyssee.

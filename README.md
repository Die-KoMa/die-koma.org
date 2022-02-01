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


## Windows with WSL Ubuntu
    # clone "die-koma.org" to a directory without any spaces!
    cd die-koma.org
    # start wsl in the directory
    # install ruby and packages for gem creation
    sudo apt install bundler ruby ruby-dev make gcc g++
    # configure to install gems locally (don't clutter wsl and system dirs)
    bundle config set --local path './ruby-packages/'
    # you might have to add the following to _config.yaml:
    # exclude: ['ruby-packages']
    bundle install
    bundle exec jekyll serve --force-polling # should run now on 127.0.0.1:4000
    # the Port is available on Windows, just use your normal browser without wsl


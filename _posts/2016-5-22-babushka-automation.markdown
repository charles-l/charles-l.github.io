---
layout: post
title:  Babushka Automation
date:   2016-05-22
---

I first saw [babushka](http://babushka.me/) a few weeks ago while surfing [lobste.rs](http://lobste.rs). Babushka is a test-driven task automation tool. It's basically `rake`, but higher level and designed for your entire system (instead of a single project). I immediately thought it looked interesting, installed it, then wrote up a [few tasks](https://github.com/charles-l/babushka-deps).

Whether it's scripting a bunch of boilerplate commands to set up a new project, packaging a shell scripts that require a bit more logic/error checking than the shell provides, or automating the setup of a new system, a few lines simple lines of Ruby can replace what would otherwise be an archaic shell script. My focus (at least for now), has been on downloading and configuring my dotfiles when I start on a fresh installation.

# babushka deps - it's Russian dolls... all the way down?

Babushka tasks are called "deps", and can be run from anywhere on the system. Babushka comes pre-bundled with basic deps that install common utilities like `git`, `pip` and build tools. Deps are super flexible, since they're written in Ruby. They can also be easily edited with `babushuka edit [dep]` or called from a remote git repo with `babushka [github username]:[dep]`. The `babushka` command has lots of powerful built in options, so definitely check the docpage on it.

Templates are a great (though underdocumented) feature babushuka provides for writing deps. They allow you to extend the babushka DSL to make writing tasks easier while simplifying code. For my purposes, there are two built-in templates I want to cover: `src` and `bin`.

In my personal deps, I've used these templates extensively for installing the various non-standard utilities that are part of my regular workflow. For instance, to build and install [lemonbar](http://github.com/LemonBoy/bar) from source, a task could be written like:

```ruby
dep 'lemonbar', :template => 'src' do
    source "github.com/LemonBoy/bar"
    provides %w[lemonbar] # lets other deps know what binaries are provided, once built
    # That's all there is to it. No `git clone`, no `make` or `sudo make install`. That's all done for you through the template.
end
```

... and to install a binary package, like `mksh`:

```ruby
dep 'mksh', :template => 'bin' do
    installs { via :pacman, 'mksh' }
    provides %w[mksh]
end
```

Oh yeah, it allows you to run platform-specific commands too (based on OS/distro).

Did I mention you can use Ruby-meta magic-ness?

```ruby
dep 'dotfiles', :wm do # `:wm` is a parameter I can pass from the command line (or it'll prompt me for)
    wm.default('mcwm') # set the default window manager to mcmw
    requires 'stow'
    if wm.to_s != 'none'
        requires wm.to_s # require whichever window manager dep I pass at the prompt.
    end

    met? { "#{ENV['HOME']}/.dotfiles/".p.dir? }
    meet {
        log_shell "cloning", "git clone https://github.com/charles-l/dotfiles .dotfiles"
        log_shell "stowing", "cd .#{target}
        && stow ./shell
            && stow ./x
            && stow ./mksh
            && stow ./vim
            && stow ./tmux
        #{"&& stow ./#{wm.to_s}" if wm.to_s != 'none'}" # stow the specific files for that wm
    }
end
```

Here's what it looks like (when I've already got everything set up):

```
personal:dotfiles {
  wm [mcwm]? mcwm
  personal:dev_dir {
  } ✓ personal:dev_dir
  personal:mksh {
    'mksh' runs from /usr/bin.
  } ✓ personal:mksh
  personal:stow {
    'stow' runs from /usr/bin.
  } ✓ personal:stow
  personal:fzf {
    'fzf' runs from /usr/bin.
  } ✓ personal:fzf
  personal:vim {
    'vim' runs from /usr/bin.
  } ✓ personal:vim
  personal:mcwm {
    personal:lemonbar {
      'lemonbar' runs from /usr/bin.
    } ✓ personal:lemonbar
    personal:st {
      'st' runs from /usr/local/bin.
    } ✓ personal:st
    'mcwm' runs from /usr/local/bin.
  } ✓ personal:mcwm
  personal:plug {
  } ✓ personal:plug
} ✓ personal:dotfiles
```

Ha! You've got to admit, that's way more fun than a boring old shell script.

# But that's not all!

Alright, I may primarily be using babushka as a glorified distro-agnostic package manager, but that's not all it can do.

Generic system tasks are super easy to automate with it as well. For instance, my wireless card's driver will sometimes crash while I'm playing CS:GO, so I wrote a dep to run the set of commands needed to unload/reload the kernel module and reset my connection:

```ruby
dep 'reset_wifi' do
    # hack for when CSGO crashes my wifi driver -.-
    met? { shell?("curl www.google.com --connect-timeout 1") } # make sure I don't have an internet connection first
    mod = "rt2800usb"
    network = "wifi-network" # network name (since this doesn't change, i'm not setting it as a parameter)
    meet {
        log_shell "removing #{mod}", "sudo rmmod #{mod}"
        log_shell "loading #{mod}", "sudo modprobe #{mod}"
        log_shell "netctling it", "sudo netctl restart #{network}"
    }
end
```

Now, whenever I get the timeout counter on CS:GO, all I have to do is pop open a terminal and run `babushka personal:reset_wifi` (before the time runs out). It's very exciting.

If this post was enough to peak your interest, go install babushka and write some deps. Happy babushka-ing!

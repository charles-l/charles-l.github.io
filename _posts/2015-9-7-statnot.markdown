---
layout: post
title: statnot
date:   2015-09-07
---

`libnotify` is kind of the standard for desktop notifications. Personally, I'm not a huge fan of dbus and friends, but `libnotify` has become a necessary evil. The popular notification daemons tend to be a little overkill, and I was hoping to integrate my notifications with a cannibalized version of a popup that uses [lemonbar](https://github.com/LemonBoy/bar) (thanks [z3bra](http://blog.z3bra.org/2014/04/pop-it-up.html)!). Rather than getting another notification center that required it's own extra styling, I looked around for a libnotify daemon that would call a shell script and pass it the notification contents.

Initially, I was going to write a C program on my own, but the awful lack of C documentation for `libnotify` coupled with the hate of dbus, I eventually found a non-sucky python script that did what I wanted.

[`statnot`](https://github.com/halhen/statnot), is very simple to configure. Just add the following to `~/.config/statnot/statnotrc`:

    STATUS_COMMAND = ['/bin/sh', '/home/ninjacharlie/bin/popup']

And add this to `~/.xinitrc`:

    ...
    statnot /home/ninjacharlie/.config/statnot/statnotrc &
    ...

Once you restart X, you should see notifications pop up when you pause/play Spotify songs or run a `notify-send` command.

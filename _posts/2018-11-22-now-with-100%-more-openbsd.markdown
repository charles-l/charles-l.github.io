---
layout: post
title: now with 100% more openbsd
date: 2018-11-22
---

Lately, I've been getting into using OpenBSD. 
The project's focus on simplicity and security are refreshing 
now that I've started working full time in the work-a-day tech world 
were legacy and "enterprise" systems abound.
It amazes me that there's a small group of people who actually *remove* code and unused features with new releases.

I've installed it on my laptop, and it's worked quite well. 
Browsing the internet in FF is a bit slow, but I tend to avoid bloaty, 
JavaScript-filled sites anyway. The trackpad is also unsupported, but I live by the keyboard
so it's not too much of an issue. 
Maybe I'll try to write a device driver for at some point. 
That could be fun :)

OpenBSD is known for being an extremely stable OS for servers. 
I decided to move my website from GitHub's static hosting
to a self-hosted OpenBSD server on [Vultr](https://www.vultr.com/?ref=6996219).

It took a weekend to set up, 
but after reading through a couple of man pages and a few blog posts, 
I've managed to set up:

* https with Let's Encrypt.
* `httpd`. It serves the static content of my site
* A new, improved version of the site with [indie web](https://indieweb.org/Getting_Started) integration.
It's not directly OpenBSD related, 
but I'll probably add webmentions soon which will probably require some cgi-script configuration in `httpd`.

# Obtaining SSL certificates from Let's Encrypt with `acme-client` 

The `acme-client` configuration that comes with OpenBSD almost works out of the box. 
All you have to do is update the domain name in the domain block in `/etc/acme-client.conf`, 
then add an `httpd` endpoint to respond to Let's Encrypt challenges 
(more details [here](https://www.romanzolotarev.com/openbsd/acme-client.html)).

```
location "/.well-known/acme-challenge/*" {
	root "/acme"
	request strip 2
}
```

Then run, `rcctl restart httpd` and `acme-client -vFAD your.domain`.

Now you'll find the SSL certificate and private key at the paths specified in `acme-client.conf`
(usually named `/etc/ssl/your.domain.pem` and `/etc/ssl/private/your.domain.key`)

You'll probably want to add a cron job to keep your SSL cert up to date
since it's only valid for a few months.

# Running a static site with `httpd`

`httpd` has a straightforward syntax for matching URLs and responding with a specific path 
(perfect for static sites like mine).
I'm using `jekyll` for my site, 
so I can generate a static version of my website to `/var/www/htdocs/charliethe.ninja` with the following command:

```
jekyll23 build -d /var/www/htdocs/charliethe.ninja/
```

`httpd` chroots to `/var/www/` by default, so
the standard location for static web content is `/var/www/htdocs/yoursite`

The configuration for my server looks like:

```
server "charliethe.ninja" {
	listen on * tls port 443 # https
	root "/htdocs/charliethe.ninja"

	# https certs
	tls {
		certificate "/etc/ssl/charliethe.ninja.pem"
		key "/etc/ssl/private/charliethe.ninja.key"
	}

	# as above
	location "/.well-known/acme-challenge/*" {
		root "/acme"
		request strip 2
	}
}
```

To encourage users to use my nicely secured https endpoints 
(very important for static sites of course), 
I've added a redirect for port 80 to the `https` version of the site in a separate block:

```
server "charliethe.ninja" {
	listen on $ext_ip port 80
	block return 301 "https://charliethe.ninja$REQUEST_URI"
}
```

Make sure to reload `httpd` again at this point.
When I set it up, 
I had partially configured TLS and forgotten to restart `httpd` 
which led to a weird issue where the cert didn't show up.

# IndieWeb 

In the spirit of self-hosting and decentralizing my content, 
I've gone about making my website compatible with the IndieWeb.

For now, I've just rewritten most of the HTML to be more semantic.
The HTML5 standard includes some expressive tags like `<header>`, `<footer>`, `<aside>`, etc.
Focusing on indicating semantic meaning with markup rather than layout will (hopefully) make my website easier to parse. 
Besides, that's what HTML was originally meant for anyway, so it's cleaner to express that way
(see [POSH](http://microformats.org/wiki/posh)).

I've added an [`h-card`](https://indieweb.org/h-card) and [`h-entry`](https://indieweb.org/h-entry)s to my pages.
I'm not sure if anyone is actually parsing content that follows microformats guidelines, 
but I like the idea of having more cross-site integration
and semantic meaning to the web.

# Upgrading to 6.4 from 6.3

When I created the server, 
I mistakenly chose OpenBSD 6.3 rather than 6.4.
As I was configuring the SMTP mail server, 
I realized there were some features 
and bug fixes I wanted in the latest version of `smtpd` which ships with 6.4. 
So, I upgraded it.

My experience with Linux upgrades has not been terrible. 
Usually I'll run a rolling release distro or a distro based on Debian.
Unless a conflict comes up, upgrades are usually straightforward.
I've only had issues with changes in configuration formats during updates, 
which can break daemons and other software after rebooting.

In OpenBSD the `sysmerge` utility is a nice way to gracefully update configuration.
It attempts to merge the new configuration in with the old file,
prompting the user for help when it can't figure out how to merge.
Even if its unable to merge files, 
it at least makes you aware of potential issues.

# General experience

The main reason I switched to OpenBSD was the allure of simplicity.
I wanted an OS with an authentic unixy experience, 
basic support for most hardware like my laptop,
and the ability to run Firefox (not that I like it).
OpenBSD delivered on these requirements.

<aside>
I'd love to run something like Plan9, 
but a man's gotta get his daily Reddit memes,
and that requires a "modern" web browser :P
</aside>

Most of the Linux community has given up on the simplicity of the Unix Philosophy.
Fortunately, much of the CLI is still based on the original Unix utilities,
but new software is not built with composing it in mind.
You can see the complexity and bloat in the 
[bug-ridden init system](http://without-systemd.org/wiki/index.php/Main_Page), 
[messy sound stack](http://insanecoding.blogspot.com/2009/06/state-of-sound-in-linux-not-so-sorry.html),
[siloed desktop environments](http://harmful.cat-v.org/software/gnome/),
[broken crypto](https://www.cvedetails.com/vulnerability-list.php?vendor_id=217&product_id=383&version_id=&page=1&hasexp=0&opdos=0&opec=0&opov=0&opcsrf=0&opgpriv=0&opsqli=0&opxss=0&opdirt=0&opmemc=0&ophttprs=0&opbyp=0&opfileinc=0&opginf=0&cvssscoremin=0&cvssscoremax=0&year=0&month=0&cweid=0&order=3&trc=192&sha=a5f0d72a384ec6c4769704bf21cb8fcca388c4c3),
and over engineered utilities (e.g. [gnu ls](https://github.com/coreutils/coreutils/blob/master/src/ls.c) vs [openbsd ls](https://github.com/Bluerise/OpenBSD-src/blob/master/bin/ls/ls.c)).

I know more minimalist distros exist, 
and I really like some of them
([Devuan](https://devuan.org/), 
[void linux](https://voidlinux.org/), 
[Alpine](https://www.alpinelinux.org/)).
In fact, Devuan runs on my desktop machine, 
since it has an NVidia card that isn't supported in OpenBSD.

But these distros are not the norm.
They go against the grain, 
and most software targeting Linux assumes the above mentioned bad pieces of software are installed and running.
At this point, I prefer the more unified experience of OpenBSD.

## Documentation

Expect to do more digging through documentation on OpenBSD than on Linux.  
When you run into problems, you're far less likely to find solutions on StackOverflow and popular web forums.
Even with the `misc` OpenBSD mailing list,
most solutions are presented as a simple copy and paste.
You'll have to understand what is going on at a lower level.

I've spent significantly more time in `man` pages than I ever have on a Linux distro.
OpenBSD heavily encourages putting all (and I mean *all*) the documentation in the `man` pages.
Odds are, if you google (or [duck](https://duckduckgo.com)) something with the term "openbsd,"
you'll get a link to a man.openbsd.org (which just mirrors the man pages on the web).
This isn't necessarily a bad thing, 
though I do find the examples a bit sparse in `man` pages sometimes.

Reference documentation requires more work to read than a how-to guide or tutorial,
but it forces you to think about what you're doing.
If you're willing to put in the time, 
you'll find that OpenBSD is extremely consistent.
If you expect something to work, it probably will.

In the process of setting up OpenBSD on my machines,
I've learned a lot about 
`pf`, 
`ssl`, 
NAT, 
`man` pages,
`SMTP` and email,
and
`httpd`,
to name a few.
Given what I've learned,
I feel confident I'll be faster at setting it up next time,
and much of the new information I've learned can be transferred to Linux as well.

# More stuff to set up

I'm going to continue sysadmin-ing it up
and will see how much I can host on a small vultr instance
without hitting a resource limitation (not that my site gets much traffic anyway :P).

I'd like to set up an email server, 
self host some of my git repositories from GitHub
(perhaps using [sr.ht](http://git.sr.ht)?),
and add more IndieWeb integration  
(primarly webmentions).

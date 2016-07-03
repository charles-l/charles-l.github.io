![](/assets/choices.gif)
*An accurate reenactment of me on the day this whole thing started*

As a Linux purist, I've spent a lot of time trying to find the ultimate distro that balances clean design and "unix-ness" with daily functionality. I've spent the last few weeks distro surfing, and I've learned a bit more about the options available.

I've used everything from RedHat to Debian over the last few years, and finally settled on ArchLinux as a standard distro that was fast and lightweight enough for me. However, Arch didn't cut it for a few reasons:

* **It uses `systemd`.**
Yes, I'm one of "those people" that hates `systemd` since it doesn't fit the Unix philosophy. I somewhat understand its appeal for standardizing servers for cloud-based deployments, and would even be alright with it, if it were only an init system. But it's not just an init system. It's a political project that's taking over more and more of the Linux userspace. It's got stupid, poorly written, tightly coupled components that *EVERYONE* is adopting. It's limiting user choice, since so many projects require it as a hard dependency now (though I've figured out hacks to get around that). <br/>
Suffice to say, I hate `systemd`, and am very frustrated that Arch adopted it, since it's not clean and seems extremely Micro$oft to me.<br/>
![](/assets/systemd.gif)

---

Uh...

Well, it was actually just that one reason :P

# Time to distro surf!
![](/assets/distrowatch.jpg)

Over the course of a few weeks, I downloaded, installed, and used a different distro every couple of days to see if I liked it. Here are the results:

* **Crux**.
Crux has interested me for a while, since it's a lightweight x86-64 targeting, source-based distro. It doesn't use `systemd`, looks simple and BSD-like, and meets all my purist goals, but it didn't really cut it for day to day use. I don't like having to configure the kernel and compile it, since I always forget a flag or two, and can't boot into my system immediately. So, I just copied the kernel from the live image, and booted into my new system (thinking I was extremely clever). Of course I forgot to copy the modules over, so when I tried to start the wireless, the kernel hung and didn't spit out any messages. I assumed something terrible had happened and moved on to the next distro. Crux seems good, if you know your hardware and can comfortably compile your own kernel or know of a decent default config (I'm stupid though, and didn't realize until long after what had happened). Maybe I'll give Crux another shot at some point.

* **Alpine**.
Alpine is another ridiculously simple distro, that uses musl-libc instead of the bloated and old glibc. I really liked the sound of that, and worked with it for a few days. The package manager was nice, the system was nice, but I couldn't install the nvidia drivers for my GPU, since they rely on glibc (and don't work with musl) :(

I bought a GTX 960 for the sole purpose of playing video games, so I wanted to eke out as much processing power from it as possible. Alpine barely missed the mark for my daily usage requirements and had to be thrown in the corner, but I'll definitely consider it for any kind of server or light-weight installation I'll need in the future. It really is great!

* **Gentoo (Funtoo)**.
Yes, it's the glorified BSD-like source-based distro that I've heard about and been meaning to try for a while (I got an 8 core CPU since I wanted to do a lot of fast compilation). With Gentoo, you can get `stage3` images that are optimized for your specific architecture, which seemed awesome. It's also got a whole lot of flexibility with it's `USE` flags and slot system.

Installation was a little rocky, but I got through it without too much trouble (yay for a pre-packaged debian kernel - that made life so much easier). The package manager was a bit confusing and didn't have the greatest documentation ever, but I found a few blog posts and pieced together things from the wiki and `man` pages. After a few package collisions (that I don't think should have happened), I managed to get a basic desktop environment working with `qutebrowser` (my main browser of choice). I got the nvidia drivers working easily as well, and was feeling pretty good after I installed Crystal (which required a bunch of fiddliness with downgrading LLVM to 3.5 which mesa didn't like, but, eh, it worked in the end).

Then, I realized the my web browser didn't show images. That should have been a quick fix: just grab the `imlib` package and add support for it in the `USE` flags, right? Nope, you have to add each individual file format to get it supported. So pop `png`, `jpg`, and `gif` into your `USE` flags, then recompile *every* package that needs to support it.

Just a minor annoyance, though. Once I got it working, I thought it would all be fine and my system could run smoothly. I had a harebrained idea that I could throw all the yucky packages in `docker` containers and use X forwarding, so I could play CS:GO and use Chrome, without messing up my nice clean environment.

Docker didn't work and needed some configuration to be set in the kernel. I was back to the twiddle-with-kernel-flags-recompile-and-rebooting cycle, again.

Meanwhile, I was attempting to work on my OpenGL project in Crystal, only to realize that the version of OpenGL I had installed was a few months out of date. It's a source-based distro, so I assumed that it stay as up-to-date as Arch, but it certainly didn't work out that way.

I upgraded my nvidia driver for the third time, which... borked my whole X configuration.

That was the last straw. Your package manager should at least be able to handle upgrades without making me sift through the entire package list to rebuild everything to add support for it. I like digging into the guts and figure out how everything fits together and works, but there's too much complexity in Ge/Funtoo for me to be able to get through a week without running into a problem. I didn't really need the extra flexibility it gave me, and most of time it just failed to have sane defaults (I don't want the most minimal package build most of the time).

Apparently, OpenBSD and FreeBSD have better ports management, so I'll have to try them out, but I've been sorely disappointed by the source-based Linux distros. They don't "just work", which really isn't too much to ask for. I used `brew` for years without running into an issue every few minutes, so I have very little patience for `portage`. Apart from that, I *really* liked the idea of a slot system (since it's simple and works better than things like `rvm`), but that wasn't enough to keep me around.

* **Void Linux**
To sum it up quickly, Void Linux is what ArchLinux is supposed to be. It uses an alternative init system, has a blazing fast package manager and is very lightweight.

Apart from the stupid command names, `xbps` is one of my favorite binary package managers. I thought `pacman` was fast - and it is, compared to `apt` - but it's not nearly as fast as `xbps`. I was this close to using it as my main Linux distro too, but...

It didn't have Crystal in it's package list. I didn't think that would be a problem, since I could just write the package myself and create a PR for the package repo. Arch has Crystal in its package list, so it can't be hard to support, right?

Then I realized that Void *only* supports the latest versions of packages, which is why they didn't have Crystal in the first place. Crystal uses a version of LLVM that's a year old, so instead of compromising the purity of the package list, Void just ignores Crystal, unless it updates to a newer version of LLVM. I can understand that, but it doesn't really meet my goals for day-to-day use, so Void had to go too.

I'll keep it in mind if I never need a pure, ArchLinux-like distro in the future.

----

So, my choice for a Linux distro after installing and using almost every non-systemd based distro known to man is...

_\*Drumroll\*_

ArchLinux.

_\*Dodges rotten tomatoes\*_

Wait, wait, wait! It's not vanilla ArchLinux. I ditched [`systemd` and replaced it with OpenRC](http://systemd-free.org/) (thanks to the Gentoo guys for writing OpenRC!). My system works just fine, doesn't run `systemd`, and meets all my requirements for day-to-day use (plus I've used Arch for so long that I can fix almost any issue I run into, of which there are few). It has all the packages I need, has sane defaults, stays up to date with the bleeding-edge and works surprisingly well with OpenRC.

I even figured out how to play CS:GO without PulseAudio! More ways to cut the cruft!

----

Maybe I'll write my own distro at some point, but for now, Arch is working out well for me. I'll probably continue to use it for years (despite its use of systemd), but will quickly switch if any of the distros I've listed could work for me on a day-to-day basis. For now, I've just got to compromise a bit.

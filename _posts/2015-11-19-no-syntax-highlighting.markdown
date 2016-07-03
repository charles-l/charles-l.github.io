---
layout: post
title: No syntax highlighting??!!
---

Yep.

There have been [many](http://www.linusakesson.net/programming/syntaxhighlighting/) [arguments](http://evincarofautumn.blogspot.com/2014/12/why-i-dont-use-syntax-highlighting.html) [against](https://medium.com/@MrJamesFisher/your-syntax-highlighter-is-wrong-6f83add748c9#.hxdyqwvpe) syntax highlighting. Some are a bit extreme, but the general consensus is that the colors give an incorrect meaning to the code or put emphasis where it should not be. Some people swear that monochrome coding is the only way to go, so I decided to give it a try.

When it comes down to it, colorschemes are primarily functional in two ways:

- they allow you to quickly scan and parse the contents of a string
- and, (if you write a lot of lisp), are useful in displaying rainbow parentheses.

I wrote a [tiny Vim colorscheme](https://gist.github.com/charles-l/4a5b9cbd0ef6d61ba59d), that colors strings and comments gray (as well as some UI so it stays out of the way). These tweaks may seem somewhat minor, but there is a noticeable difference between a minimal colorscheme and no colorscheme.

So, has turning off syntax highlighting changed my coding experience and unlocked a new level of potential that was inaccessible to me before? Not really. Since strings are still highlighted, I haven't missed my old colorschemes, and perhaps I read code a bit more linearly now (rather than jumping from one highlighted word to the next), but in the end, I don't really notice a huge change.

The only other advantage to a simpler colorscheme is that I'm not constantly downloading and trying out new ones. Black, white and gray show up perfectly in all terminal configurations, and I have no need for tweaking my terminal's default base16 colors to make Vim look decent.

I haven't yet given up highlighted `ls`. I guess I could change my `ls` alias from `ls --colors=always'` to `ls -F`, but I find it mentally easier to glob colors than try to differentiate between filenames/directory names with slashes on them. I also think it's excusable because there's less linguistic meaning behind a list of filenames than a piece of code.

In the end, I'm going to stick with my simpler colorscheme. If nothing else, it at prevents me from wasting time fiddling with my vimrc, and makes maintenance easier. Less is more!

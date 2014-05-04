---
layout: post
title:  "Ludum Dare 29 Post Mortem"
date:   2014-05-04 08:19:29
categories: ludumdare gamedev vim love2d programming
---
[Play Ninja vs Worms!](http://www.ludumdare.com/compo/ludum-dare-29/?action=preview&uid=24096)

## What went right
I managed to get it done! This is my second Ludum Dare submission, and I really cut it close this time, but I managed to release a fairly finished product 30 minutes before the deadline. I had a few issues with my physics library, but I managed to solve most of them before releasing. The only collision issues left were some minor issues with the wall.
The game ended up being more fun than I though it would be, even though I didn't plan ahead at all. I literally had no idea what I wanted to do before, other than wanting to have a ninja fire a bow at something coming out of the ground. I just started writing code and saw what it came out.

Some of the assets came out pretty nice. I really like the ninja, the arrows and the music (which I wrote in about 30 minutes). It's not great, but I'm still proud of it :P

## What went wrong
I didn't do enough work on the worm asset. It looks really choppy and awkward. If I could do it again, I would just draw an individual section of the worm and have the other sections follow it. I also wanted to add line beneath the worms showing the tunnel the worms dug. I just ran out of time before I could.
The balance was a little off. Some people figured out how to spam arrows and sit in the corner. I'll have to add some safeguard against that.

Finally, I wish I'd added more variation to the gameplay. Maybe another weapon, or mechanic.

## A few tips (if I may :P)
Good physics and collision solving are super important, guys. If the physics don't work right, it turns me off the game really quickly. If you really want to write a physics engine for your submission, that's fine, just practice it first. I spent a few days writing a simple AABB collision library, just to see how it works. I still prefer to use an external physics library, though.

Try to limit the scope of the game. Game jams are for getting interesting core gameplay, not for creating an entire game. A single level with fun gameplay is preferable to a multilevel game with stale gameplay.
Keep the art simple. Unless you have a dedicated artist (for the jam). I recommend sticking to pixel art, because it's easy, fast and usually looks pretty good.

## Stuff I used
I used [Pixen](http://pixenapp.com/) to create all of the pixel art this time. It's open source, but you also have the option to pay for the binaries. Me, being the cheapskate that I am, built it from source. It's a good editor, and worth $10 if you don't want the bother of building it. I've used [Pickle](http://www.pickleeditor.com/) in previous game jams, but it's not quite as powerful as Pixen (but it's a little simpler to use).

I wrote the music in GarageBand really quickly. I'm more of a performer than a composer, so for me, writing music consists of hitting a few notes that sound good together, then adding a second track and playing a harmony. I haven't really learned music theory :P. To make it sound retro, I added a bitcrusher filter to everything and exported in as low quality as I could.

As always, I wrote the game in [Lua](http://www.lua.org/) and used the [Love2D](http://love2d.org/) game engine. I also used the following libraries:

* [Hardon Collider](https://github.com/vrld/HardonCollider/) for collision detection. Maybe it wasn't the best idea, to use this, because it didn't have collision solving built in, and I didn't know it very well, but it ended up working out OK in the end.
* [HUMP](https://github.com/vrld/hump) gives you a bunch of awesome features including:
  * Timers
  * A Camera
  * Gamestates
  * A simple vector
  * Classes (but I prefer middleclass. See below)
* [anim8](https://github.com/kikito/anim8), an awesome animation library. It really helped out with this game.
* [MiddleClass](https://github.com/kikito/middleclass). A really awesome class library for Lua. I use it for all my games.

If you want to see a bunch of crappy game jam code, I have [Ninja vs Worms in a GitHub repo](https://github.com/charles-l/LD29). It's better organized than my last Ludum Dare submission, but has some really hacky collision code that's mixed in everywhere. Sorry 'bout that :P

Thanks for reading. I learned a lot from this jam and I hope you got something out this article.

Happy game jamming :) <br/>
- Chuck

You can play [Ninja vs Worms!](http://www.ludumdare.com/compo/ludum-dare-29/?action=preview&uid=24096)

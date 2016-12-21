---
layout: post
title: notes on writing an x86 assembler
date: 2016-12-20
---

*I released version 1.0 of [a simple x86 assembler](https://github.com/charles-l/dirt/blob/aafabe70d19d13ae4096b8037f246ac4443f6b50/dirt.scm). It might be a helpful reference.*

When presented with one of the seven 2000+ page Intel development manuals, it can seem like writing an x86 assembler is monumental task that's impossible without an army of programmers. While implementing every last x86 opcode may be a huge task, implementing the (extremely) small subset of opcodes that most people actually know and use is pretty trivial. x86 is definitely weird and [stupidly bloated](http://www.righto.com/2013/09/intel-x86-documentation-has-more-pages.html), but with a [few](http://ref.x86asm.net) [good](http://wiki.osdev.org/X86-64_Instruction_Encoding#ModR.2FM_and_SIB_bytes) [resources](http://ref.x86asm.net/coder32.html#xFF) it becomes mostly mechanical to translate opcodes to their binary equivalent. It took me only a weekend and a half to get a basic x86 assembler that can generate flat x86 binary files.

# x86 encoding

## Registers

Registers are indexed in an order according to the table below:

 name | index
------|-------
 %eax | 0
 %ecx | 1
 %edx | 2
 %ebx | 3
 %esp | 4
 %ebp | 5
 %esi | 6
 %edi | 7

<small>(Why they're in that order? I have no idea...)</small>

An important thing to note is that the index can fit in 3 bits. This becomes important with... the dreaded modr/m bytes!

## modr/m bytes (they're really not **that** bad &trade;)

x86 utilizes every last bit it can, and encodes some data in what's called a ModR/M byte.

Consider the following color coded byte (ain't it purty?):

<span style="color:#f15">00</span><span style="color:#2da">000</span><span style="color:#61f">000</span>

The red section encodes the mod (we'll come back to that in a minute), the green section encodes the first register and the blue section encodes the second register.

Register indices can fit in 3 bits, so that makes sense. The only weird part is that sometimes an opcode can have an opcode extension. They're basically just different opcodes, but they guys who made x86 got too excited and used up the 255 other opcodes that they were allotted. These opcode extensions replace the green register section when they're needed.

Coming back to the mod, there are 4 mod modes you can use for ModR/M bytes:

0 | &#8594; | Dereference the value of the register
1 | &#8594; | Add an 8 bit offset to the register, then dereference
2 | &#8594; | Add a 32 bit offset to the register, then dereference
3 | &#8594; | Just use the register's value

<br/>
So, here are a few quick examples:

<pre>
mov %eax, %ebx        ; uses the modr/m byte <span style="color:#f15">11</span><span style="color:#2da">000</span><span style="color:#61f">011</span>
mov %eax, (%ebx)      ; uses the modr/m byte <span style="color:#f15">00</span><span style="color:#2da">000</span><span style="color:#61f">011</span>
mov %ecx, -3000(%edx) ; uses the modr/m byte <span style="color:#f15">10</span><span style="color:#2da">001</span><span style="color:#61f">010</span>
</pre>

Where is the `-3000` offset on the last line you ask? That has to be emitted as a word directly after the ModR/M byte.

## immediate values

x86 (at least in 32bit mode) only has two main sizes that I've used: bytes and words. Bytes are 8 bits and words are 32 bits (this is true for protected mode, [but they are 16 bits in real mode](https://en.wikipedia.org/wiki/IA-32#Operating_modes) - beware if you're working with kernel code).

Words are written in reverse byte order, so `0xDEADBEEF` would be emitted as `0xEF` `0xBE` `0xAD` `0xDE`.

## code+reg

In some odd instances, the opcode is directly or-ed with the first register. This is perfectly safe, since only opcodes that are divisible by 8 do it.

# next steps

That covers most of the strange quirks I ran into while writing my [x86 assembler](https://github.com/charles-l/dirt/blob/aafabe70d19d13ae4096b8037f246ac4443f6b50/dirt.scm). With the help of [this table](http://ref.x86asm.net/coder32.html), I was able to quickly get at all the opcodes I needed to implement. It was far more convenient than trying to dig through the massive x86 pdf that Intel had to offer.

I'm going to eventually figure out how to write a linker so I'll save the following space for that:

<center><h3>SPACE RESERVED FOR A POSSIBLE EXPLANATION OF LINKERS</h3></center>

In the meantime, I'll be working on incorporating this assembler into my compiler. Who knows, maybe I'll eventually extend it into a JIT library.

If you found any issues with this post, feel free to ping my on [Twitter](http://twitter.com/theninjacharlie).

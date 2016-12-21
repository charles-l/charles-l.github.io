---
layout: post
title: debugging on OSX with LLDB
date: 2015-02-06 12:00:00
---

As a beginner C programmer, I've just recently started building projects that require real debugging that's more complex than a simple `printf` call. Debuggers are a standard tool that any C developer has to use once they've got the basics of C down.

I work from the command line on OS X and don't want to bother opening a GUI and breaking my workflow, so the only real option I have is `lldb`, which is Apple's custom version of `gdb` (this of course means it'll has have it's own weird quarks, like any of Apple's development tools). If you're used to using `gdb` there's a [page on the LLVM site](http://lldb.llvm.org/lldb-gdb.html) that shows how commands in `gdb` can be translated to `lldb`.

Let's look at some code we're going to debug:

```c
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv) {
        printf("The second arg is %s", strcat(argv[1], "!"));
        return 0;
}
```

The obvious issue with this code is in the `printf` statement that will attempt to concatinate the second argument with a '!', even if no second argument is passed to the utility. This will result in a segfault, that we will track down using `lldb`.

Before firing up LLDB, make sure you're building your program with debug symbols, otherwise you won't be able to set breakpoints by line number or view what C code is currently executing. Adding the `-g` flag to your compile command will build the program with debug info.

    clang -g -o mytest test.c

Now run `lldb`, passing the name of your executable as the second argument:

    lldb mytest

Type `l` into the prompt. This is an alias for the `source list` command, which allows you to see the top few lines of code in your `test.c` file.

Now set a breakpoint at line 5 by typing `b 5`. The breakpoint will stop execution in `lldb` when it reaches that line. This allows you to go step by step over each line of code, while analyzing the state of the program.

To begin the execution of your program, type `run`. Your program will run until it hits the line that you marked with a breakpoint.

At this point, we are able to see all kinds of information about the program with a few commands. The first thing we may want to know is the value of the local variables. Typing `fr v` (alias for frame variables), will show all of the local variables in the current scope (or frame). In this case, it's just `argv`. To drill down further, type `p argv`, to see what the array contains. Since we didn't pass any arguments to `mytest` when we started `lldb`, it currently contains nothing but the name of executable.

We can now step line by line over the code and break at each statement. To go forward one step, type either `si` (step into the function) or `n` (step over function, to the next line).

Type `n` and to continue execution to the end of the program (or until the next breakpoint). You should get something like this:

    Process 29707 stopped
    * thread #1: tid = 0x3bcaf0, 0x00007fff86063172 libsystem_c.dylib`strlen + 18, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=1, address=0x0)
        frame #0: 0x00007fff86063172 libsystem_c.dylib`strlen + 18
    libsystem_c.dylib`strlen + 18:
    -> 0x7fff86063172:  pcmpeqb (%rdi), %xmm0
       0x7fff86063176:  pmovmskb %xmm0, %esi
       0x7fff8606317a:  andq   $0xf, %rcx
       0x7fff8606317e:  orq    $-0x1, %rax

That `EXC_BAD_ACCESS` means the program hit a segfault (i.e. the OS is preventing us from accessing memory that we shouldn't read). In this case, we are trying to access the second element of the `argv` array which was never initialized, so the `argv` pointer has gone past the bounds of the `argv` array.

Sometimes, you may not want to step through every line of code after a breakpoint. In situations like this, you can use `lldb`'s backtrace to get information about the state of the program the moment before the crash.

After loading your program and typing `run` (no need to set a breakpoint), the program will crash. Type `bt` to see the stack frames and the lines of code they were executing before the crash (stack frames are the way scope is controlled, so each stack frame is just a scope of your program). When you see a questionable frame (probably one that contains your code), type `fr s <framenumber>` to select the frame (by whatever number the frame is). `lldb` will print the line of code that frame was on when it crashed.

## Miscellaneous commands
- `m r 0x000001 -f i` or `memory read 0x000001 --format i` - read the code at memory location `0x000001`

----------

Debugging C code in a console may seem daunting at first, but if you know a few commands, you can get by pretty well. Let me know if you have any questions [on Twitter](http://twitter.com/theninjacharlie)

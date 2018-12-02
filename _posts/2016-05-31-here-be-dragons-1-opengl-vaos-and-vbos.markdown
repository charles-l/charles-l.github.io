---
layout: post
title: here be dragons #1: OpenGL VAOs and VBOs
date: 2016-05-31
---

OpenGL is one of the worst APIs I've worked with. It's confusing, has awful error reporting, is poorly documented, segfaults in the strangest ways and doesn't sandbox anything (I've accidentally crashed my graphics driver a couple of times already).

It's terrible.

But who cares?

![]({{site.url}}/images/whocares.gif)

# WE CAN HAZ PRETTY GRAPHICS AND GAMES AND STUFF

I'll be documenting whatever oddities I run into so (hopefully) these posts will help someone out in the future.

# First off OpenGL 2 != OpenGL 3

I'm not sure about the jump from OpenGL 3 to 4, but OpenGL 2 and 3 have completely different ways of rendering geometry. They're not the least bit compatible, and a lot of examples on the intertubes use OpenGL 2 or older which won't work anymore (unless you're specifically using OpenGL 2). Make sure you pay attention to the version.

The old way (pre-OpenGL 3) of drawing polygons was to use `glBegin()` and `glEnd()`.

```c
glBegin(GL_LINE_LOOP);
glVertex3f(-1.0f,0.0f,0.0f);
glVertex3f(0.0f,-1.0f,0.0f);
glVertex3f(1.0f,0.0f,0.0f);
glVertex3f(0.0f,1.0f,0.0f);
glEnd();
```

Of course, this is terrible and gross in so many ways, but it at least makes sense.

**Fear not! This is cleaned up in OpenGL 3**

![]({{site.url}}/images/abstraction.png)

# Introducing two brand new 2008 OpenGL features: VAOs and VBOs!

**VBOs** (or Vertex Buffer Objects) are just buffers of memory that you can push onto the GPU (they're not actually objects in the sense of oop - they're called that to confuse you). Think of creating a VBO like dynamically allocating memory with `malloc`. Except you it's on the GPU and you don't have to free it.

VBOs are used to store things like:

* Arrays of floats that contain vertex position information
* Arrays of floats that contain vertex normal information
* Arrays of floats that contain vertex UV information

**VAOs** (or Vertex Array Objects) have an even worse name, since they sound like they're the same as VBOs, but they're not at all. VAOs are used to keep track of and a group of related VBOs. A VAO may reference three VBOs for a single object: a vertex position VBO, a vertex normal VBO and a vertex UV VBO.

Here's a fun tidbit. When you're binding VBOs to a VAO, you don't specify which VAO you're using. It just uses the last one you made.

```c
GLuint va_id;
glGenVertexArrays(1, &va_id); // made the VAO
glBindVertexArray(va_id); // bound it

GLuint vb_id; // vertex buffer
glGenBuffers(1, &vb_id); // make the VBO
glBindBuffer(GL_ARRAY_BUFFER, vb_id); // bind this to the VAO (using the last VAO)
glBufferData(GL_ARRAY_BUFFER, vertices.size, vertices, GL_STATIC_DRAW); // pop the data on

GLuint vn_id; // normal buffer
glGenBuffers(1, &vn_id); // make the VBO
glBindBuffer(GL_ARRAY_BUFFER, vn_id); // bind this to the VAO (using the last VAO)
glBufferData(GL_ARRAY_BUFFER, normals.size, normals, GL_STATIC_DRAW); // pop the data on
```

OpenGL does a lot of this hiding-important-information-in-a-global-and-not-telling-you-about-it, then laughs at you when everything breaks.

Ugh...

That's all for now. I'll post again when I next feel like ranting.

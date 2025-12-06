---
layout: post
title: "Building a Jekyll Blog with AI: An Honest Take on 'AI Slop'"
date: 2025-12-06 10:00:00 -0500
author: Jon Goodall
categories: [Web Development, AI]
tags: [jekyll, ai, claude, automation, meta]
excerpt: "Let's be real: I'm a cloud engineer, not a web developer. This entire site was built with AI assistance. Here's what that actually means, why I'm not pretending otherwise, and why it's still interesting."
image: /img/kiro.png
---

## Building a Jekyll Blog with AI: An Honest Take on "AI Slop"

Let's get something out of the way immediately: **I didn't write most of the code for this website.** An AI did. Specifically, Claude (via Kiro IDE) wrote the Jekyll templates, the CSS, the JavaScript, the Ruby scripts, and even this blog post you're reading right now.

Is this "AI slop"? Maybe. Am I going to pretend I hand-crafted every line of HTML? Absolutely not.

## Why Be Honest About It?

I'm a Principal Cloud Engineer. I work with AWS, Terraform, Kubernetes, CI/CD pipelines - that's my domain. I can architect a multi-region serverless application, but ask me to center a div and I'll probably Google it like everyone else.

When I decided to modernize my portfolio site and add a blog, I had two options:

1. Spend weeks learning modern web development best practices, Jekyll internals, Bootstrap 5, and frontend tooling
2. Use AI to handle the web dev parts while I focus on the content and infrastructure

I chose option 2, and I'm not ashamed of it.

## What "AI-Assisted" Actually Means

Here's what the process looked like:

### What I Did:
- Decided what I wanted (multi-page site, blog, modern design)
- Provided feedback ("the hero header is crap", "color scheme needs better contrast")
- Made high-level decisions (GitHub Pages hosting, Jekyll, Bootstrap 5)
- Said "yes" or "no" to changes
- Pointed out when things were broken
- That's about it, honestly

### What Claude Did:
- Wrote Jekyll layouts and includes
- Created responsive CSS with proper color contrast
- Built the blog listing and pagination system
- Generated category and tag pages
- Created Ruby scripts for automation
- Wrote property-based tests
- Fixed bugs and styling issues

### What We Did Together:
- Iterated on design ("much better", "still crap")
- Debugged issues (blog not showing posts, 404s on category pages)
- Improved the workflow (automated taxonomy generation instead of manual pages)

## The Interesting Part

Here's what I find genuinely interesting about this process:

**1. It's Not Magic**

The AI didn't just conjure a perfect website. It took iteration, feedback, and course correction. I had to know what I wanted and be able to articulate when something wasn't working.

**2. It's Still My Site (Sort Of)**

The decisions are mine in the sense that I said "yes" or "no" to things. The content is be mine (apart from most of this post, guess which bits I did for bonus points). But let's not pretend I "architected" this - I just pointed at things and said "make it work" or "that's ugly".

**3. It Reveals What Actually Matters**

Turns out, for a personal blog, the code quality matters less than:
- Does it work?
- Is it maintainable?
- Does it look professional?
- Can I focus on writing content instead of fighting with CSS?

The answer to all of these is yes.

**4. The Transparency Is The Point**

I could have built this with AI and never mentioned it. Many people do. But I think the interesting story here is being honest about the process.

I'm not a web developer. I don't want to be a web developer. But I wanted a modern, professional site. AI made that possible without requiring me to become an expert in a domain I don't care about.

## What This Means for "AI Slop"

The term "AI slop" usually refers to low-effort, mass-produced content that floods the internet. And yeah, that's a real problem.

But is this that?

I'd argue no, for a few reasons:

1. **It's Transparent**: I'm telling you exactly how it was built
2. **It's Purposeful**: This site serves a specific purpose for me
3. **It's Maintained**: I'm responsible for it and will keep it updated
4. **It's Honest**: I'm not claiming expertise I don't have

The alternative would be:
- Paying a web developer (expensive, ongoing)
- Using a cookie-cutter template (limiting, generic)
- Not having a blog at all (boring)

## The Real Question

The real question isn't "Is this AI slop?" It's "Does this add value?"

For me, the answer is yes:
- I have a professional online presence
- I can share technical content about DevOps and cloud engineering
- I can maintain and update it myself

For you, the reader, hopefully it's also yes:
- You get honest technical content about cloud engineering
- You see a real example of AI-assisted development
- You can judge for yourself whether the result is valuable

## The Workflow

Since this is a technical blog, here's what the actual workflow looked like:

```bash
## 1. Started with a forked one-page portfolio
git clone https://github.com/jdgoodall1/jdgoodall1.github.io.git

## 2. Used Kiro IDE to modernize it
## - Created spec documents (requirements, design, tasks)
## - Iterated on implementation
## - Fixed issues as they came up

## 3. Automated the boring parts
rake generate_taxonomy  # Auto-generates category/tag pages
rake serve             # Runs Jekyll with live reload

## 4. Deploy
git push origin main   # GitHub Pages handles the rest
```

The entire modernization took a few hours of back-and-forth with the AI, versus what would have been weeks of learning and coding.

## What I Actually Learned

Let's be real: not much. I didn't suddenly become a Jekyll expert or learn Bootstrap 5. I mostly just said "this looks crap" or "the blog isn't showing posts" and let the AI figure it out.

Could I maintain this? Eh, kinda. Could I modify it? Maybe simple stuff. Did I learn the deep internals of Jekyll templating? Absolutely not.

And that's fine. That was never the goal.

## The Bottom Line

This site is "AI slop" in the sense that an AI generated most of the code. But it's not slop in the sense of being low-quality, thoughtless, or deceptive.

It's a tool that let me focus on what I'm good at (cloud engineering, DevOps, technical writing) while still having a professional web presence.

Is that cheating? I don't think so. It's just using the right tool for the job.

## Your Turn

If you're reading this and thinking "I could never build a website", maybe reconsider. With AI assistance, you probably can. You just need to:

1. Know what you want
2. Be able to give feedback
3. Be willing to iterate
4. Be honest about the process

And if you're reading this thinking "This is exactly what's wrong with AI", I respect that. But I'd rather be honest about using AI than pretend I'm something I'm not.

## Meta Note

Yes, Claude wrote this blog post too. I gave it the direction: "lean into the AI slop label but be honest about it - I'm not going to claim this as my work in any meaningful way, I just think it's interesting but can't be bothered to write it."

And here we are.

Is it slop? You decide.

---

**Update**: If you want to see the actual code and process, it's all public on [GitHub](https://github.com/jdgoodall1/jdgoodall1.github.io). The README is transparent about how it was built, and you can see every commit.

**Another Update**: The irony of using AI to write a blog post about using AI to build a blog is not lost on me - or Claude actually, it wrote that joke.

---
layout: post
title: "Gitlab vs. Github"
date: 2020-05-12 09:00:00 -0500
author: Jon Goodall
categories: [DevOps, Tools]
tags: [gitlab, github, ci-cd, git, pipelines, github-actions]
excerpt: "Since I posted my article on DevOps tools, Gitlab has launched their #gitchallenge. This is to compare Gitlab and GitHub, so that's what I'm going to do (and hopefully get a free t-shirt, or socks, I like socks)."
image: https://images.unsplash.com/photo-1556139943-4bdca53adf1e?w=1200
---

![Socks](https://images.unsplash.com/photo-1556139943-4bdca53adf1e?w=1200)
*Photo by [Unsplash](https://unsplash.com/photos/shallow-focus-photography-of-persons-feet-1zTetyivDYE)*

Since my I posted my article on DevOps tools, which was all funny names and no real content, Gitlab has launched their #gitchallenge. This is to compare Gitlab and GitHub, so that's what I'm going to do (and hopefully get a free t-shirt, or socks, I like socks).

I didn't talk about either tool in the last article, because the names didn't meet my arbitrary criteria of "sounds a bit funny". I hadn't used them either, so wasn't qualified to talk about it. Since then I've used both for work, so can talk about them at some length.

I'm going to avoid going into exhaustive detail, because that's boring, and I'll do several tl;dr sections as I go along - like this:

## Overall Thoughts

**TL;DR:** For "home" users (i.e. having an online presence) use github, just for brand-awareness outside of the tech community.

For "doing actual work", if you already have a git solution, that isn't a "home rolled git server", just stay with it. It's not worth leaving unless you need a specific piece of functionality. Or you're desperate to not use Jenkins (can't say I blame you).

If you don't already have a solution use gitlab, for now. The built-in CI/CD is that much better than Github it's worth picking gitlab just for that. Github is improving its offering though, so who knows how long that will last for?

See that up there? That's what I mean, good overview, not too long or boring. At least I think so.

OK, let's do some sections so you can pick and choose which parts of this you care about. It'll stuff my reader stats, but oh well.

### Sections:
- Git Functions
- CI/CD
- Free website Hosting
- Things they let you do but shouldn't
- Other stuff that's relevant, but isn't really a feature
- Closing thoughts

## Git Functions

**TL;DR:** Doesn't matter, they're about even.

**Long Version:** Ok, so this is the basic stuff. They both do everything that you could want at a high-level, for example:

- Multiple team members
- Varying level of permissions for team members
- Branch protection
- Merge Requests/Pull Requests
- Mandatory approvals on these
- CI/CD pipelines triggers

They both cover these in a fairly similar way, so I'm not going to dwell here. The only thing of note is that Gitlab calls requests to merge code "Merge Requests", which is logical. Github calls the same action a "Pull Request", which is illogical. However this has been adopted as a term by other tools as well (e.g. bitbucket), so your lexicon will be a little different. 

**Winner:** It's a draw

## CI/CD

**TL;DR:** Gitlab wins this by a country mile (is that longer than a regular mile? I don't know). The interface is better, parallel build steps actually exist, there's manual approvals built-in and the code-reuse is better.

**Long Version:** This is where gitlabs' longer history of offering built-in CI/CD becomes quite obvious.

Both Gitlab and Github offer built-in CI, through Gitlab pipelines, and Github Actions. Github actions has only been available since around December 2019(ish?), and it's pretty good.

There are a few critical oversights though. I'll illustrate this with an example, that I've implemented in both tools before:

**Task:** End-to-end automated deployments to production, and all lower environments, based on a merge to the master branch. The deployment to production is behind a manual approval, because you're not Netflix. You're rebuilding the artefact here, to ensure that you've captured hotfixes.

### The GitHub way: 
*(that's a bit Zen isn't it? I kinda like it, might do that again)*

1. Trigger a build based on a push to the master
2. The build runs each step sequentially
   - Build the artefact
   - Deploy to the lower environments
   - End with a call to the API to create a draft release.
3. Someone publishes the release, which triggers another workflow to run the deployment to prod.

This seems OK, but the problem is you have to change views within Github to run the process end-to-end, so you need at least two windows open. The manual approval is also a fudge using the API to create a draft release.

Compare this with:

### The Gitlab Way: 
*(yep, sticking with this)*

1. Trigger a pipeline based on a push to the master
2. The pipeline runs which:
   - Builds the artefact,
   - Deploys it to lower environments in parallel
   - Waits for a manual approval for production
3. You click the "play" button on the pipeline to deploy to prod, and you're done.

This is better for a few reasons:

- Everything is in the same view, so no jumping around the site to get it done.
- The process is more intuitive, as all the required steps are in the same pipeline file.
- You don't have to mess around with the API to implement a manual release approval
- You haven't had to write a script to call the API
- Although I would highly recommend that you implement releases and tagging in your workflow as a best practice, you shouldn't have to do it for the sake of a deployment

**Winner:** Gitlab. By a mile.

## Free website hosting

**Tl;DR:** Gitlab edges this for tech, but Github has this for name recognition outside of the tech community (e.g. recruiters). I'd call this a draw.

**Long Version:** Both tools do this pretty well, through the use of "pages". Each account gets one (1) free "pages" domain to host a static site on. Both offer custom DNS options. Both also offer a pre-generated one - e.g. https://jdgoodall1.github.io/ (disclaimer, my profile is hosted on Github for "sending it to recruiters" reasons).

Where they start to differ is build configuration. This is optional for Jekyll sites on Github but mandatory for all sites on Gitlab, making Github the marginal winner for lazy people. Like me.

**Winner:** Github, just barely.

## Things they let you do but shouldn't

Nice contentious title that one.

**TL;DR:** The answer to this shouldn't matter, and if it does to you then you're a Bad Person™. Github edges this if you do care.

**Long Version:** What I'm talking about here is in-browser edits. I'm a firm believer that these should be punished by buying a case of something expensive for the team, because you really shouldn't be doing these.

Both tools let you do this, for ease of use reasons I guess, and I'll admit to fixing the occasional typo in-browser, but that's about it.

If you're doing any real quantity of work in-browser then for the love of whatever it is you care to love, download an IDE. There are loads of free ones that are very good.

That being said, Github is better at this, because it has found a way to put VSCode in-browser, and let you use that for your edits. By doing changes in-browser though, you lose any ability to run tests on your local environment before committing to source.

Doing this runs the risk of making the git history muddy, so I'm not sure we should be striving to make this a better experience.

**Winner:** Github. But don't do this. Seriously.

## Other stuff that's relevant, but isn't really a feature

**TL;DR:** Github. If you say to a recruiter "here's my gitlab profile" they'll probably say, "Oh, like github?" This is brand-awareness, which is important in a few specific cases.

**Long Version:** In tech, you're expected to have an online profile of some sort, and to either blog (which I do) or contribute to open source projects.

The best-known home of such things is Github. Why this is, I couldn't tell you. However the end result is application forms that have "your Github profile" as a box to fill out, and no alternative options.

Yes, I've seen this before.

**Winner:** Github, because people suck

## Closing thoughts

You might've noticed that github "won" most of the sections there, but that the TL;DR section at the top doesn't neatly match the sections. That's because its not that simple - it never is. Also I'm using negative marking in some places just because I can.

My choice of which tool to use depends very highly on what you're trying to do.

If you need an online presence, and don't want to fight the tide, you should pick Github.

For ANYTHING ELSE, use Gitlab. The CI/CD offering is SO MUCH BETTER. So much so that its worth using Gitlab just for that. Yes the online editor in Github is better, but STOP USING IT YOU BAD PERSON.

Once you've used Gitlabs' pipelines you'll never want to use anything else again. Github is catching up in this area, but it's slow going. So do yourself a favour and chose gitlab.

**Fin.**

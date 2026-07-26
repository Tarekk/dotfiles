---
name: debrief
description: Terse problem / also-found / solution bullet debrief of the work just completed.
disable-model-invocation: true
---

A **debrief** is the after-action account of work just finished: what was actually wrong, what else surfaced, what now exists. Bullets only.

## Shape

These sections, in this order, and nothing else. No preamble, no closing summary, no offer of next steps — the sections are the entire reply.

```
## Problem
- …

## Also found        <- omit the whole section when nothing incidental surfaced
- …

## Solution
- …
```

## Rules

- One fact per bullet, one line each. No nested sub-bullets, no paragraph under a heading.
- **Problem** carries the root cause and the mechanism, never the symptom that was reported. Name the thing that did it: `file:line`, the function, the header, the measured value.
- **Also found** is what you stumbled on that was not the assignment — a second defect, an assumption that turned out false, a metric that meant something other than you thought. Omit the heading entirely when there is nothing; never write "none".
- **Solution** states what now exists and how it was verified, not what was attempted.
- Every claim must be one you established. A step you skipped, a check you could not run, a fix you could not confirm — each is a bullet, not an omission.
- A correction to something you asserted earlier in the session goes in the section it bears on. Silently dropping it is the failure mode.

---
name: debrief-review
description: Debrief the work just completed, then have a Fable 5 agent adversarially verify it.
disable-model-invocation: true
---

Write the debrief, then spend a second model on trying to break it. The review is **adversarial** by design: a reviewer that sets out to confirm your account finds nothing.

## 1. Debrief

Read `~/.claude/skills/debrief/SKILL.md` and produce the debrief exactly as it specifies — that file is the single source of truth for the shape and the rules.

Done when the debrief exists and every claim in it is one you established yourself.

## 2. Hand off to Fable 5

Launch a background subagent with `model: "fable"` and an agent type carrying full tools — it has to read the repo and run typecheck/lint itself. Background, not synchronous: a real review runs for minutes.

The prompt must carry:

- The debrief **verbatim**, fenced and labelled as the author's account.
- How to reach the work: repo path, branch, PR number, base branch, the diff command.
- **Do not take the debrief at face value — verify every claim against the code.** Without this instruction the reviewer paraphrases you back.
- What to scrutinise: the debrief's load-bearing claims, the edge cases the happy path skips, concurrency and failure branches, and anything the change makes newly reachable. Add the areas specific to this change.
- Constraints: read-only; no commits, pushes, or branch edits; no writes to production data even where credentials are present.
- The required report: a verdict of yes / yes-with-caveats / no; each defect with `file:line`, a concrete failure scenario, and a severity; every **overclaim** in the debrief; suggestions kept separate from defects.

Done when the agent is launched with the debrief and every element above in its prompt.

## 3. Verify the findings

Check each finding against the code yourself before acting on it or repeating it. A subagent's confident citation can still be wrong, and relaying an unverified finding launders its error into your own account.

Done when every finding is either confirmed against source you read, or rejected with the reason.

## 4. Fix and report

Fix the confirmed defects, and re-verify by the same means that established the original claims. Leave to the user only what is genuinely their judgement call, and name those.

Report the verdict, the confirmed defects and their fixes, what you rejected and why, and — separately — every **overclaim** the reviewer caught in your debrief. An overclaim quietly corrected is the one failure this skill exists to catch.

---
name: educate
description: Research a topic thoroughly across multiple web sources to find the latest consensus, best practices, and agreed-upon methodologies. Use when the user says "educate", "research this", "what's the best practice for", or wants a well-sourced, authoritative answer.
user-invocable: true
disable-model-invocation: false
argument-hint: "[topic or question]"
---

When this skill is invoked, conduct thorough web research before answering. Do NOT rely on training data alone.

## Research Process

1. **Search broadly first** - Run multiple web searches with varied queries on the topic. Use different phrasings, include "best practices", "2025 2026", "recommended approach", and the specific technology/domain.

2. **Evaluate sources** - Prioritize in this order:
   - Official documentation and specs
   - Widely-cited authoritative blogs (core team members, recognized experts)
   - Community consensus from Stack Overflow, GitHub discussions, Reddit (high-upvote answers)
   - Recent conference talks and articles from known practitioners
   - Discard outdated, contradicted, or low-quality sources

3. **Cross-reference** - Look for where multiple independent sources agree. Flag areas where opinions diverge and explain the tradeoffs.

4. **Check recency** - Prefer the most recent guidance. If best practices have changed recently, explicitly call out what changed and when.

## Response Format

- Lead with the consensus answer / recommended approach
- If there are competing schools of thought, present each with tradeoffs
- Cite your sources with links so the user can verify
- Flag anything that is your inference vs. directly sourced
- Note if the landscape is actively shifting or if guidance is stable

## Rules

- Always search the web. Never answer from memory alone.
- Use at least 3-5 different search queries to get broad coverage.
- Read the actual content of promising sources, don't just rely on search snippets.
- If the topic is too broad, ask the user to narrow it before researching.
- Be honest about confidence level and where sources disagree.

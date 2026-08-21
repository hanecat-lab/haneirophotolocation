---
name: token-aware-task
description: Convert an implementation request into a narrowly scoped, token-efficient Claude Code task brief before editing.
---

Create a concise task brief before implementation. State the precise goal, named files, acceptance criteria, relevant command or log excerpt, and whether a plan is required. Do not search broadly unless the brief explicitly requires discovery.

Classify the work as `small`, `standard`, or `complex`.

For `small`, perform only the requested edit and its closest verification. For `standard`, propose a short plan and wait for confirmation if the requested behavior or file set is ambiguous. For `complex`, use plan mode first and delegate broad repository research to a subagent; preserve only the summary in the main session.

Never paste a full test log. Ask for, or produce with the local CLI, only the error and 20–30 surrounding lines. After two failed correction paths, stop and provide a clean restart brief that incorporates what was learned.

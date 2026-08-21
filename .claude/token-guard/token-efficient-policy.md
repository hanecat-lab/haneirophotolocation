## Token-efficient workflow

- For requests spanning more than three files, unclear acceptance criteria, or unfamiliar code, first present a concise plan: target files, intended behavior, risks, and verification. Wait for confirmation before editing.
- For a small, named change, inspect and edit only the named file(s) and directly related test(s). Do not scan the repository without a concrete reason.
- Prefer existing lint, test, search, and CLI commands. Report only the smallest relevant excerpt of an error log (normally 20–30 lines).
- For a research task likely to require broad exploration, use a subagent and return only a concise, actionable summary to the main session.
- If two correction attempts fail on the same issue, stop the loop. State the learned constraints and recommend a fresh, focused prompt after `/clear` or `/rewind`.
- At the end of an independent task, recommend `/clear`. Use `/compact <focus>` only while the context is still useful and the next task needs that continuity.

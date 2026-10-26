# github-badges-catch-them-all

Small tools that use the **GitHub GraphQL API** to help a developer earn GitHub profile achievements the legitimate way: by doing real work and helping real people, not by farming.

## Tools

### `scripts/find-galaxy-brain.sh`
Finds recent GitHub Discussions in your areas of expertise that are still waiting for a first answer. Answering them well is how you earn the *Galaxy Brain* achievement.

- Searches Discussions through the GraphQL `search(type: DISCUSSION)` endpoint, one query per topic
- Keeps only questions in answerable (Q&A) categories that have **no replies yet**
- Filters out announcements, registry requests and other posts that aren't questions

```bash
./scripts/find-galaxy-brain.sh        # last 14 days
./scripts/find-galaxy-brain.sh 30     # last 30 days
```

Sample output:
```
== onnx is:unanswered
  ★13067 2026-10-23 https://github.com/colmap/colmap/discussions/4889 | Planning commercial use of COLMAP: ...
```

Edit the `QUERIES` array in the script to match your own topics.

**Requirements:** the [GitHub CLI](https://cli.github.com/) (`gh`), authenticated with `gh auth login`. The script only reads data; it never posts anything.

## Ground rules
- Answer only questions you actually understand, and write the answer yourself.
- No sock-puppet accounts, star trading or PR spam. They break GitHub's [Acceptable Use Policies](https://docs.github.com/en/site-policy/acceptable-use-policies/github-acceptable-use-policies).
- Answers in the GitHub Community forum (`orgs/community`) don't count toward achievements ([announcement](https://github.com/orgs/community/discussions/106536)).

## Progress
Badge status and next steps are tracked in [`docs/handoff/next-session.md`](docs/handoff/next-session.md).

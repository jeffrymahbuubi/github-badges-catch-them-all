# Next session handoff

Last updated: 2026-10-26

## Goal
Earn the remaining GitHub profile achievements for `jeffrymahbuubi`, legitimately, using `gh` / `gh-axi`.

## Status (checked 2026-10-26)
| Badge | Status | Notes |
|---|---|---|
| Pull Shark | ✅ earned | 47 merged PRs. Next tier (Silver) at 128 |
| YOLO | ✅ earned | |
| Quickdraw | ✅ earned | `work-with-claude` issue #1 was opened and closed within seconds on 2026-10-26 |
| Pair Extraordinaire | ⏳ done, waiting for badge | Merged PR #1 in `github-badges-catch-them-all`, co-authored by Claude (`noreply@anthropic.com`). If no badge appears after 24h, GitHub doesn't count that email; use a human collaborator instead |
| Galaxy Brain | ⬜ open | 2 answers accepted by **other people** in Discussions. Run `./scripts/find-galaxy-brain.sh [days]` every few days and answer the good matches yourself. 7 answers posted 2026-10-26; 5 can count (see "Galaxy Brain answers" below). **Answers in `orgs/community` never count** (GitHub, 2024-02-06, community discussion #106536) |
| Starstruck | ⬜ open | 16 stars on one repo. Best so far: `ultralytics-qat-intelligent-syringe-volume-measurement-project` (3) |
| Public Sponsor | ✅ earned | Sponsoring `opencv` publicly (2026-10-26). Can cancel any time; the badge stays |

Re-check status:
```bash
curl -sL 'https://github.com/jeffrymahbuubi?tab=achievements' | grep -oE 'Achievement: [A-Za-z ]+' | sort -u
```

## Decisions made
- Don't use the `EliseyRotar/github-achievements` scripts. They're broken: they grep `"number":N` but the API returns `"number": N`. Their at-scale methods also risk breaking GitHub's rules on inauthentic activity.
- No sock-puppet accounts, star trading or PR spam.
- All work goes inside this project folder, never `/tmp`.

## Setup done
- claude-flow initialized with `--minimal --no-global --no-mods ...`. `~/.claude` was verified unchanged.
- claude-flow memory: namespace `github-badges`, key `badges-status-2026-10-26`.
- Claude auto-memory: `github-badges-progress`, `no-tmp-work-in-project`.

## Galaxy Brain answers (posted 2026-10-26)
| Discussion | Topic |
|---|---|
| ruvnet/ruflo#4309 | ruflo prompt-injection report |
| community/community#211223 | GitHub Mobile 2FA number mismatch (Community forum, doesn't count for the badge) |
| community/community#211273 | Workflows not registered on a fork (Community forum, doesn't count for the badge) |
| gotd/td#1858 | Telegram login code (pointed to Telegram support) |
| utmapp/UTM#8012 | Windows 10 VM has no network (e1000/rtl8139) |
| remix-run/remix#12085 | npm fonts 404 with the Tailwind CLI (asker has accepted answers 3 times) |
| netbirdio/netbird#8322 | macOS Installer bundle relocation (asker has accepted answers twice) |

How to pick questions likely to be accepted: favor askers who have accepted **other people's** answers before (search `author:<login> is:answered` and keep results where `answerChosenBy` is the asker and the answer's author is someone else). Skip 0-star repos where accounts accept each other's answers; that's badge farming. Candidate and asker-score dumps from 2026-10-26: `.claude-flow/logs/gb-*.tsv` (gitignored).

Check which are accepted, and reply to any follow-up questions:
```bash
for s in ruvnet/ruflo:4309 community/community:211223 community/community:211273 gotd/td:1858 utmapp/UTM:8012 remix-run/remix:12085 netbirdio/netbird:8322; do
  r=${s%:*}; n=${s#*:}
  gh api graphql -f o=${r%/*} -f r=${r#*/} -F n=$n -f query='query($o:String!,$r:String!,$n:Int!){repository(owner:$o,name:$r){discussion(number:$n){isAnswered answer{author{login}} comments{totalCount}}}}' \
    --jq "\"$s answered=\(.data.repository.discussion.isAnswered) by=\(.data.repository.discussion.answer.author.login // \"-\") comments=\(.data.repository.discussion.comments.totalCount)\""
done
```

## Other profile badges (source: gomzyakov/github-achievements, 2026-10-26)
Highlights you have: **Pro**. Ones you could get without a popular repo:
- **Developer Program Member**: README added (PR #2, merged 2026-10-26). **User still needs to submit** https://github.com/developer/register with integration URL https://github.com/jeffrymahbuubi/github-badges-catch-them-all. Afterwards, check that the profile Highlights show it.
- **Security Advisory Credit**: get credited on an advisory accepted into the GitHub Advisory Database (report a real vulnerability through a repo's private vulnerability reporting).
- **GitHub Campus Expert**: student program at education.github.com/experts; applications open periodically.
Higher achievement tiers that come from normal work: Pull Shark Silver (128 merged PRs, you have about 47), Pair Extraordinaire Bronze (10 merged PRs co-authored with Claude).
Not earnable now: Heart On Your Sleeve, Open Sourcerer (in testing), Arctic Code Vault, Mars 2020.

## Security notes
Kept in local Claude memory only (`ruflo-security-check`), not in this public repo.

## Next steps
0. After 2026-10-27, re-check the profile to confirm Quickdraw and Pair Extraordinaire appeared. Pair tiers come from more real PRs co-authored with Claude in this repo (10 for Bronze). Commit attribution is enabled only in this project's `.claude/settings.json`.
   Galaxy Brain and Starstruck can't be automated legitimately: they need other people's accepted answers and stars.

For reference, how those two were done:
1. Quickdraw (run both commands within 5 minutes):
   ```bash
   gh-axi issue create -R jeffrymahbuubi/work-with-claude --title "Quickdraw" --body "closing right away"
   gh-axi issue close <NUMBER> -R jeffrymahbuubi/work-with-claude
   ```
2. Pair Extraordinaire: pair with a real collaborator and get their noreply email (`<id>+<login>@users.noreply.github.com`; the id comes from `gh api users/<login> --jq .id`). Commit with the trailer `Co-authored-by: Name <email>` on a branch, run `gh-axi pr create`, then `gh pr merge --merge`.
3. Update this file's status table after each badge appears (it can take up to 24h).

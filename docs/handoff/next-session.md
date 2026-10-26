# Next session handoff

Last updated: 2026-10-26 (end of session 1)

## Goal
Earn the GitHub profile badges that `jeffrymahbuubi` can realistically get, **legitimately**, using `gh` / `gh-axi` (and `chrome-devtools-axi` for web forms).

## Start here
1. Re-check the profile:
   ```bash
   curl -sL 'https://github.com/jeffrymahbuubi?tab=achievements' | grep -oE 'Achievement: [A-Za-z ]+' | sort -u
   curl -sL 'https://github.com/jeffrymahbuubi?tab=achievements' | grep -oE 'assets/[a-z-]+-(default|bronze|silver|gold)-' | sort -u   # tiers
   ```
2. Run the Galaxy Brain status loop (below) and reply quickly to any follow-up questions.
3. Pick the next open item from "Next steps".

## Status
| Badge | Kind | Status | Notes |
|---|---|---|---|
| Pull Shark | achievement | ✅ base tier | 49 merged PRs, but only **4 in public repos**; private contributions are off on the profile. Bronze needs 16 |
| YOLO | achievement | ✅ | |
| Quickdraw | achievement | ✅ | `work-with-claude` issue #1 |
| Public Sponsor | achievement | ✅ | Sponsoring `opencv` publicly; can cancel and keep the badge |
| Pro | highlight | ✅ | |
| Developer Program Member | highlight | ✅ | Registered 2026-10-26; website = this repo |
| Pair Extraordinaire | achievement | ⏳ waiting | PR #1 and PR #2 merged with `Co-authored-by: Claude` (resolves to the `claude` account). All requirements met; GitHub has known multi-day delays (community discussion #203416). Don't make test PRs. If it's still missing around 2026-11-02, report it in #203416 with links to the PRs |
| Galaxy Brain | achievement | ⏳ waiting | Needs 2 accepted answers. 5 eligible answers posted, 0 accepted |
| Starstruck | achievement | ⬜ | 16★ on one repo; best is `ultralytics-qat-intelligent-syringe-volume-measurement-project` (3★) |

## Galaxy Brain
**Rule:** answers in `orgs/community` **never count** (GitHub, 2024-02-06, community discussion #106536). Answers only count when the asker or a maintainer marks them.

| Discussion | Topic | Counts? |
|---|---|---|
| ruvnet/ruflo#4309 | ruflo prompt-injection report | yes |
| gotd/td#1858 | Telegram login code | yes |
| utmapp/UTM#8012 | Windows 10 VM network (e1000/rtl8139) | yes |
| remix-run/remix#12085 | npm fonts 404 with the Tailwind CLI (asker has accepted answers 3 times) | yes |
| netbirdio/netbird#8322 | macOS Installer bundle relocation (asker has accepted answers twice) | yes |
| community/community#211223, #211273 | 2FA mismatch; workflows on a fork | **no** (Community forum) |

Status loop:
```bash
for s in ruvnet/ruflo:4309 gotd/td:1858 utmapp/UTM:8012 remix-run/remix:12085 netbirdio/netbird:8322; do
  r=${s%:*}; n=${s#*:}
  gh api graphql -f o=${r%/*} -f r=${r#*/} -F n=$n -f query='query($o:String!,$r:String!,$n:Int!){repository(owner:$o,name:$r){discussion(number:$n){isAnswered answer{author{login}} comments{totalCount}}}}' \
    --jq "\"$s answered=\(.data.repository.discussion.isAnswered) by=\(.data.repository.discussion.answer.author.login // \"-\") comments=\(.data.repository.discussion.comments.totalCount)\""
done
```

**Finding more questions:**
- `./scripts/find-galaxy-brain.sh [days]` lists fresh questions with no replies in your topics.
- Better targeting: favor askers who have accepted **other people's** answers before (`author:<login> is:answered` where `answerChosenBy` = the asker and the answer's author is someone else).
- Skip 0-star repos where accounts accept each other's answers (badge farming).
- Always draft the answer, show it to the user, and post only after they approve.

## Next steps (ranked)
1. **Pull Shark Bronze, quick try:** Settings → Public profile → turn on *"Include private contributions on my profile"*. It may count the 45 private PRs (not confirmed). The sure route is real work merged through 12+ PRs in public repos.
2. **Security Advisory Credit** (highlight): a correction PR to `github/advisory-database`, made with the "Suggest improvements" form on an advisory, earns credit once merged (2022 GitHub blog). Pick a PyPI advisory for ultralytics / onnx / torch / opencv-python that's missing a patched version, fix commit or affected range, and verify it against the package's upstream tags. Takes 1–3h of work, then days to weeks of curation. The user hasn't decided whether to do this yet.
3. Wait for Pair Extraordinaire and the Galaxy Brain answers; check every 1–2 days.
4. **Starstruck:** improve the syringe-volume QAT repo's README (results, demo GIF, install steps) and share it with CV and edge-AI communities.
5. Optional security follow-up: pin the global `@claude-flow/cli` version (details in local memory `ruflo-security-check`).

## Badge audit (3 parallel agents, 2026-10-26)
- **Finishing Touch** (new, 2026-10-15): merged PRs that "improved GitHub's UI quality". Probably only for GitHub/Primer contributors.
- **Campus Expert:** applications open every July; needs more than 1 year of study left and Student Pack verification. Likely July 2027.
- **GitHub Star:** someone else has to nominate you (stars.github.com). Long term.
- **Security Bug Bounty Hunter:** valid in-scope reports to GitHub's bug bounty program (HackerOne). Low likelihood.
- **Not earnable:** Heart On Your Sleeve and Open Sourcerer (live briefly in March 2026, then pulled), Arctic Code Vault, Mars 2020, Proxima (staff only).
- Sources: Schweinepriester/github-profile-achievements, gomzyakov/github-achievements, pumpzera/github-achievements-catalog, docs.github.com.

## Decisions and rules
- Legitimate only: no sock-puppet or alt accounts (the user offered one and I declined), no star trading, no PR spam.
- `EliseyRotar/github-achievements` scripts are broken (they grep `"number":N`, but the API returns `"number": N`). Don't use them.
- All work stays inside this project folder, never `/tmp` or the scratchpad.
- Commit attribution (`Co-Authored-By: Claude`) is enabled **only** in this project's `.claude/settings.json`, as the user chose for Pair Extraordinaire.
- Security notes stay in local Claude memory, not in this public repo. Public history was rewritten on 2026-10-26 to remove them.

## Setup
- claude-flow: minimal init in this project. Memory namespace `github-badges`, key `badges-status-2026-10-26`.
- Claude auto-memory: `github-badges-progress`, `no-tmp-work-in-project`, `ruflo-security-check`.
- Project permissions (`.claude/settings.json`) allow `gh-axi` issue create/close/view/list on `jeffrymahbuubi/*`, plus `gh api users/*` and `gh api search/*`.
- `chrome-devtools-axi` attaches to the user's running Chrome with `CHROME_DEVTOOLS_AXI_AUTO_CONNECT=1`.
- Local leftovers: branch `backup/before-history-rewrite` and `refs/original/` hold the pre-rewrite history on this machine only. Delete with `git branch -D backup/before-history-rewrite && git update-ref -d refs/original/refs/heads/main`.

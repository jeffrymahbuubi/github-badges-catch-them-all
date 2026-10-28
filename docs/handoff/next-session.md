# Next session handoff

Last updated: 2026-10-29 (end of session 3)

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
| Pull Shark | achievement | ✅ base tier | 49 merged PRs, only **4 in public repos**. Private contributions turned on 2026-10-26; still base on 2026-10-29, so private PRs probably don't count. Bronze needs 16 public |
| YOLO | achievement | ✅ | |
| Quickdraw | achievement | ✅ | `work-with-claude` issue #1 |
| Public Sponsor | achievement | ✅ | Sponsoring `opencv` publicly; can cancel and keep the badge |
| Pro | highlight | ✅ | |
| Developer Program Member | highlight | ✅ | Registered 2026-10-26; website = this repo |
| Pair Extraordinaire | achievement | ⏳ waiting | PR #1 and PR #2 merged with `Co-authored-by: Claude` (resolves to the `claude` account). All requirements met; GitHub has known multi-day delays (community discussion #203416). Don't make test PRs. If it's still missing around 2026-11-02, report it in #203416 with links to the PRs |
| Galaxy Brain | achievement | ⏳ waiting | Needs 2 accepted answers. 9 eligible answers posted, 0 accepted |
| Starstruck | achievement | ⬜ | 16★ on one repo; best is `ultralytics-qat-intelligent-syringe-volume-measurement-project` (3★) |

## Galaxy Brain
**Rule:** answers in `orgs/community` **never count** (GitHub, 2024-02-06, community discussion #106536). Answers only count when the asker or a maintainer marks them.

| Discussion | Topic | Counts? |
|---|---|---|
| ruvnet/ruflo#4309 | ruflo prompt-injection report | yes |
| gotd/td#1858 | Telegram login code | yes |
| utmapp/UTM#8012 | Windows 10 VM network (e1000/rtl8139) | yes |
| remix-run/remix#12085 | npm fonts 404 with the Tailwind CLI (asker has accepted answers 3 times). 2026-10-26: asker replied with own `@font-face` workaround; we replied pointing out a missing `@` and relative URLs | yes |
| netbirdio/netbird#8322 | macOS Installer bundle relocation (asker has accepted answers twice) | yes |
| carla-simulator/carla#10123 | LiDAR/radar degradation in fog and rain (student; askers there mark answers 4/4 since Apr). Posted 2026-10-29 | yes |
| isaac-sim/IsaacLab#8575 | Custom quadruped shakes under policy; checklist citing Isaac Lab actuator docs and config (askers mark 7/7 since Apr; question was 15 days old). Posted 2026-10-29 | yes |
| sympy/sympy#30870 | Why `PartialDerivative._expand_partial_derivative()` is private; cites PR #18093, maintainer comment, source and tests (askers mark 11/11 since Apr). Posted 2026-10-29 | yes |
| colmap/colmap#4811 | Asker's unanswered follow-up on sequential-matcher loop closure: rerun mapper; set `loop_detection_min_index_distance`; `global_mapper`. Builds on xop01's earlier reply (askers chose 7/7 all-time; new asker). Posted 2026-10-29 | yes |
| community/community#211223, #211273 | 2FA mismatch; workflows on a fork | **no** (Community forum) |

Status loop:
```bash
for s in ruvnet/ruflo:4309 gotd/td:1858 utmapp/UTM:8012 remix-run/remix:12085 netbirdio/netbird:8322 carla-simulator/carla:10123 isaac-sim/IsaacLab:8575 sympy/sympy:30870 colmap/colmap:4811; do
  r=${s%:*}; n=${s#*:}
  gh api graphql -f o=${r%/*} -f r=${r#*/} -F n=$n -f query='query($o:String!,$r:String!,$n:Int!){repository(owner:$o,name:$r){discussion(number:$n){isAnswered answer{author{login}} comments{totalCount}}}}' \
    --jq "\"$s answered=\(.data.repository.discussion.isAnswered) by=\(.data.repository.discussion.answer.author.login // \"-\") comments=\(.data.repository.discussion.comments.totalCount)\""
done
```

**Finding more questions:**
- `./scripts/find-galaxy-brain.sh [days]` lists fresh questions with no replies in your topics.
- `./scripts/find-galaxy-brain.sh --stalled [days]` lists unanswered threads where the asker replied last and nobody followed up (excludes threads you're already in). Skip ones where the other party is a maintainer.
- Better targeting: favor askers who have accepted **other people's** answers before (`author:<login> is:answered` where `answerChosenBy` = the asker and the answer's author is someone else).
- Skip 0-star repos where accounts accept each other's answers (badge farming).
- Stay close to the user's profile (CV/sensing, Python/TS, LLM/agent tooling, web, Qt, Blender). Adjacent tools are fine; far-off domains (kernel, drivers, Zig/codelldb) are not.
- Always draft the answer, show it to the user, and post only after they approve.
- Preferred shape: CARLA-style questions in sim/robotics/CV repos, answered by citing the project's own docs/API/source. Prefer software/simulation config and API questions (Isaac Sim/Lab, CARLA); skip GPU/inference-engine tuning (llama.cpp, vLLM internals) and hardware-specific questions. Check every docs URL resolves to the quoted text before posting.

## Next steps (ranked)
1. **Daily check (2 min):** run the status loop, then `./scripts/find-galaxy-brain.sh 2 && ./scripts/find-galaxy-brain.sh --stalled 7`. Draft answers only for software/simulation questions that the project's own docs/source can answer; post after approval.
2. **Around 2026-11-01:** full status check of the 9 answers. **2026-11-02:** if Pair Extraordinaire is still missing, report it in community discussion #203416 with links to PR #1 and #2.
3. **Pull Shark Bronze:** private contributions didn't move the tier. The sure route is 12+ merged PRs in public repos (real fixes only, no PR spam).
4. **Security Advisory Credit** (highlight): a correction PR to `github/advisory-database`, made with the "Suggest improvements" form on an advisory, earns credit once merged (2022 GitHub blog). Pick a PyPI advisory for ultralytics / onnx / torch / opencv-python that's missing a patched version, fix commit or affected range, and verify it against the package's upstream tags. 1–3h of work, then days to weeks of curation. Not decided yet.
5. **Starstruck:** improve the syringe-volume QAT repo's README (results, demo GIF, install steps) and share it with CV and edge-AI communities.
6. Optional security follow-up: pin the global `@claude-flow/cli` version (details in local memory `ruflo-security-check`).

## Session 3 log (2026-10-29)
- Session 2 search (7d + 14d, 12 extra topics) found nothing. Skip `fulcradynamics/agent-skills` (self-promo posts with instructions aimed at AI agents).
- **2026-10-29 check:** badges unchanged (Pull Shark still base 3 days after private contributions were turned on). All 5 answers still unaccepted; only new activity is a third user (`eduridden`) calling ruflo#4309 a false alarm (not the asker, no reply needed).
- **2026-10-29 search** (5d script + 10d wider: pytorch, docker, macos, vscode, tauri, uv, pip, github actions, react native, homebrew, fastapi, hugging face, cuda): skipped Smart-AutoClicker#1120 (maintainer-only), cc-switch#8894 (maintainer already on it in issue #8895), agent-control-standard#325 (spec question, repo never accepts). Drafted an answer for **vadimcn/codelldb#1421** (Zig watch vars on Windows; Zig emits PDB for COFF, try `-gdwarf32` or `cppvsdbg`). The user chose **not to post it** (not a tool they use). A profile-based search followed: mattpocock/skills and Ultralytics questions were already answered by others; **posted carla#10123**. Then added a sim/robotics/CV repo list to the finder script; autoware#7320 drafted, not posted (user's call); **posted IsaacLab#8575**.
- **2026-10-29 follow-up check:** only replies on our threads are remix#12085 (asker's own fix; we already replied, last word is ours) and ruflo#4309 (third user agreeing). No follow-up needed. Reply only when the asker asks something new, says the fix failed, or adds logs.
- **2026-10-29 last search** (script repos + 27 LLM/ML repos, 14d, bot-only replies counted as open): only good candidate was llama.cpp#31301 (uneven GPU use with `--cpu-moe`; cause is op offload of CPU-resident experts to GPU0). Drafted, **not posted** (user's call). The user also passed on autoware#7320. Reason given: big repos about GPU/parallel compute (llama.cpp) are too far from their expertise; **software/simulation projects like Isaac Sim/Isaac Lab and CARLA** are more believable. Supply of good questions in approved areas is low: wait for the 7 answers and run `./scripts/find-galaxy-brain.sh 3` around 2026-11-01.
- **2026-10-29 software/simulation search** (37 repos: Isaac Lab/Sim, Newton, CARLA, MuJoCo, Genesis, ManiSkill, robosuite, Gazebo, Webots, Habitat, LeRobot, MetaDrive, SUMO, ML-Agents, Drake, Chrono, Open3D, PyVista…): nothing open in 30 days (bot-only replies counted as open). Relaxed to 45 days with asker-only replies: only NVlabs/curobo#725 (closed-chain kinematics costs, 6 weeks old), skipped as too specialized. These repos get a few questions a week and humans answer within a day, so check every 1–2 days with `./scripts/find-galaxy-brain.sh 2`. Newton, robosuite, Drake, Chrono, mujoco_playground, rsl_rl, esmini, BehaviorTree.CPP, PlotJuggler, viser, Mesa and NiceGUI were added to the script's repo list afterwards.
- **Omniverse/OpenUSD (2026-10-29):** OpenUSD has GitHub Discussions **off** (questions go to forum.aousd.org, which doesn't count); `usd-wg` has none. NVIDIA-Omniverse has Discussions only on PhysX, usd-exchange and usd-brep, with nothing open in 90 days. Isaac Sim questions get NVIDIA staff replies (`vick-yu`, `PeterL-NV`, `lhuang-svg`) within days; skip threads staff already handle.
- **Student-style search (2026-10-29):** FRC/FTC repos (WPILib, PhotonVision, AdvantageKit, PathPlanner, FtcRobotController, Road Runner, Pedro Pathing) were quiet (FRC off-season; most FRC Q&A is on Chief Delphi). Education/sim repos (OpenRocket, RocketPy, VPython, Manim, p5.js, pygame-ce, PyBaMM, Cantera, Astropy, SymPy…) gave one fit: **posted sympy#30870**. Re-check FTC repos during their season and FRC from January.
- **Stalled-thread search (2026-10-29):** fresh questions in scientific/ML libraries (JAX, Equinox, xarray, scikit-learn, NetworkX, PyG, Optuna, Hydra, Textual…) were all announcements. A better source: unanswered threads where the **asker replied last** and nobody followed up (jq filter: last comment/reply author == asker, others ≠ us). Skip ones where a maintainer is the other party. Found and **posted colmap#4811** this way; carla#9980 skipped (already answered well by `morvayo`).
- **`--stalled 45` run (2026-10-29):** nothing answerable. Skipped: Frigate/aube/tine (maintainer is the other party), Isaac Sim #886/#894 (NVIDIA staff), claude-code-router#1907 (asker gave up), lm-evaluation-harness#4233 (solved by `stanleys12` via `jsonschema_bench`, not marked), mlx-serve#678 (long ongoing debug with `chrishotza`), plus off-topic/show-and-tell posts. **Plan:** pause deep searches; every 1–2 days run `./scripts/find-galaxy-brain.sh 2 && ./scripts/find-galaxy-brain.sh --stalled 7` and answer within a day.

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
- claude-flow: minimal init in this project. Memory namespace `github-badges`, keys `badges-status-2026-10-26` and `badges-status-2026-10-29` (latest).
- Claude auto-memory: `github-badges-progress`, `galaxy-brain-profile-fit` (what questions the user finds believable), `prompt-open-item-workflow`, `no-tmp-work-in-project`, `ruflo-security-check`.
- Project permissions (`.claude/settings.json`) allow `gh-axi` issue create/close/view/list on `jeffrymahbuubi/*`, plus `gh api users/*` and `gh api search/*`.
- `chrome-devtools-axi` attaches to the user's running Chrome with `CHROME_DEVTOOLS_AXI_AUTO_CONNECT=1`.
- Local leftovers: branch `backup/before-history-rewrite` and `refs/original/` hold the pre-rewrite history on this machine only. Delete with `git branch -D backup/before-history-rewrite && git update-ref -d refs/original/refs/heads/main`.

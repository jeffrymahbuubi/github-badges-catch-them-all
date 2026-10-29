#!/usr/bin/env bash
# Lists recent, answerable GitHub Discussions with no replies yet, in topics you know.
# Usage: ./scripts/find-galaxy-brain.sh [--stalled] [days_back]   (default 14)
#   --stalled  instead list unanswered threads where the asker replied last and nobody
#              followed up (e.g. "that didn't work, now what?"). Skip ones where the
#              other party is a maintainer who will follow up anyway.
#   Results in repos whose CONTRIBUTING/CODE_OF_CONDUCT mentions AI get a "⚠ AI policy?" line.
# Answer the good ones yourself; Galaxy Brain counts answers the asker marks as accepted.
set -euo pipefail

STALLED=0
if [[ "${1:-}" == "--stalled" ]]; then STALLED=1; shift; fi
DAYS="${1:-14}"
SINCE=$(date -v-"${DAYS}"d +%Y-%m-%d 2>/dev/null || date -d "-${DAYS} days" +%Y-%m-%d)

QUERIES=(
  "org:ultralytics is:unanswered"
  "yolo is:unanswered"
  "onnx is:unanswered"
  "tensorrt is:unanswered"
  "quantization is:unanswered"
  "opencv is:unanswered"
  "claude code is:unanswered"
  "repo:ruvnet/ruflo is:unanswered"
)

# Simulation, robotics and CV repos where answers can cite the project's own docs/API/source
REPOS=(
  carla-simulator/carla carla-simulator/scenario_runner cyberbotics/webots
  google-deepmind/mujoco google-deepmind/mujoco_menagerie isaac-sim/IsaacLab isaac-sim/IsaacSim
  Genesis-Embodied-AI/Genesis gazebosim/gz-sim bulletphysics/bullet3 haosulab/ManiSkill
  facebookresearch/habitat-sim facebookresearch/habitat-lab huggingface/lerobot NVIDIA/warp
  metadriverse/metadrive Farama-Foundation/HighwayEnv Farama-Foundation/Gymnasium DLR-RM/stable-baselines3
  eclipse-sumo/sumo autowarefoundation/autoware autowarefoundation/autoware_universe commaai/openpilot
  ros-navigation/navigation2 moveit/moveit2 Unity-Technologies/ml-agents BeamNG/BeamNGpy
  BerkeleyAutomation/scenic ucla-mobility/OpenCOOD open-mmlab/OpenPCDet open-mmlab/mmdetection3d
  open-mmlab/mmdetection nutonomy/nuscenes-devkit waymo-research/waymax NVlabs/sionna
  isl-org/Open3D pyvista/pyvista mikedh/trimesh PointCloudLibrary/pcl colmap/colmap OpenDroneMap/ODM
  nerfstudio-project/nerfstudio nerfstudio-project/gsplat rerun-io/rerun foxglove/studio
  roboflow/supervision roboflow/inference ultralytics/ultralytics facebookresearch/sam2 facebookresearch/detectron2
  kornia/kornia pytorch/vision google-ai-edge/mediapipe openvinotoolkit/openvino NVIDIA/TensorRT microsoft/onnxruntime
  luxonis/depthai-core luxonis/depthai-python IntelRealSense/librealsense orbbec/pyorbbecsdk stereolabs/zed-sdk
  microsoft/AirSim CodexLabsLLC/Colosseum PX4/PX4-Autopilot ArduPilot/ardupilot
  mne-tools/mne-python pyqtgraph/pyqtgraph
  newton-physics/newton ARISE-Initiative/robosuite RobotLocomotion/drake projectchrono/chrono
  google-deepmind/mujoco_playground leggedrobotics/rsl_rl esmini/esmini BehaviorTree/BehaviorTree.CPP
  facontidavide/PlotJuggler nerfstudio-project/viser projectmesa/mesa zauberzeug/nicegui
)
for r in "${REPOS[@]}"; do QUERIES+=("repo:$r is:unanswered"); done

# Titles that are announcements or requests rather than questions
NOISE='Onboarding request|nomination|VOLUNTEER|open-source.*layer|faster than'

# Words that suggest a policy on AI-generated content. A hit is only a flag: open the
# file and read the rule before drafting (some repos ban AI help, some ask for disclosure).
AI_RE='AI|LLMs?|ChatGPT|Copilot|large language models?|generative|AI-generated|machine-generated'
POLICY_FILES=(AI_POLICY.md CONTRIBUTING.md .github/CONTRIBUTING.md docs/CONTRIBUTING.md
  CODE_OF_CONDUCT.md .github/CODE_OF_CONDUCT.md)
# Dedicated policy files kept elsewhere, e.g. sympy's doc/src/contributing/ai-generated-code-policy.rst
POLICY_NAME_RE='(^|/)[^/]*(ai|llm|genai)[-_][^/]*(policy|usage|guideline|contribution)[^/]*\.(md|rst|txt)$'

# Prints "file: matching line" for the first policy file that mentions AI, else nothing.
# Falls back to the owner's .github repo (org-wide community health files).
ai_policy() {
  local repo=$1 f hit
  f=$(gh api "repos/$repo/git/trees/HEAD?recursive=1" --jq '.tree[].path' 2>/dev/null \
    | grep -Ei -m1 "$POLICY_NAME_RE") || true
  if [[ -n $f ]]; then echo "$f"; return; fi
  for f in "${POLICY_FILES[@]}"; do
    hit=$(gh api -H 'Accept: application/vnd.github.raw' "repos/$repo/contents/$f" 2>/dev/null \
      | grep -Eiw -m1 "$AI_RE" | tr -s ' \t' ' ' | cut -c1-140) || true
    if [[ -n $hit ]]; then echo "$f: $hit"; return; fi
  done
  if [[ $repo != */.github ]]; then ai_policy "${repo%/*}/.github"; fi
}

# Passes result lines through and adds a warning under any repo with an AI policy hit.
flag_ai_policy() {
  local line url repo p
  declare -A seen=()
  while IFS= read -r line; do
    echo "$line"
    url=$(grep -oE 'https://github.com/[^ ]+/discussions/[0-9]+' <<<"$line") || continue
    case $url in
      https://github.com/orgs/*) repo="$(cut -d/ -f5 <<<"$url")/.github" ;;
      *) repo=$(cut -d/ -f4-5 <<<"$url") ;;
    esac
    [[ -v seen[$repo] ]] || seen[$repo]=$(ai_policy "$repo")
    p=${seen[$repo]}
    if [[ -n $p ]]; then echo "    ⚠ AI policy? $repo $p"; fi
  done
}

if (( STALLED )); then
  ME=$(gh api user --jq .login)
  for q in "${QUERIES[@]}"; do
    echo "== $q"
    gh api graphql -f q="$q created:>$SINCE" -f query='
      query($q: String!) {
        search(query: $q, type: DISCUSSION, first: 50) {
          nodes { ... on Discussion {
            title url createdAt
            author { login }
            category { isAnswerable }
            comments(last: 5) { totalCount nodes {
              author { login } createdAt
              replies(last: 1) { nodes { author { login } createdAt } }
            } }
          } }
        }
      }' | jq -r --arg me "$ME" '.data.search.nodes[]
        | select(.category.isAnswerable and .comments.totalCount > 0)
        | .author.login as $a
        | ([.comments.nodes[] | {who: .author.login, t: .createdAt},
            (.replies.nodes[] | {who: .author.login, t: .createdAt})] | sort_by(.t) | last) as $last
        | ([.comments.nodes[] | .author.login, (.replies.nodes[] | .author.login)]
            | map(select(. != $a)) | unique) as $others
        | select($last.who == $a and ($others | length) > 0 and ($others | index($me) | not))
        | "  \(.createdAt[:10]) asker-last=\($last.t[:10]) others=\($others | join(",")) \(.url) | \(.title)"' \
      | grep -vE "$NOISE|orgs/community" | flag_ai_policy || echo "  (none)"
  done
  exit 0
fi

for q in "${QUERIES[@]}"; do
  echo "== $q"
  gh api graphql -f q="$q created:>$SINCE" -f query='
    query($q: String!) {
      search(query: $q, type: DISCUSSION, first: 20) {
        nodes { ... on Discussion {
          title url createdAt
          category { isAnswerable }
          comments { totalCount }
          repository { stargazerCount }
        } }
      }
    }' --jq '.data.search.nodes[]
      | select(.category.isAnswerable and .comments.totalCount == 0)
      | "  ★\(.repository.stargazerCount) \(.createdAt[:10]) \(.url) | \(.title)"' \
    | grep -vE "$NOISE|orgs/community" | flag_ai_policy || echo "  (none)"
done

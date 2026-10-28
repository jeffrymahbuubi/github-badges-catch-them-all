#!/usr/bin/env bash
# Lists recent, answerable GitHub Discussions with no replies yet, in topics you know.
# Usage: ./scripts/find-galaxy-brain.sh [days_back]   (default 14)
# Answer the good ones yourself; Galaxy Brain counts answers the asker marks as accepted.
set -euo pipefail

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
    | grep -vE "$NOISE|orgs/community" || echo "  (none)"
done

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
    | grep -vE "$NOISE" || echo "  (none)"
done

#!/usr/bin/env bash
# End-to-end selftest driver for autopilot.
#
# Usage: scripts/selftest.sh <upstream|fork> [issue_number]
#
# upstream: dispatch agent.yml in the upstream repo, assert PR lands in upstream.
# fork:     dispatch agent.yml in the fork repo, assert PR lands in upstream
#           with head on the fork (exercises UPSTREAM_PR_TOKEN path).
#
# Requires `gh` authenticated with `workflow` scope and read access to both
# repos. Reads config from the env vars below; override as needed.

set -euo pipefail

UPSTREAM=${UPSTREAM:-yaroslav/autopilot-selftest}
FORK=${FORK:-yaroslav-fork/autopilot-selftest}
RUNNER=${RUNNER:-yaroslav}

MODE=${1:?usage: selftest.sh <upstream|fork> [issue_number]}
ISSUE=${2:-1}

case "$MODE" in
  upstream) REPO=$UPSTREAM; EXPECT_PR_IN=$UPSTREAM ;;
  fork)     REPO=$FORK;     EXPECT_PR_IN=$UPSTREAM ;;
  *) echo "bad mode: $MODE (expected upstream|fork)" >&2; exit 2 ;;
esac

echo "mode=$MODE repo=$REPO issue=$ISSUE runner=$RUNNER"

gh workflow run agent.yml -R "$REPO" \
  -f runner_label="$RUNNER" \
  -f issue_number="$ISSUE"

# dispatch is async; give GitHub a beat to register the run before querying
sleep 5
RUN_ID=$(gh run list -R "$REPO" --workflow=agent.yml -L1 --json databaseId -q '.[0].databaseId')
echo "run: https://github.com/$REPO/actions/runs/$RUN_ID"

gh run watch "$RUN_ID" -R "$REPO" --exit-status

pr_json=$(gh pr list -R "$EXPECT_PR_IN" \
  --search "issue-$ISSUE in:title" \
  --state all --limit 1 \
  --json number,headRepositoryOwner,headRefName,state)
pr_number=$(echo "$pr_json" | jq -r '.[0].number // empty')

[ -n "$pr_number" ] || { echo "assert failed: no PR for issue-$ISSUE in $EXPECT_PR_IN" >&2; exit 1; }

if [ "$MODE" = fork ]; then
  head_owner=$(echo "$pr_json" | jq -r '.[0].headRepositoryOwner.login')
  want="${FORK%%/*}"
  [ "$head_owner" = "$want" ] || {
    echo "assert failed: PR head owner is $head_owner, expected $want (fork mode should be cross-repo)" >&2
    exit 1
  }
fi

echo "ok: $MODE mode, PR #$pr_number in $EXPECT_PR_IN"

# autopilot-selftest

Selftest repo for [Clockwork-Pilot/autopilot](https://github.com/Clockwork-Pilot/autopilot). Exercises the reusable workflow end-to-end against a real GitHub repo.

## Test modes

| Mode | Repo setup | Covers |
|---|---|---|
| Same-repo | This repo alone | `issues` trigger → `run.yml` → agent → PR back to this repo |
| Fork→upstream | This repo + a fork | `create-pr` opening a PR from fork head into upstream base |

Run each mode independently — they cover disjoint code paths in `create-pr`.

## Required secrets

### Upstream selftest repo

- `RUNNERS_PAT` — PAT with `read:org` + `read:user` on the runner-owner account. Used by `issue-trigger.yml` to resolve the self-hosted runner label. Store as a **repository secret** (or org secret); `issue-trigger.yml` does not declare `environment:`, so an environment secret would not be reachable.

### Fork selftest repo (fork→upstream mode only)

- `RUNNERS_PAT` — same as above.
- `UPSTREAM_PR_TOKEN` — user / fine-grained PAT with `repo` scope on the upstream repo. Required for `create-pr` to open a PR from fork head into upstream base. Cannot be the default workflow token — that one is scoped to the repo it runs in and cannot PR cross-repo. Store as an **environment secret** on an environment named `upstream-pr`: the `open-upstream-pr` job in upstream `coding-agent.yml` declares `environment: upstream-pr`, so configuring that environment with a required reviewer gates every cross-repo PR creation. A repo/org secret resolves too but skips the gating.

### Gating PATs

Both PATs act as their creator — anyone with write access to the repo can author a workflow that exfiltrates them. Narrow them:

- Use a **fine-grained PAT**, not classic.
- Resource owner: the specific org/user; repository access: only the repos the consuming workflow queries.
- Per-token permissions:
  - `RUNNERS_PAT`: Organization *Members* — Read; Account *Profile* — Read. Nothing else.
  - `UPSTREAM_PR_TOKEN`: `repo` scope (or fine-grained Contents + Pull requests — Read & write) on the upstream repo. Nothing else.
- Expiration: 30–90 days; rotate on expiry.
- Repo Settings → Actions → General: require approval for outside-collaborator fork PRs; don't send secrets to fork workflows.
- `UPSTREAM_PR_TOKEN` is gated by the `upstream-pr` environment — configure a required reviewer there so every cross-repo PR creation pauses for approval. `RUNNERS_PAT` cannot be environment-gated (no `environment:` on `issue-trigger.yml`), so branch-protect any branch workflows run from on push.

### Self-hosted runner

Credentials consumed by the agent inside Docker (e.g. Anthropic API key) travel via `DOCKER_FILES` mounts on the runner host, **not** as repo secrets.

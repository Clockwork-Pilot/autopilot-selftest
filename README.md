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

- `RUNNERS_PAT` — PAT with `read:org` + `read:user` on the runner-owner account. Used by `issue-trigger.yml` to resolve the self-hosted runner label.

### Fork selftest repo (fork→upstream mode only)

- `RUNNERS_PAT` — same as above.
- `UPSTREAM_PR_TOKEN` — user / fine-grained PAT with `repo` scope on the upstream repo. Required for `create-pr` to open a PR from fork head into upstream base. Cannot be the default workflow token — that one is scoped to the repo it runs in and cannot PR cross-repo.

### Gating `RUNNERS_PAT`

The PAT acts as its creator. Anyone with write access to the repo can author a workflow that exfiltrates it, so narrow it:

- Use a **fine-grained PAT**, not classic.
- Resource owner: the specific org/user; repository access: only the repos `issue-trigger.yml` queries.
- Permissions: Organization *Members* — Read; Account *Profile* — Read. Nothing else.
- Expiration: 30–90 days; rotate on expiry.
- Store as an **environment secret** on an environment with yourself as a required reviewer — every run that uses it pauses for approval.
- Repo Settings → Actions → General: require approval for outside-collaborator fork PRs; don't send secrets to fork workflows.
- Branch-protect any branch workflows run from on push.

### Self-hosted runner

Credentials consumed by the agent inside Docker (e.g. Anthropic API key) travel via `DOCKER_FILES` mounts on the runner host, **not** as repo secrets.

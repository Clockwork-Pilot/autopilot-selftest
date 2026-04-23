# Specification

## Overview

Minimal spec for autopilot-selftest — exists to dogfood check_spec_constraints.py end-to-end against a real consumer repo. Keep it small; this is not where autopilot's own invariants live.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
    - [Feature: autopilot_submodule_healthy](#feature-autopilot_submodule_healthy)
      - [autopilot_constraints_pass](#autopilot_constraints_pass)
    - [Feature: selftest_shape](#feature-selftest_shape)
      - [no_local_uses_paths](#no_local_uses_paths)
      - [uses_marketplace_workflow](#uses_marketplace_workflow)

## Features

### Feature: autopilot_submodule_healthy
**Autopilot submodule is checked out and its own constraint suite passes.**

**Goals:**
- Dogfood autopilot from the consumer side: if autopilot ships broken invariants, the selftest should refuse to pass.

#### autopilot_constraints_pass
**Description:** Behavioral: autopilot's own spec constraints must pass. Runs inside the autopilot-ws docker image via the same entrypoint CI uses, so a regression in autopilot (or a broken submodule pin) fails the selftest.

### Feature: selftest_shape
**The consumer caller workflow consumes autopilot via a cross-repo uses: ref, never a local path.**

**Goals:**
- Preserve the physical boundary between implementation (autopilot) and consumer (autopilot-selftest) so the separation cannot be blurred by accident.

#### no_local_uses_paths
**Description:** Negative: no workflow in this repo may reference autopilot via a local `./` path. Only cross-repo `<owner>/autopilot/...@<ref>` is permitted. Enforces the physical boundary between consumer and implementation.

#### uses_marketplace_workflow
**Description:** Positive: every workflow file in this repo must contain at least one `uses: Clockwork-Pilot/autopilot/.github/workflows/<name>.yml@<ref>` line. Proves autopilot-selftest is actively consuming the marketplace surface, not just structurally avoiding local paths.
# Specification

## Overview

Minimal spec for autopilot-selftest — exists to dogfood check_spec_constraints.py end-to-end against a real consumer repo. Keep it small; this is not where autopilot's own invariants live.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
    - [Feature: selftest_shape](#feature-selftest_shape)
      - [agent_workflow_present](#agent_workflow_present)
      - [no_local_uses_paths](#no_local_uses_paths)
      - [uses_marketplace_workflow](#uses_marketplace_workflow)

## Features

### Feature: selftest_shape
**The consumer caller workflow consumes autopilot via a cross-repo uses: ref, never a local path.**

**Goals:**
- Preserve the physical boundary between implementation (autopilot) and consumer (autopilot-selftest) so the separation cannot be blurred by accident.

#### agent_workflow_present
**Description:** Structural: .github/workflows/agent.yml must exist — this is the consumer entry point.

#### no_local_uses_paths
**Description:** Negative: no workflow in this repo may reference autopilot via a local `./` path. Only cross-repo `<owner>/autopilot/...@<ref>` is permitted. Enforces the physical boundary between consumer and implementation.

#### uses_marketplace_workflow
**Description:** Positive: every workflow file in this repo must contain at least one `uses: Clockwork-Pilot/autopilot/.github/workflows/<name>.yml@<ref>` line. Proves autopilot-selftest is actively consuming the marketplace surface, not just structurally avoiding local paths.
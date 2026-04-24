# Specification

## Overview

Minimal spec for autopilot-selftest — exists to dogfood check_spec_constraints.py end-to-end against a real consumer repo. Keep it small; this is not where autopilot's own invariants live.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
    - [Feature: protected_files_no_host_paths](#feature-protected_files_no_host_paths)
      - [no_home_prefixed_paths](#no_home_prefixed_paths)
    - [Feature: selftest_shape](#feature-selftest_shape)
      - [no_local_uses_paths](#no_local_uses_paths)
      - [uses_marketplace_autopilot](#uses_marketplace_autopilot)

## Features

### Feature: protected_files_no_host_paths
**Root .protected_files.txt must not contain host-specific paths starting with /home.**

**Goals:**
- Keep .protected_files.txt portable across machines by forbidding absolute /home/<user>/... entries that only make sense on one contributors workstation.

#### no_home_prefixed_paths
**Description:** Negative: .protected_files.txt at project root must contain no line starting with /home. Such paths are host-specific and leak one contributors absolute layout into the repo.

### Feature: selftest_shape
**The consumer caller workflow consumes autopilot via a cross-repo uses: ref, never a local path.**

**Goals:**
- Preserve the physical boundary between implementation (autopilot) and consumer (autopilot-selftest) so the separation cannot be blurred by accident.

#### no_local_uses_paths
**Description:** Negative: no workflow in this repo may reference autopilot via a local `./` path. Only cross-repo `<owner>/autopilot/...@<ref>` is permitted. Enforces the physical boundary between consumer and implementation.

#### uses_marketplace_autopilot
**Description:** Positive: every workflow file must reference the Clockwork-Pilot/autopilot marketplace surface — either a reusable workflow (.github/workflows/<name>.yml@<ref>) or a composite action (.github/actions/<name>@<ref>). Proves active consumption of autopilot while allowing either integration shape.
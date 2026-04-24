# autopilot-selftest

## Overview

Selftest repo dogfooding autopilot via cross-repo uses: aggregates the root selftest spec and the vendored autopilot spec so both constraint suites run together.

## Specs

### autopilot
**Spec dir:** `autopilot`

**Envs:**
- `BUILD_PUSH_ACTION_VER`: `docker/build-push-action@bcafcacb16a39f128d818304e6c9c0c18556b85f` — v7.1.0
- `CHECKOUT_VER`: `actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd` — v6.0.2
- `PROJECT_ROOT`: `autopilot` — Points check_spec_constraints at the vendored autopilot/ subdirectory so its constraints resolve $PROJECT_ROOT to autopilot/, not the selftest repo root.
- `SETUP_BUILDX_ACTION_VER`: `docker/setup-buildx-action@4d04d5d9486b7bd6fa91e7baf45bbb4f8b9deedd` — v4.0.0

### selftest
**Spec dir:** `.`
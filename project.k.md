# autopilot-selftest

## Overview

Selftest repo dogfooding autopilot via cross-repo uses: aggregates the root selftest spec and the vendored autopilot spec so both constraint suites run together.

## Specs

### autopilot
**Spec dir:** `autopilot`

**Envs:**
- `PROJECT_ROOT`: `autopilot`

### selftest
**Spec dir:** `.`
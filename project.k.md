# autopilot-selftest

## Overview

Selftest repo dogfooding autopilot via cross-repo uses: aggregates the root selftest spec and the vendored autopilot spec so both constraint suites run together.

## Specs

### autopilot
**Spec dir:** `autopilot`

**Envs:**
- `CHECKOUT_VER`: `actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd`
- `PROJECT_ROOT`: `autopilot`

### selftest
**Spec dir:** `.`
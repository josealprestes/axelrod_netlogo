# Changelog

## v2.0.0 — 2026-04-24

Documentation and reproducibility upgrade.

### Added

- `CITATION.cff` for software citation metadata.
- `docs/model-explanation.md` with a conceptual explanation of the Axelrod model.
- `docs/experiments.md` with a reproducibility-oriented experiment protocol.
- `experiments/behaviorspace/README.md` with a suggested BehaviorSpace setup.
- `experiments/sample-results/schema.csv` with a proposed CSV schema for exported runs.
- `analysis/README.md` with an analysis workflow.
- `analysis/summarize_behaviorspace.py` for summarizing BehaviorSpace CSV exports.
- `analysis/requirements.txt` with minimal Python dependencies.

### Changed

- README reorganized as a more academic and didactic entry point.

### Not changed

- The canonical NetLogo model was not modified in this documentation-first v2 upgrade.
- No changes were made to the underlying Axelrod interaction rule.

## v1.0.0

Initial didactic implementation of Axelrod's cultural dissemination model in NetLogo.

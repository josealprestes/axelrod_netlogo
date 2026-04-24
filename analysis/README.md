# Analysis scaffold

This directory is reserved for analysis scripts, notebooks, and generated plots derived from NetLogo BehaviorSpace exports.

## Suggested workflow

1. Run the NetLogo model using BehaviorSpace.
2. Export raw CSV files into `experiments/sample-results/` or a separate `experiments/raw/` directory.
3. Use the analysis scripts in this directory to summarize results.
4. Save generated figures in `analysis/plots/`.

## Recommended analyses

- final cultural regions by `F` and `Q`;
- ticks until absorption by scenario;
- largest cultural-region share by scenario;
- sensitivity to random seed;
- comparison between consensus and fragmentation regimes.

## Reproducibility note

Keep raw BehaviorSpace outputs unchanged. Create derived files separately so that the analysis remains auditable.

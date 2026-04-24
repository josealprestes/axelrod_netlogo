"""Summarize BehaviorSpace exports for the Axelrod NetLogo model.

Usage:
    python analysis/summarize_behaviorspace.py experiments/sample-results/results.csv

The script expects a CSV with columns compatible with
`experiments/sample-results/schema.csv`.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import pandas as pd

GROUP_COLUMNS = ["F", "Q"]
METRIC_COLUMNS = [
    "ticks_until_absorption",
    "final_cultural_regions",
    "final_mean_region_size",
    "largest_region_size",
    "largest_region_share",
    "effective_interactions",
]


def summarize(input_csv: Path) -> pd.DataFrame:
    df = pd.read_csv(input_csv)

    available_metrics = [col for col in METRIC_COLUMNS if col in df.columns]
    missing_groups = [col for col in GROUP_COLUMNS if col not in df.columns]

    if missing_groups:
        raise ValueError(f"Missing required grouping columns: {missing_groups}")

    if not available_metrics:
        raise ValueError("No recognized metric columns found in input CSV.")

    summary = (
        df.groupby(GROUP_COLUMNS)[available_metrics]
        .agg(["count", "mean", "median", "std", "min", "max"])
        .round(4)
    )

    return summary


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_csv", type=Path, help="BehaviorSpace CSV export to summarize")
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Optional CSV path for the summarized output",
    )
    args = parser.parse_args()

    summary = summarize(args.input_csv)

    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        summary.to_csv(args.output)
        print(f"Saved summary to {args.output}")
    else:
        print(summary)


if __name__ == "__main__":
    main()

# Model explanation

This document explains the conceptual structure of the NetLogo implementation of Axelrod's cultural dissemination model.

## 1. Conceptual background

Axelrod's model studies how local interaction can produce either cultural convergence or persistent cultural diversity.

The model is based on two mechanisms:

1. **Homophily:** agents are more likely to interact when they are already similar.
2. **Social influence:** when similar agents interact, one may become more similar to the other.

The paradox explored by the model is that mechanisms that appear to promote convergence can also produce stable fragmentation, depending on the distribution of cultural traits and the local interaction structure.

## 2. Agents and culture

Each agent occupies one patch in a two-dimensional grid. Each agent has a cultural vector:

```text
features = [f1, f2, ..., fF]
```

Each component `fi` is a cultural feature and can assume one of `Q` possible traits:

```text
fi ∈ {0, 1, ..., Q - 1}
```

Thus:

- `F` controls the number of cultural dimensions.
- `Q` controls the number of possible traits per dimension.

## 3. Similarity

For two neighboring agents `a` and `b`, similarity is computed as the proportion of identical positions in their cultural vectors:

```text
similarity(a, b) = overlap(a, b) / F
```

where `overlap(a, b)` is the number of features for which both agents have the same trait.

## 4. Interaction rule

The textbook rule is:

1. select a focal agent;
2. select one of its von Neumann neighbors;
3. compute similarity;
4. interact with probability equal to similarity;
5. if interaction occurs and the agents are not identical, copy one differing trait from the neighbor.

This rule links cultural similarity to probability of influence.

## 5. Absorbing state

The system reaches an absorbing state when no neighboring pair has partial similarity.

In operational terms, the simulation stops when there are no neighboring pairs such that:

```text
0 < overlap < F
```

At that point, each neighboring pair is either completely identical or completely different. No further influence is possible under the model's canonical rule.

## 6. Expected qualitative behavior

The model may converge to:

- **global consensus**, when one cultural region dominates the grid;
- **local cultural regions**, when multiple internally homogeneous regions persist;
- **fragmented mosaics**, when a high number of regions remains after absorption.

In general:

- increasing `Q` tends to reduce initial similarity and increase fragmentation;
- increasing `F` may create more opportunities for partial similarity and can reduce fragmentation;
- larger worlds increase the range of possible spatial patterns and execution time.

## 7. Interpretation

The model should not be interpreted as a literal description of cultural life. It is a minimal computational abstraction for studying how local interaction rules can generate emergent macroscopic patterns.

Its main pedagogical value lies in making visible the relationship between:

- local rules;
- stochastic interaction;
- spatial structure;
- emergence;
- consensus and fragmentation.

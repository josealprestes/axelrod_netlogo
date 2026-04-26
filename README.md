# Axelrod – Disseminação Cultural em NetLogo

> [!CAUTION]
> **PROJETO CONGELADO:** Este repositório encontra-se em estado de manutenção/congelamento. Não há planos para novas implementações no curto prazo, servindo como base estável para estudos e referências futuras.

Implementação didática, em NetLogo, do modelo de **disseminação cultural de Axelrod (1997)**, conforme o capítulo *“Disseminating Culture”* de *The Complexity of Cooperation*.

O objetivo deste repositório é oferecer uma versão simples, inspecionável e pedagogicamente útil do modelo, preservando as hipóteses centrais do modo “textbook”: vizinhança de von Neumann, malha sem tórus, um agente por patch e probabilidade de interação proporcional à similaridade cultural.

## Status do Projeto

A versão atual (**v2**) transforma o repositório em um pacote didático-reprodutível. A implementação é **estável e fiel** ao modelo original.
- **Core:** Mecânica de homofilia e influência social via vetor cultural totalmente funcional.
- **Métricas:** Cálculo de clusters via BFS operacional, permitindo observar a convergência para estados absorvidos.
- **Interface:** Controles de F, Q e probabilidade de interação integrados e responsivos.

### Estrutura do Repositório

```text
.
├── README.md
├── CITATION.cff
├── CHANGELOG.md
├── docs/
│   ├── model-explanation.md
│   ├── experiments.md
│   └── v2-model-extension-checklist.md
├── experiments/
│   ├── behaviorspace/
│   │   └── README.md
│   └── sample-results/
│       └── schema.csv
└── analysis/
    ├── README.md
    ├── requirements.txt
    └── summarize_behaviorspace.py
```

## Ideia Central

O modelo representa agentes distribuídos em uma grade. Cada agente possui um vetor cultural composto por **F características**; cada característica pode assumir um entre **Q traços** possíveis.

A dinâmica é baseada em homofilia e influência social:
1. Agentes vizinhos são comparados;
2. Quanto maior a similaridade entre eles, maior a chance de interação;
3. Quando interagem, um agente copia um traço cultural diferente do vizinho;
4. O sistema evolui até atingir um estado absorvido (consenso ou fragmentação).

## Hipóteses Implementadas

- **Topologia:** grade bidimensional com bordas, sem wrap/tórus.
- **Vizinhança:** von Neumann (4 vizinhos).
- **Ocupação:** um agente por patch.
- **Cultura:** vetor `features = [f1, ..., fF]`, com `fi ∈ {0, ..., Q-1}`.
- **Similaridade:** proporção de posições idênticas entre dois vetores.
- **Interação:** probabilidade igual à similaridade.
- **Parada:** sistema atinge estado absorvido quando não há mais pares com `0 < overlap < F`.

## Como Rodar

1. Instale o **NetLogo 6.x**.
2. Abra o arquivo `axelrod_cultural_diffusion_model.nlogo`.
3. Nas configurações do mundo, use uma malha **61 × 61** e desligue o tórus.
4. Configure os parâmetros sugeridos: `F = 5`, `Q = 15`.
5. Clique em `setup` e depois em `go`.
6. (Opcional) Use `go-fast` para aceleração visual.

## Métricas e Observação

- **Regiões Culturais:** Identificadas via BFS (vizinhança 4) para agentes idênticos.
- **`count-cultural-regions`**: Número de clusters distintos.
- **`mean-region-size`**: Tamanho médio dos clusters.
- **Dica:** Aumentar `Q` eleva a fragmentação; aumentar `F` tende a reduzi-la.

## Experimentos e Análise

A v2 inclui suporte para **BehaviorSpace**:
- Guia de experimentos em `docs/experiments.md`.
- Scripts de análise em `analysis/` (requer Python e as dependências em `requirements.txt`).

Para rodar o sumário de análise:
```bash
python analysis/summarize_behaviorspace.py experiments/sample-results/results.csv
```

## Roadmap & Próximos Passos

Apesar de estável, o modelo pode ser expandido com as seguintes melhorias planejadas:

1.  **Mutação e Inovação:** Introduzir ruído cultural (probabilidade baixa de mudança aleatória) para evitar estados absorvidos estáticos.
2.  **Vizinhança de Moore:** Opção para alternar entre 4 e 8 vizinhos.
3.  **Barreiras Espaciais:** Implementar patches de "muro" que bloqueiam a interação.
4.  **Redes Sociais:** Evoluir para topologias Small World ou Scale-Free.
5.  **Análise de Sensibilidade:** Automatizar varreduras sistemáticas de `F` e `Q` via BehaviorSpace.

Consulte `docs/v2-model-extension-checklist.md` para detalhes técnicos de implementação.

## Solução de Problemas

- **Aviso de Tórus:** Desligue o wrap nas configurações do mundo.
- **Performance:** Aumente o `draw-every` ou use `go-fast`.
- **Plots Vazios:** Garanta que os nomes nos plots coincidem com os reporters (`count-cultural-regions`).

## Referências e Citação

- **Axelrod, R. (1997).** *The Complexity of Cooperation*. Princeton University Press.
- Para citar este software, consulte o arquivo `CITATION.cff`.

## Licença

Este projeto está sob a licença **MIT**. Veja `LICENSE` para detalhes.

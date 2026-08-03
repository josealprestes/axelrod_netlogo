# Axelrod: Disseminação Cultural em NetLogo

[![License: MIT](https://img.shields.io/badge/Licen%C3%A7a-MIT-blue.svg)](LICENSE)

> [!CAUTION]
> **Status do Projeto: CONGELADO**
> Este repositório encontra-se em estado de manutenção/congelamento. Não há planos para novas implementações no curto prazo, servindo como base estável para estudos e referências futuras.

## Sobre

Implementação didática, em NetLogo, do modelo de **disseminação cultural de Axelrod (1997)**, conforme o capítulo *"Disseminating Culture"* de *The Complexity of Cooperation*.

O objetivo deste repositório é oferecer uma versão simples, inspecionável e pedagogicamente útil do modelo, preservando as hipóteses centrais do modo "textbook": vizinhança de von Neumann, malha sem tórus, um agente por patch e probabilidade de interação proporcional à similaridade cultural.

O modelo representa agentes distribuídos em uma grade. Cada agente possui um vetor cultural composto por **F características**; cada característica pode assumir um entre **Q traços** possíveis. A dinâmica é baseada em homofilia e influência social:

1. Agentes vizinhos são comparados;
2. Quanto maior a similaridade entre eles, maior a chance de interação;
3. Quando interagem, um agente copia um traço cultural diferente do vizinho;
4. O sistema evolui até atingir um estado absorvido (consenso ou fragmentação).

## Contexto Acadêmico

Projeto desenvolvido no âmbito da disciplina **IA006 - Tópicos em Sistemas Inteligentes II**, oferecida pelo Programa de Pós-Graduação em Engenharia Elétrica da **Faculdade de Engenharia Elétrica e de Computação (FEEC) da Unicamp**, no **segundo semestre de 2025 (2S/2025)**, cursada como **estudante especial**.

Docentes responsáveis: **Prof. Gilmar Barreto** e **Prof. Bruno Sanches Masiero** (Turma G, quartas-feiras 14h-18h).

Ementa oficial (DAC/Unicamp, 2S/2025):

> "Esta disciplina tem como objetivo aprofundar o conhecimento em sistemas inteligentes, explorando tópicos avançados e recentes na área."
> Bibliografia: definida no semestre do oferecimento.

O modelo foi desenvolvido a partir das **leituras da disciplina**, em especial o capítulo *"Disseminating Culture"* de *The Complexity of Cooperation*, de Robert Axelrod, e das discussões havidas em sala de aula sobre simulação social baseada em agentes.

O projeto conecta também uma trajetória profissional multidisciplinar de mais de 25 anos, que integra **Direito, Tecnologia e Gestão**, com a pesquisa acadêmica em sistemas inteligentes, simulação social baseada em agentes e ciência da complexidade.

## Status da Implementação

A versão atual (**v2**) transforma o repositório em um pacote didático-reprodutível. A implementação é **estável e fiel** ao modelo original.

- **Core**: mecânica de homofilia e influência social via vetor cultural totalmente funcional.
- **Métricas**: cálculo de clusters via BFS operacional, permitindo observar a convergência para estados absorvidos.
- **Interface**: controles de F, Q e probabilidade de interação integrados e responsivos.

## Hipóteses Implementadas

- **Topologia**: grade bidimensional com bordas, sem wrap/tórus.
- **Vizinhança**: von Neumann (4 vizinhos).
- **Ocupação**: um agente por patch.
- **Cultura**: vetor `features = [f1, ..., fF]`, com `fi ∈ {0, ..., Q-1}`.
- **Similaridade**: proporção de posições idênticas entre dois vetores.
- **Interação**: probabilidade igual à similaridade.
- **Parada**: sistema atinge estado absorvido quando não há mais pares com `0 < overlap < F`.

## Interface (widgets)

| Widget | Nome | Função |
|--------|------|--------|
| Slider | `F` | Número de características culturais por agente |
| Slider | `Q` | Número de traços possíveis por característica |
| Slider | `interaction-prob` | Probabilidade de interação entre vizinhos |
| Botão | `setup` | Inicializa o ambiente e os agentes |
| Botão | `go` | Executa a simulação em loop |
| Botão | `go-fast` | Acelera a simulação (sem redraw completo) |
| Monitor | `# Regiões culturais` | Número de clusters distintos (BFS) |
| Monitor | `Tamanho médio` | Tamanho médio dos clusters |
| Monitor | `ticks` | Passos de simulação decorridos |
| Plot | `# Regiões` | Evolução do número de regiões culturais |
| Plot | `Tamanho médio das regiões` | Evolução do tamanho médio dos clusters |

## Como Rodar

### Pré-requisitos

- **NetLogo 6.4.0** (ou versão 6.x compatível)
- **Python 3.8+** (apenas para os scripts de análise em `analysis/`)
- Sistema operacional com suporte ao NetLogo (Windows, macOS, Linux)

### Passo a passo

1. Instale o **NetLogo 6.4.0** (ou versão 6.x compatível).
2. Abra o arquivo `axelrod_cultural_diffusion_model.nlogo`.
3. Nas configurações do mundo, use uma malha **61 × 61** e desligue o tórus.
4. Configure os parâmetros sugeridos: `F = 5`, `Q = 15`.
5. Clique em `setup` e depois em `go`.
6. (Opcional) Use `go-fast` para aceleração visual.

### Métricas e Observação

- **Regiões Culturais**: identificadas via BFS (vizinhança 4) para agentes idênticos.
- **`count-cultural-regions`**: número de clusters distintos.
- **`mean-region-size`**: tamanho médio dos clusters.
- **Dica**: aumentar `Q` eleva a fragmentação; aumentar `F` tende a reduzi-la.

## Experimentos e Análise

A v2 inclui suporte para **BehaviorSpace**:

- Guia de experimentos em `docs/experiments.md`.
- Scripts de análise em `analysis/` (requer Python e as dependências em `requirements.txt`).

Para rodar o sumário de análise:

```bash
python analysis/summarize_behaviorspace.py experiments/sample-results/results.csv
```

## Estrutura do Repositório

```text
.
├── README.md                          # Este documento
├── CITATION.cff                       # Metadados de citação do software
├── CHANGELOG.md                       # Histórico de versões
├── LICENSE                            # Licença MIT
├── axelrod_cultural_diffusion_model.nlogo  # Modelo NetLogo (arquivo principal)
├── docs/
│   ├── model-explanation.md           # Explicação conceitual do modelo
│   ├── experiments.md                 # Protocolo de experimentos reprodutíveis
│   └── v2-model-extension-checklist.md # Checklist técnico de extensões
├── experiments/
│   ├── behaviorspace/                 # Setup sugerido de BehaviorSpace
│   └── sample-results/                # Schema CSV para exportação
└── analysis/
    ├── README.md                      # Workflow de análise
    ├── requirements.txt               # Dependências Python mínimas
    └── summarize_behaviorspace.py     # Sumarizador de exportações BehaviorSpace
```

## Roadmap & Próximos Passos

Apesar de estável, o modelo pode ser expandido com as seguintes melhorias planejadas:

1. **Mutação e Inovação**: introduzir ruído cultural (probabilidade baixa de mudança aleatória) para evitar estados absorvidos estáticos.
2. **Vizinhança de Moore**: opção para alternar entre 4 e 8 vizinhos.
3. **Barreiras Espaciais**: implementar patches de "muro" que bloqueiam a interação.
4. **Redes Sociais**: evoluir para topologias Small World ou Scale-Free.
5. **Análise de Sensibilidade**: automatizar varreduras sistemáticas de `F` e `Q` via BehaviorSpace.

Consulte `docs/v2-model-extension-checklist.md` para detalhes técnicos de implementação.

## Solução de Problemas

- **Aviso de Tórus**: desligue o wrap nas configurações do mundo.
- **Performance**: aumente o `draw-every` ou use `go-fast`.
- **Plots Vazios**: garanta que os nomes nos plots coincidem com os reporters (`count-cultural-regions`).

## FAQ

**Qual versão do NetLogo é necessária?**
NetLogo 6.4.0 ou qualquer versão 6.x compatível.

**Qual o tamanho de malha recomendado?**
61 × 61, com tórus desligado (sem wrap).

**Quais parâmetros usar para a primeira execução?**
`F = 5`, `Q = 15`, `interaction-prob` no valor padrão do modelo.

**O que os monitores mostram?**
O número de regiões culturais (clusters BFS) e o tamanho médio dos clusters, permitindo observar a convergência para estados absorvidos.

**Como faço para rodar experimentos em lote?**
Use o BehaviorSpace do NetLogo seguindo `docs/experiments.md`, exporte os resultados em CSV e processe com `analysis/summarize_behaviorspace.py`.

**O projeto está ativo?**
Não. O repositório está congelado e serve como base estável para estudos e referências.

**Posso contribuir?**
Sim. Faça um fork, implemente as melhorias do roadmap e abra um pull request.

## Referências e Citação

- **Axelrod, R. (1997).** *The Complexity of Cooperation*. Princeton University Press.
- Para citar este software, consulte o arquivo [CITATION.cff](CITATION.cff).

## Licença

MIT © 2025 José Augusto de Lima Prestes. Veja o arquivo [LICENSE](LICENSE).

## Links

- **Site:** [joseprestes.com](https://joseprestes.com)
- **ORCID:** [0000-0001-8686-5360](https://orcid.org/0000-0001-8686-5360)

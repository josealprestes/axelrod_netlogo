# Axelrod – Disseminação Cultural em NetLogo

Implementação didática, em NetLogo, do modelo de **disseminação cultural de Axelrod (1997)**, conforme o capítulo *“Disseminating Culture”* de *The Complexity of Cooperation*.

O objetivo deste repositório é oferecer uma versão simples, inspecionável e pedagogicamente útil do modelo, preservando as hipóteses centrais do modo “textbook”: vizinhança de von Neumann, malha sem tórus, um agente por patch e probabilidade de interação proporcional à similaridade cultural.

## Ideia central

O modelo representa agentes distribuídos em uma grade. Cada agente possui um vetor cultural composto por **F características**; cada característica pode assumir um entre **Q traços** possíveis.

A dinâmica é baseada em homofilia e influência social:

1. agentes vizinhos são comparados;
2. quanto maior a similaridade entre eles, maior a chance de interação;
3. quando interagem, um agente copia um traço cultural diferente do vizinho;
4. o sistema evolui até atingir um estado absorvido.

O resultado pode ser consenso cultural ou fragmentação em múltiplas regiões culturais.

## Hipóteses implementadas

- **Topologia:** grade bidimensional com bordas, sem wrap/tórus.
- **Vizinhança:** von Neumann, com até quatro vizinhos por agente.
- **Ocupação:** um agente por patch.
- **Cultura:** vetor `features = [f1, ..., fF]`, com `fi ∈ {0, ..., Q-1}`.
- **Similaridade:** proporção de posições idênticas entre dois vetores culturais.
- **Interação:** probabilidade de interação igual à similaridade.
- **Atualização:** quando há interação, um traço divergente é copiado do vizinho.
- **Parada:** o sistema para quando não há pares vizinhos com similaridade parcial, isto é, quando não existem pares com `0 < overlap < F`.

## Como rodar

1. Instale o **NetLogo 6.x**.
2. Abra o arquivo `.nlogo` deste repositório.
3. Nas configurações do mundo, use uma malha aproximadamente **61 × 61** e desligue o tórus.
4. Configure os parâmetros iniciais sugeridos:
   - `F = 5`
   - `Q = 15`
   - `interaction-prob = 1.0`, usado como fator informativo/travado para preservar a regra original.
5. Clique em `setup`.
6. Clique em `go` e observe a evolução do sistema.

## O que observar

As principais saídas do modelo são:

- número de regiões culturais;
- tamanho médio das regiões culturais;
- estabilização do sistema em estado absorvido;
- diferença entre consenso e fragmentação conforme os valores de `F` e `Q`.

Como regra geral:

- aumentar `Q` tende a elevar a fragmentação cultural;
- aumentar `F` tende a ampliar as oportunidades de similaridade parcial e pode reduzir a fragmentação;
- mundos maiores demandam mais tempo de execução e podem exigir menor frequência de redesenho e recomputação de métricas.

## Métricas

As regiões culturais são tratadas como componentes conexos, usando vizinhança 4, formados por agentes com vetores culturais idênticos.

As principais métricas implementadas são:

- `count-cultural-regions`: número de regiões culturais distintas;
- `mean-region-size`: tamanho médio das regiões culturais;
- plots temporais para acompanhar a evolução dessas métricas.

A identificação das regiões utiliza busca em largura (BFS) para rotular componentes conectados.

## Uso didático

Este repositório pode ser usado para:

- introduzir modelos baseados em agentes;
- discutir homofilia, influência social e emergência de padrões coletivos;
- demonstrar a diferença entre regras locais simples e comportamento global complexo;
- comparar consenso e fragmentação em sistemas sociais simulados;
- apoiar aulas, experimentos introdutórios e discussões sobre complexidade social.

## Limitações

Esta implementação foi deliberadamente mantida simples para fins pedagógicos. Ela não pretende introduzir extensões sociológicas, ruído, mobilidade, redes complexas, aprendizado, heterogeneidade institucional ou mecanismos normativos adicionais.

Possíveis extensões futuras incluem:

- topologias alternativas;
- redes sociais não regulares;
- ruído ou mutação cultural;
- agentes com pesos ou influência assimétrica;
- comparação sistemática entre regimes de `F`, `Q` e tamanho do mundo;
- exportação automática de resultados para análise estatística externa.

## Solução de problemas

- Se aparecer aviso sobre tórus, desligue o wrap nas configurações do mundo.
- Se os plots não forem atualizados, verifique se os nomes dos monitores e plots coincidem com os usados no código.
- Se a execução estiver lenta, aumente os intervalos de redesenho e recomputação de métricas ou reduza o tamanho do mundo.
- Se o modelo estabilizar rapidamente, teste valores maiores de `Q` ou um mundo maior.

## Referência

Axelrod, R. (1997). *The Complexity of Cooperation: Agent-Based Models of Competition and Collaboration*. Princeton University Press.

Capítulo de referência: *“Disseminating Culture”*.

## Licença

Este projeto está disponível sob a licença MIT. Consulte o arquivo `LICENSE`.

## Contribuições

Contribuições são bem-vindas, especialmente melhorias didáticas, comentários no código, exemplos de cenários e extensões documentadas do modelo original.

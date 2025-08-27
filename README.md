# Axelrod – Difusão Cultural (NetLogo)

> Implementação didática do modelo de **disseminação cultural** de **Axelrod (1997)** em NetLogo — aderente ao capítulo *“Disseminating Culture”* do livro *The Complexity of Cooperation*.  
> **Textbook mode:** vizinhança de von Neumann (4), **sem tórus**, 1 agente por patch, probabilidade de interação = similaridade.

---

## Guia “for dummies”

**Idéia em 3 linhas**

- Cada pessoa tem um “cartão” com **F características**.  
- Cada característica pode assumir **Q** valores (traços).  
- Quanto mais dois vizinhos **se parecem**, **maior** a chance de um **copiar** um traço do outro → pode dar **consenso** ou **mosaicos** de culturas.

**Como rodar rapidinho**

1. Abra o arquivo `.nlogo` do repositório (ex.: `axelrod_netlogo.nlogo`) no **NetLogo 6.x**.  
2. Em **Configuração…** (Model Settings), use um mundo ~**61×61** e **desligue o tórus** (sem wrap).  
3. Sliders: **F = 5**, **Q = 15** (a probabilidade extra de interação é fixada em **1.0** no `setup`).  
4. Clique **setup** → **go**.  
   - (Opcional) Use **go-fast** se existir na interface para acelerar.

**O que observar**

- **# Regiões culturais** (clusters)
- **Tamanho médio** das regiões

> Regras de bolso: **↑Q** → mais fragmentação (↑ nº de regiões). **↑F** → tende a reduzir o nº de regiões.

---

## Descrição técnica

- Agente com vetor cultural `features = [f1, …, fF]`, `fi ∈ {0,…,Q−1}`.  
- **Similaridade** entre vizinhos `a` e `b`: `similaridade = overlap / F` (onde `overlap` = nº de posições idênticas).  
- **Regra de interação (Axelrod, 1997):**
  - Com probabilidade = similaridade, escolhe-se **1** índice onde diferem e **copia-se** o traço do vizinho.  
- **Parada (estado absorvido):** não existem pares vizinhos com `0 < overlap < F`.

**Aderência ao “textbook”**

- **F** = nº de características; **q** (aqui **Q**) = nº de traços por característica.  
- **Probabilidade de interação = similaridade** (o slider `interaction-prob` é travado em **1.0** no `setup`).  
- **Topologia:** malha com bordas (**sem tórus**). Interiores têm 4 vizinhos; bordas 3; cantos 2.

---

## Controles da interface

| Tipo      | Nome (interface)                 | Função                                                                 |
|-----------|----------------------------------|-------------------------------------------------------------------------|
| Slider    | **F**                            | Nº de características (features)                                       |
| Slider    | **Q**                            | Nº de traços por característica                                        |
| Slider    | **interaction-prob**             | Informativo; fica **1.0** no `setup` para aderir ao livro              |
| Botão     | **setup**                        | Inicializa (1 agente por patch, vetores aleatórios, checa tórus OFF)   |
| Botão     | **go**                           | Executa 1 interação por tick                                           |
| Botão (*) | **go-fast**                      | Executa várias interações por tick visual (ex.: 50) para acelerar      |
| Monitor   | `count-cultural-regions`         | Nº de regiões (clusters)                                               |
| Monitor   | `mean-region-size`               | Tamanho médio das regiões                                              |
| Plot      | **# Regiões**                    | Série temporal de `count-cultural-regions`                             |
| Plot      | **Tamanho médio das regiões**    | Série temporal de `mean-region-size`                                   |

(*) Se você incluiu o botão extra de aceleração no modelo.

**Dica de performance:** o código usa `draw-every` e `metrics-every` (intervalos de redesenho e de recomputar clusters). Aumente esses valores para rodar mais rápido em mundos grandes.

---

## Passo-a-passo “textbook”

1. **Mundo:** ~**61×61**, **tórus DESLIGADO** (desmarcar “Mundo sem limites” nas direções horizontal e vertical).  
2. **Sliders:** `F = 5`, `Q = 15`.  
3. **setup** → **go** até parar (estado absorvido).  
4. Observe a estabilização do **nº de regiões** e do **tamanho médio**.

---

## Métricas implementadas

- **Regiões culturais** = componentes conexos (vizinhança 4) de agentes **com vetores idênticos**.  
  Implementação via **BFS** rotulando `region-id`.  
- **`count-cultural-regions`**: número de rótulos distintos.  
- **`mean-region-size`**: média do tamanho dos clusters.

As métricas/plots são atualizados periodicamente (não a cada tick) para manter o desempenho.

---

## Solução de problemas

- **Aviso de tórus** no `setup`: desligue o wrap em **Configuração…**.  
- **Plots não atualizam / erro de nome**: confirme que os plots se chamam exatamente **`# Regiões`** e **`Tamanho médio das regiões`**.  
- **Execução lenta**:  
  - Aumente `draw-every` / `metrics-every`;  
  - Use **go-fast**;  
  - Diminua o tamanho do mundo;  
  - Reduza **F** e/ou **Q**.

---

## Referência

- **Axelrod, R. (1997).** *The Complexity of Cooperation: Agent-Based Models of Competition and Collaboration*. Princeton University Press. Capítulo *“Disseminating Culture”*.  
  > Notação do livro: **F** (nº de características) e **q** (aqui **Q**) = nº de traços por característica.

---

## Licença

Este projeto está sob **MIT License** (ver `LICENSE`).

---

## Contribuindo

1. Faça um **fork**.  
2. Crie uma **branch** (`feat/minha-ideia`).  
3. Commit com mensagens claras.  
4. Abra um **Pull Request** explicando motivação e mudanças.

---

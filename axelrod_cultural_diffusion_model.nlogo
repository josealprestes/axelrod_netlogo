; =============================================================
;  MODELO DE DIFUSÃO CULTURAL (Axelrod, 1997) — NetLogo
;  Versão didática em PT-BR, aderente ao livro (cap. “Disseminating Culture”)
; =============================================================

breed [ people person ]

globals [
  num-features            ; F
  num-traits              ; Q
  step-count

  ;; performance / cache
  draw-every              ; desenhar a cada N ticks
  metrics-every           ; calcular métricas a cada N ticks
  g-num-regions           ; # de regiões (cache)
  g-mean-size             ; tamanho médio (cache)
]

people-own [
  features
  region-id
]

; --------------------------
; SETUP
; --------------------------
to setup
  clear-all

  ;; guardas “textbook”: borda ativa (sem tórus) e prob = 1.0
  if [count neighbors4] of patch min-pxcor min-pycor = 4 [
    user-message "Axelrod (texto): desligue o tórus em Configuração… (sem wrap)."
    stop
  ]
  set interaction-prob 1.0   ;; se não houver slider, declare em globals

  set step-count 0
  set num-features F
  set num-traits Q

  ;; parâmetros de desempenho
  set draw-every    10
  set metrics-every 20

  ask patches [ sprout-people 1 [ init-person ] ]
  recolor
  set g-num-regions 0
  set g-mean-size 0
  clear-all-plots
  reset-ticks
end

to init-person
  set size 1
  set features n-values num-features [ random num-traits ]
  set color feature-color features
end

; --------------------------
; GO (1 interação por tick)
; --------------------------
to go
  if not any-interactions-possible? [
    update-metrics
    plot-metrics
    stop
  ]
  set step-count step-count + 1

  let a one-of people
  let n one-of neighbors4-with-people a
  if n != nobody [ interact a n ]

  if ticks mod draw-every    = 0 [ recolor ]
  if ticks mod metrics-every = 0 [
    update-metrics
    plot-metrics
  ]
  tick
end

; --------------------------
; GO-FAST (50 interações por tick visual) — OPCIONAL
; --------------------------
to go-fast
  if not any-interactions-possible? [
    update-metrics
    plot-metrics
    stop
  ]
  repeat 50 [
    let a one-of people
    let n one-of neighbors4-with-people a
    if n != nobody [ interact a n ]
    set step-count step-count + 1
  ]
  if ticks mod draw-every    = 0 [ recolor ]
  if ticks mod metrics-every = 0 [
    update-metrics
    plot-metrics
  ]
  tick
end

; --------------------------
; INTERAÇÃO (Axelrod)
; --------------------------
to interact [ a b ]
  if random-float 1 > interaction-prob [ stop ]  ;; para “texto”, já está 1.0

  let same?   map [ i -> item i [features] of a = item i [features] of b ] (range num-features)
  let overlap length filter [ x -> x ] same?
  if overlap = num-features [ stop ]  ;; idênticos

  if random-float 1 < (overlap / num-features) [
    let diff-indices filter
      [ i -> item i [features] of a != item i [features] of b ]
      (range num-features)
    if not empty? diff-indices [
      let k item (random length diff-indices) diff-indices
      ask a [
        set features replace-item k features (item k [features] of b)
        set color feature-color features
      ]
    ]
  ]
end

; --------------------------
; Vizinhança & cor
; --------------------------
to-report neighbors4-with-people [ a ]
  report people-on ( [neighbors4] of ([patch-here] of a) )
end

to-report feature-color [ fvec ]
  let r 0 let g 0 let b 0 let i 0
  foreach fvec [ tv ->
    set r (r + (tv * (i + 3)))
    set g (g + ((tv + 2) * (i + 5)))
    set b (b + ((tv + 4) * (i + 7)))
    set i i + 1
  ]
  report rgb ((r mod 140) + 40) ((g mod 140) + 40) ((b mod 140) + 40)
end

; --------------------------
; Parada exata (textbook)
; --------------------------
to-report any-interactions-possible?
  report any? people with [
    any? (neighbors4-with-people self) with [ potential-interaction? self myself ]
  ]
end

to-report potential-interaction? [ x y ]
  let fv-x [features] of x
  let fv-y [features] of y
  let overlap 0
  (foreach fv-x fv-y [ [ax bx] -> if ax = bx [ set overlap overlap + 1 ] ])
  report (overlap > 0) and (overlap < num-features)
end

to recolor
  ask people [ set color feature-color features ]
end

; --------------------------
; Métricas: atualizar só às vezes (rápido)
; --------------------------
to update-metrics
  if count people = 0 [
    set g-num-regions 0
    set g-mean-size 0
    stop
  ]
  count-and-label-regions
  set g-num-regions 1 + max [region-id] of people

  let maxid max [region-id] of people
  let sizes []
  let ids n-values (maxid + 1) [ i -> i ]
  foreach ids [ rid ->
    set sizes lput count people with [ region-id = rid ] sizes
  ]
  set g-mean-size mean sizes
end

to plot-metrics
  set-current-plot "# Regiões"
  set-current-plot-pen "clusters"
  plot g-num-regions

  set-current-plot "Tamanho médio das regiões"
  set-current-plot-pen "mean-size"
  plot g-mean-size
end

; --------------------------
; Rotulagem por BFS
; --------------------------
to count-and-label-regions
  ask people [ set region-id -1 ]
  let current 0
  let unvisited people with [ region-id = -1 ]
  while [ any? unvisited ] [
    let seed one-of unvisited
    let fv [features] of seed
    let cluster bfs-identical seed fv
    ask cluster [ set region-id current ]
    set current current + 1
    set unvisited people with [ region-id = -1 ]
  ]
end

to-report bfs-identical [ start fv ]
  let queue (list start)
  let visited (list start)
  while [ not empty? queue ] [
    let x first queue
    set queue but-first queue

    let nbr people-on ( [neighbors4] of ([patch-here] of x) )
    let nbr-same nbr with [ features = fv ]

    let new filter [ t -> not member? t visited ] sort nbr-same
    set queue   sentence queue new
    set visited sentence visited new
  ]
  report turtle-set visited
end

; --------------------------
; Reporters compatíveis com os monitores (leem o cache)
; --------------------------
to-report count-cultural-regions
  report g-num-regions
end

to-report mean-region-size
  report g-mean-size
end
@#$#@#$#@
GRAPHICS-WINDOW
292
57
983
749
-1
-1
11.2
1
10
1
1
1
0
0
0
1
-30
30
-30
30
1
1
1
ticks
30.0

SLIDER
101
77
273
110
F
F
1
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
102
140
274
173
Q
Q
2
20
3.0
1
1
NIL
HORIZONTAL

BUTTON
103
287
166
320
setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
181
287
244
320
go
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

MONITOR
103
457
222
502
# Regiões culturais
count-cultural-regions
0
1
11

MONITOR
109
527
209
572
Tamanho médio
mean-region-size
2
1
11

MONITOR
126
596
183
641
ticks
ticks
0
1
11

PLOT
1098
79
1298
229
# Regiões
ticks
# de regiões
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"clusters" 1.0 0 -7500403 true "" "plot count-cultural-regions"

PLOT
1100
282
1300
432
Tamanho médio das regiões
ticks
agentes por região (média)
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"mean-size" 1.0 0 -13345367 true "" "plot mean-region-size"

SLIDER
100
201
272
234
interaction-prob
interaction-prob
0
1
1.0
0.01
1
NIL
HORIZONTAL

BUTTON
128
355
200
388
go-fast
go-fast
T
1
T
OBSERVER
NIL
F
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

**Visão geral para quem não é especialista ou técnico no tema:**

1) Ideia em uma linha: gente parecida conversa mais; quando conversa, às vezes copia um pedacinho da cultura do outro. Isso cria “ilhas” de pessoas parecidas.

2) Dicionário rápido

- F (características) = os assuntos que definem a cultura (ex.: música, comida, esporte…).

- Q (traços) = as opções em cada assunto (ex.: música = {grunge, metal, pop}).

3) Cada pessoa tem uma “ficha” com suas escolhas, como: [grunge, pizza, futebol].

4) Como o modelo anda

a) Escolhe uma pessoa A e um vizinho (cima/baixo/esquerda/direita).

b) Mede o quanto se parecem (quantos itens iguais).

c) Quanto mais parecidos, maior a chance de A copiar 1 item que é diferente do vizinho.

5) O sistema trava quando vizinhos são iguais (nada a copiar) ou totalmente diferentes (nem começam a copiar).

6) O que mexer

- F: mais assuntos → mudanças mais lentas, ilhas mais estáveis.

- Q: mais opções por assunto → mapa mais fragmentado.

- interaction-prob: “porteiro” geral; deixe 1.0 para seguir o livro.

7) Mundo fiel ao modelo conceitual: ~61×61 e tórus desligado (bordas têm menos vizinhos).

8) O que observar

- Q baixo → elevado grandão.

- Q alto → mosaico de ilhas.

- F alto → todos ficam mais teimosos.

- Bordas (sem tórus) se comportam diferente do meio.


**Visão técnica:**

- Modelo didático do Axelrod (1997) de difusão cultural.

- Cada agente tem um vetor cultural com F características; cada característica assume um dos Q traços possíveis.

- Regras de homofilia + influência social geram consenso (uma cultura) ou fragmentação (mosaicos de culturas).

## HOW IT WORKS

1) Representação: vetor cultural do agente features = [f1, f2, …, fF], cada fi ∈ {0,…,Q−1}.

2) Similaridade: overlap = #posições idênticas; similaridade = overlap / F.

3) Dinâmica (por passo):

- Escolher um agente "a" e um vizinho (von Neumann: N, E, S, O).

- Com probabilidade igual à similaridade, "a" copia 1 traço de um atributo onde difere do vizinho.

4) Estado absorvido: não há mais pares vizinhos com 0 < overlap < F → sistema “trava”.

5) Aderência fiel ao livro: interaction-prob = 1.0 e tórus desligado.

## HOW TO USE IT

1) Configuração do mundo: ~61×61, wrap/tórus desmarcado para bater com o livro.

2) Sliders:

- F (nº de características) — típico: 5

- Q (nº de traços por característica) — típico: 15

- interaction-prob (porteira global de contato) — 1.0 para aderência ao livro

3) Botões: setup → go (forever).

4) Monitores úteis:

- Regiões culturais → count-cultural-regions

- Tamanho médio → mean-region-size

- ticks

5) Leitura visual: cores são um hash do vetor cultural (apenas para enxergar padrões).

## THINGS TO NOTICE

- Q baixo → consenso rápido. Q alto → fragmentação (muitos clusters).

- F alto (mais dimensões) → padrões mais persistentes e convergência mais lenta.

- Fronteiras (sem tórus) geram assimetrias: cantos têm 2 vizinhos, bordas 3, interior 4.

- O número de regiões estabiliza quando o sistema entra no estado absorvido.

## THINGS TO TRY

- Varie Q mantendo F fixo e observe o # de regiões (reproduz a tendência da Tabela 7-2).

- Fixe Q=15 e teste F = 2, 5, 8.

- Reduza interaction-prob (ex.: 0.6, 0.3) para simular barreiras de contato.

- Compare tórus desligado vs. ligado (variação do livro): o wrap acelera mistura e muda percolação.

## EXTENDING THE MODEL

Ideias simples sem quebrar o núcleo de Axelrod:

- Ruído de mutação raro (inovação): com probabilidade pequena, trocar aleatoriamente o traço de 1 feature.

- Vizinhança 8 (Moore) como chooser (“4-vonNeumann” vs “8-Moore”).

- Heterogeneidade: agentes com diferentes probabilidades de interação (influência).

- Barreiras espaciais: patches “muro” onde não há interação.

## NETLOGO FEATURES

- Uso de agentsets (ex.:, people-on neighbors4).

- BFS para rotular regiões culturais (clusters) e medir count-cultural-regions e mean-region-size.

- Cores geradas por um hash do vetor de traços (visualização leve).

## RELATED MODELS

Na NetLogo Models Library procure em Social Science:

- Axelrod Cultural Dissemination (https://ccl.northwestern.edu/netlogo/models/community/Axelrod_Cultural_Dissemination): variações do mesmo tema.

- Schelling Segregation Model (https://ccl.northwestern.edu/netlogo/models/community/Schelling_Segregation_Model): dinâmica espacial por homofilia (comparativo útil).

## CREDITS AND REFERENCES

Axelrod, R. (1997). "The Complexity of Cooperation: Agent-Based Models of Competition and Collaboration". (Cap. “Disseminating Culture”).
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@

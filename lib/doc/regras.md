# Regras de Negócio — SpinFlow

Regras que complementam o Diagrama de Classes mas não podem ser representadas diretamente em Mermaid.

---

## Regras Genéricas de Atributos

### Texto não vazio
Campo de texto que não pode ser vazio ou conter apenas espaços.
> `nome` — todas as classes

### Texto com formato de e-mail
Deve seguir o formato `usuario@dominio.com`.
> `email` — Aluno

### Texto com formato de telefone
Deve conter apenas dígitos, espaços e caracteres permitidos `()+-`.
> `telefone` — Aluno

### Texto com formato de URL
Quando informado, deve ser uma URL válida.
> `instagram`, `facebook`, `tiktok` — Aluno
> `link` — ArtistaBanda
> `linkVideo` — VideoAula

### Número maior que zero
Valor inteiro estritamente positivo (>0).
> `numeroFilas`, `numeroColunas` — Sala
> `duracaoMinutos` — Turma

### Número não negativo
Valor inteiro maior ou igual a zero (>=0).
> `fila`, `coluna` — PosicaoBike
> `posicaoProfessora` — Sala

### Data válida conforme calendário
Mês entre 1 e 12. Dia coerente com o mês e ano (ex: 29/02 apenas em ano bissexto). Ano entre 1900 e 2100.
> `dataNascimento` — Aluno
> `dataCadastro` — Bike
> `dataSolicitacao`, `dataRealizacao` — Manutencao
> `dataInicio`, `dataFim` — Mix, TurmaMix
> `data` — Checkin

### Data não futura
Não pode ser posterior à data atual do sistema.
> `dataNascimento` — Aluno
> `dataCadastro` — Bike
> `dataSolicitacao`, `dataRealizacao` — Manutencao
> `data` — Checkin

### Lista com ao menos um elemento
A lista deve conter ao menos um item.
> `diasSemana` — Turma

### Lista sem elementos repetidos
Não pode conter valores duplicados.
> `diasSemana` — Turma

---

## Regras Específicas de Atributos

- `posicaoProfessora` (Sala): deve ser `>= 0` e `< numeroColunas`.
- `fila` (PosicaoBike): deve ser `>= 0` e `< Sala.numeroFilas`.
- `coluna` (PosicaoBike): deve ser `>= 0` e `< Sala.numeroColunas`.
- `dataRealizacao` (Manutencao): quando informada, deve ser `>= dataSolicitacao`.
- `dataFim` (Mix, TurmaMix): quando informada, deve ser `>= dataInicio`.
- `dataNascimento` (Aluno): ano mínimo aceitável é 1900.

---

## Atributos Opcionais

Atributos não listados são obrigatórios.

| Classe | Atributos opcionais |
|---|---|
| Aluno | urlFoto, instagram, facebook, tiktok, observacoes |
| ArtistaBanda | descricao, link, foto |
| Bike | numeroSerie |
| CategoriaMusica | descricao |
| Fabricante | descricao, nomeContatoPrincipal, emailContato, telefoneContato |
| GrupoAlunos | descricao |
| Manutencao | dataRealizacao, descricao |
| Mix | dataFim, descricao |
| Musica | descricao |
| TipoManutencao | descricao |
| Turma | descricao |
| TurmaMix | dataFim |
| VideoAula | linkVideo |

---

## Checkin

- O checkin representa a presença de um aluno em uma aula específica (instância de Turma) em uma data.
- Um aluno não pode ter mais de um checkin na mesma turma na mesma data.
- Dois checkins não podem reservar a mesma posição (fila, coluna) na mesma turma e data.
- `bikeEhLivre(fila, coluna)`: verifica se a posição é válida (dentro dos limites da sala), se está disponível (sem outro checkin nessa posição/turma/data) e se a turma tem vaga — as três condições são cobertas por um único método, pois se a bike está livre a turma necessariamente tem vaga.
- `reservar(fila, coluna)`: coordena o processo de reserva — chama `bikeEhLivre` e, se aprovado, efetiva o checkin com a posição da bike e decrementa `bikesDisponiveis()` da turma.
- Cancelar um checkin (soft delete) libera a posição da bike e incrementa `bikesDisponiveis()` da turma.

---

## Turma

- `horarioSalaEhLivre()`: verifica se não existe outra turma registrada na mesma sala, com sobreposição de dias da semana e horário. Deve ser verificado ao criar ou editar uma turma.
- `bikesDisponiveis()`: retorna o total de bikes da sala menos as que estão com manutenção pendente (sem `dataRealizacao`) e as já reservadas via checkin. Nunca pode ser negativo.
- Desativar uma turma cancela todos os checkins futuros associados a ela.
- Não é possível ativar uma turma se `horarioSalaEhLivre()` retornar falso.

---

## Turma ↔ Mix (via TurmaMix)

- A relação entre Turma e Mix é feita pela classe associativa `TurmaMix`.
- `TurmaMix` registra qual mix está em uso em uma turma durante um período específico (`dataInicio`, `dataFim`).
- Mix é independente de Turma — o mesmo mix pode ser associado a turmas diferentes em períodos diferentes.
- `dataFim` nula indica que o mix está atualmente em uso naquela turma.
- Somente um `TurmaMix` por turma pode ter `dataFim` nula (mix ativo). Ao associar um novo mix, o anterior deve ter `dataFim` preenchida.

---

## Manutenção

- `TipoManutencao` classifica o tipo de problema ou serviço (ex: pedal quebrado, ajuste de selim).
- `Manutencao` registra uma ocorrência concreta: qual bike, qual tipo, quando foi solicitada e quando foi realizada.
- `dataRealizacao` nula indica manutenção pendente.
- `atualizarBikesDisponiveis()`: disparado automaticamente em dois momentos:
  - **Ao criar** uma manutenção: bike considerada quebrada → decrementa `bikesDisponiveis()` em todas as turmas que usam a sala da bike.
  - **Ao informar** `dataRealizacao`: bike considerada consertada → incrementa `bikesDisponiveis()` em todas as turmas que usam a sala da bike.
- Ao registrar uma manutenção para uma bike que possui checkins futuros, esses checkins devem ser cancelados e os alunos notificados.
- Uma bike só pode ter uma manutenção pendente (sem `dataRealizacao`) por vez.

---

## GrupoAlunos

- Agrupa alunos por perfil ou objetivo (ex: iniciantes, avançados), não por turma.
- Não substitui a relação Aluno ↔ Turma (feita via Checkin).

---

## Sala e Posicionamento de Bikes

- O layout da sala é definido por `numeroFilas` e `numeroColunas`, formando uma grade.
- Cada posição ocupada por uma bike é representada por `PosicaoBike` (fila, coluna, Bike).
- `PosicaoBike` é uma composição de `Sala` — não existe fora dela.
- `posicaoProfessora` é um inteiro que indica o índice da coluna da bike da professora na fila 0.
- `numeroBikes` é derivável pelo tamanho da lista de `PosicaoBike` — não é armazenado explicitamente.
- Não podem existir duas `PosicaoBike` com a mesma combinação (fila, coluna) dentro de uma mesma Sala.
- `PosicaoBike.ehValida(fila, coluna)`: os parâmetros recebem respectivamente `Sala.numeroFilas` e `Sala.numeroColunas` — `PosicaoBike` não depende diretamente de `Sala`.

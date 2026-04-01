# Casos de Uso — Descrições

## Tabela de Casos de Uso

| ID | Caso de Uso | Professora | Aluno |
|---|---|:---:|:---:|
| UC01 | Autenticar no Sistema | ✓ | ✓ |
| UC02 | Realizar Checkin | ✓ | ✓ |
| UC03 | Verificar Disponibilidade da Bike *(«include» de UC02)* | — | — |
| UC04 | Visualizar Mapa da Sala *(«include» de UC02)* | — | — |
| UC05 | Cancelar Checkin *(«extend» → UC02)* | ✓ qualquer | ✓ próprio |
| UC06 | Gerenciar Alunos e Grupos | ✓ | — |
| UC07 | Gerenciar Bikes e Fabricantes | ✓ | — |
| UC08 | Gerenciar Manutenções | ✓ | — |
| UC09 | Cancelar Manutenção *(«extend» → UC08)* | ✓ | — |
| UC10 | Gerenciar Salas e Turmas | ✓ | — |
| UC11 | Verificar Disponibilidade de Horário *(«include» de UC10)* | — | — |
| UC12 | Associar Mix à Turma *(«extend» → UC10)* | ✓ | — |
| UC13 | Gerenciar Mixes e Repertório | ✓ | — |
| UC14 | Consultar Agenda Semanal | ✓ | ✓ |
| UC15 | Consultar Mix e Repertório | ✓ | ✓ |
| UC16 | Consultar Histórico de Presença | — | ✓ |
| UC17 | Visualizar Dashboard | ✓ | ✓ |
| UC18 | Gerar Relatórios Gerenciais | ✓ | — |

---

## Descrições

### UC01 — Autenticar no Sistema
O usuário informa suas credenciais para acessar o sistema. O perfil (Professora ou Aluno) determina quais funcionalidades estarão disponíveis após o login. Senha mínima de 6 caracteres.

### UC02 — Realizar Checkin
O aluno ou professora reserva uma posição de bike em uma turma para uma data específica. O sistema valida a disponibilidade (`bikeEhLivre`) e exibe o mapa da sala antes de confirmar a reserva. A data deve cair em um dos dias da semana da turma e não pode ser anterior à data atual.

### UC03 — Verificar Disponibilidade da Bike *(«include»)*
Invocado sempre que UC02 é executado. Chama `bikeEhLivre(fila, coluna)`, verificando: posição dentro dos limites da sala, ausência de checkin ativo na mesma posição/turma/data e existência de vaga na turma.

### UC04 — Visualizar Mapa da Sala *(«include»)*
Invocado sempre que UC02 é executado. Exibe a grade visual (fila × coluna) com o estado de cada posição: livre, reservada, em manutenção ou posição da professora. Professora vê o nome do aluno em posições reservadas; aluno vê apenas ocupação anônima.

### UC05 — Cancelar Checkin *(«extend»)*
Estende UC02 quando existe um checkin prévio passível de cancelamento. Libera a posição, incrementa `bikesDisponiveis()` da turma e mantém o registro histórico com `cancelado = true`. Aluno só cancela o próprio checkin enquanto a data não passou; professora cancela qualquer checkin a qualquer momento.

### UC06 — Gerenciar Alunos e Grupos
CRUD completo de Aluno e GrupoAlunos. Inclui ativação/inativação (soft delete). Inativar um aluno cancela automaticamente seus checkins futuros. Grupo com todos os alunos inativos é inativado automaticamente.

### UC07 — Gerenciar Bikes e Fabricantes
CRUD de Bike e Fabricante. Bike é associada a um Fabricante no cadastro. Inativar uma bike cancela seus checkins futuros. Inativar um fabricante não inativa as bikes associadas.

### UC08 — Gerenciar Manutenções
Registro de ocorrências de manutenção para uma bike específica, com tipo e datas. Ao criar, `atualizarBikesDisponiveis()` é disparado — bike fica indisponível. Ao informar `dataRealizacao`, bike volta a estar disponível. Uma bike só pode ter uma manutenção pendente por vez.

### UC09 — Cancelar Manutenção *(«extend»)*
Estende UC08 quando existe uma manutenção passível de cancelamento. Define `cancelada = true`, dispara `atualizarBikesDisponiveis()` (bike volta a estar disponível) e preserva o registro histórico.

### UC10 — Gerenciar Salas e Turmas
CRUD de Sala e Turma. Sala define o layout físico (grade fila × coluna) e as posições de bikes via PosicaoBike. Turma associa um horário fixo a uma sala. Ao ativar uma turma, `horarioSalaEhLivre()` é sempre verificado.

### UC11 — Verificar Disponibilidade de Horário *(«include»)*
Invocado sempre que UC10 ativa ou edita uma turma. Chama `horarioSalaEhLivre()`, verificando se não há sobreposição de dias da semana e horário com outra turma ativa na mesma sala.

### UC12 — Associar Mix à Turma *(«extend»)*
Estende UC10 opcionalmente. Cria um registro TurmaMix com `dataInicio` e `dataFim = null` (mix ativo). Ao associar um novo mix, o TurmaMix anterior tem `dataFim` preenchida. Uma turma pode estar ativa sem mix associado.

### UC13 — Gerenciar Mixes e Repertório
CRUD de Mix, Musica, ArtistaBanda, CategoriaMusica e VideoAula. Um mix deve ter ao menos uma música. A mesma música não pode aparecer mais de uma vez no mesmo mix. Inativar um mix encerra o TurmaMix ativo associado.

### UC14 — Consultar Agenda Semanal
Exibe todas as turmas ativas em grade semanal (dia × horário) com sala, mix atual e quantidade de bikes disponíveis em tempo real. Filtro por sala ou dia. Indicação visual de turmas com alta ocupação (≥ 80%). Corresponde ao Relatório R08.

### UC15 — Consultar Mix e Repertório
Exibe o mix ativo de cada turma, lista de músicas com artista e categorias, links de vídeo-aula e histórico dos 3 últimos mixes. Corresponde ao Relatório R09.

### UC16 — Consultar Histórico de Presença
Exibe ao aluno seu histórico completo de checkins: total, anual e mensal de aulas concluídas, streak atual e histórico, posições favoritas por sala. Corresponde aos Relatórios R06 e R07.

### UC17 — Visualizar Dashboard
Professora: KPIs em tempo real (alunos ativos, aulas agendadas, mixes em uso, bikes OK). Aluno: métricas de aulas concluídas (total, ano, mês) e aulas agendadas.

### UC18 — Gerar Relatórios Gerenciais
Acesso aos relatórios estratégicos e gerenciais: R01 (Retenção), R02 (Saúde da Frota), R03 (Ocupação das Turmas), R04 (Linha do Tempo Musical), R05 (Frequência por Turma).

---

## Legenda dos Relacionamentos

| Notação | Tipo | Semântica |
|---|---|---|
| `──────►` `«include»` | Include | UC base **sempre** invoca o UC incluído — fluxo obrigatório. |
| `- - - -►` `«extend»` | Extend | UC de extensão **opcionalmente** adiciona comportamento ao UC base — condicional. |
| `───────` | Associação | Ator participa do caso de uso. |

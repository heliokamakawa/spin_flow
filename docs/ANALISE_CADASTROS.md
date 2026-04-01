# Análise de Cadastros — SpinFlow

Comparação entre três referências:
- **RF** — Requisitos Funcionais (`06-requisitos_funcionais.tex`)
- **DC** — Diagrama de Classes (`lib_docs/doc/dc.md`)
- **DTO** — Implementação atual (`lib/dto/`)

> O DC é a referência de modelagem mais coesa e alinhada ao documento.
> Um cadastro pode envolver mais de uma entidade (ex.: Sala + PosicaoBike).

---

## 1. Entidades do Diagrama de Classes e seus atributos

| Entidade | Atributos (DC) |
|---|---|
| **Fabricante** | id, nome, descricao, nomeContatoPrincipal, emailContato, telefoneContato, ativo |
| **TipoManutencao** | id, nome, descricao, ativa |
| **Bike** | id, nome, numeroSerie, dataCadastro, ativa |
| **Manutencao** | id, dataSolicitacao, dataRealizacao, descricao, ativo |
| **ArtistaBanda** | id, nome, descricao, link, foto, ativo |
| **CategoriaMusica** | id, nome, descricao, ativa |
| **VideoAula** | id, nome, linkVideo, ativo |
| **Mix** | id, nome, dataInicio, dataFim, descricao, ativo |
| **Musica** | id, nome, descricao, ativo |
| **Sala** | id, nome, numeroFilas, numeroColunas, posicaoProfessora, ativa |
| **PosicaoBike** | fila, coluna *(+ associação → Bike)* |
| **Turma** | id, nome, descricao, diasSemana, horarioInicio, duracaoMinutos, ativo |
| **TurmaMix** | id, dataInicio, dataFim, ativo *(+ associações → Turma, Mix)* |
| **Aluno** | id, nome, email, dataNascimento, genero, telefone, urlFoto, instagram, facebook, tiktok, observacoes, ativo |
| **GrupoAlunos** | id, nome, descricao, ativo *(+ associação → Aluno)* |
| **Checkin** | id, data *(+ associações → Aluno, Turma)* |

**Enumerações:** `Genero` (MASCULINO, FEMININO, OUTRO), `DiaSemana` (SEGUNDA … DOMINGO)

---

## 2. Comparação DC × DTO

### ✅ DC e DTO alinhados

| Entidade (DC) | DTO | Divergências |
|---|---|---|
| Fabricante | `DTOFabricante` | Nenhuma — todos os atributos presentes |
| TipoManutencao | `DTOTipoManutencao` | Nenhuma |
| ArtistaBanda | `DTOArtistaBanda` | Nenhuma |
| CategoriaMusica | `DTOCategoriaMusica` | Nenhuma |
| VideoAula | `DTOVideoAula` | Nenhuma |
| Aluno | `DTOAluno` | `genero` é `String` no DTO; DC modela como enum `Genero` |
| GrupoAlunos | `DTOGrupoAlunos` | DTO desnormaliza e traz `List<DTOAluno>` — correto para uso em tela |
| Turma | `DTOTurma` | `diasSemana` é `List<String>` no DTO; DC usa `List<DiaSemana>` (enum). DTO traz `sala` desnormalizada — correto |
| Mix | `DTOMix` | DTO traz `musicas` desnormalizadas — correto. `dataInicio`/`dataFim` presentes em ambos |
| Musica | `DTOMusica` | DTO traz `artista`, `categorias`, `linksVideoAula` desnormalizados — correto |
| Bike | `DTOBike` | DTO traz `fabricante` desnormalizado — correto |

---

### ⚠️ DC e DTO com divergências

**Sala**

| Atributo (DC) | DTOSala | DTOSalaPosicionamento |
|---|---|---|
| nome | ✅ | ✅ |
| numeroFilas | ✅ | ✅ |
| numeroColunas | ❌ nomeado `limiteBikesPorFila` | ❌ nomeado `limiteBikesPorFila` |
| posicaoProfessora | ❌ **ausente** | ✅ como `posicaoBikeProfessora` |
| ativa | ✅ | ✅ como `ativo` |
| — | `numeroBikes` (não está no DC) | `numeroBikes` (não está no DC) |
| — | `gradeBikes: List<List<bool>>` (não está no DC) | `posicoes: List<List<int>>` (não está no DC, mas faz sentido operacional) |

O DC modela **uma única entidade Sala**. O código tem dois DTOs com contextos distintos (CRUD e mapa operacional) — separação razoável, mas `DTOSala` precisa receber `posicaoProfessora`.

**TurmaMix**

| Atributo (DC) | Implementação |
|---|---|
| id | ❌ sem DTO próprio |
| dataInicio | ⚠️ embutido em `DTOMix` |
| dataFim | ⚠️ embutido em `DTOMix` |
| ativo | ❌ sem DTO próprio |

O DC modela TurmaMix como entidade separada. O DTO atual achata as datas no Mix — simplificação que impede compartilhamento do mesmo Mix entre turmas.

**Checkin**

| Atributo (DC) | RF exige | Implementação |
|---|---|---|
| id | Sim | ❌ sem DTO |
| data | Sim | ❌ sem DTO |
| fila | Sim (RF `persistir_dados_do_checkin`) | ❌ não está no DC nem no DTO |
| coluna | Sim (RF `persistir_dados_do_checkin`) | ❌ não está no DC nem no DTO |

> `fila` e `coluna` são parâmetros nos métodos do DC (`bikeEhLivre(fila, coluna)`, `reservar(fila, coluna)`) mas não estão declarados como atributos. O RF exige persistência — **gap no DC e no DTO**.

---

### ❌ Entidade no DC sem DTO

| Entidade (DC) | Situação |
|---|---|
| **Manutencao** | Sem DTO. RF `registrar_manutencoes` é essencial |
| **PosicaoBike** | Sem DTO dedicado. Parcialmente representada em `DTOSalaPosicionamento.posicoes` |
| **Checkin** | Sem DTO. Entidade central do sistema |
| **TurmaMix** | Sem DTO. Datas achatadas em `DTOMix` |

---

### 🗑️ DTO sem correspondente no DC

| DTO | Situação |
|---|---|
| `DTOSalaPosicionamento` | Não está no DC. Representa o mapa operacional da sala (Sala + posições de bikes). Pode ser mantido como DTO de uso interno de tela, mas não é uma entidade do domínio. |
| `DTOLinkVideoAula` | Não está no DC. O DC modela `VideoAula` como entidade própria (com id, nome, linkVideo, ativo). `DTOLinkVideoAula` é uma representação simplificada embutida em `DTOMusica` — redundante com `DTOVideoAula`. |

---

## 3. Resumo executivo

| Status | Entidades |
|---|---|
| ✅ Alinhado (10) | Fabricante, TipoManutencao, ArtistaBanda, CategoriaMusica, VideoAula, Aluno, GrupoAlunos, Turma, Mix, Musica, Bike |
| ⚠️ Divergência pontual (2) | Sala — falta `posicaoProfessora` em `DTOSala`; TurmaMix — achatado em `DTOMix` |
| ❌ Sem DTO (4) | Checkin, Manutencao, PosicaoBike, TurmaMix |
| 🗑️ DTO sem entidade no DC (2) | `DTOSalaPosicionamento` (uso interno de tela), `DTOLinkVideoAula` (redundante com `DTOVideoAula`) |
| ⚠️ Gap no DC (1) | `Checkin` sem atributos `fila` e `coluna` — exigidos pelo RF |

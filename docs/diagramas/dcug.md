## Diagrama de Caso de Uso — Aluno

```mermaid
flowchart LR
    Aluno(["👤 Aluno"])

    subgraph SpinFlow["SpinFlow — Visão do Aluno"]
        direction TB

        subgraph SG1["Acesso"]
            UC01(["Autenticar no Sistema"])
        end

        subgraph SG2["Checkin e Reserva"]
            UC02(["Realizar Checkin"])
            UC03(["Verificar Disponibilidade\nda Bike"])
            UC04(["Visualizar Mapa da Sala"])
            UC05(["Cancelar Checkin"])
        end

        subgraph SG3["Consultas"]
            UC14(["Consultar Agenda Semanal"])
            UC15(["Consultar Mix e Repertório"])
            UC16(["Consultar Histórico\nde Presença"])
            UC17(["Visualizar Dashboard"])
        end
    end

    %% ── Associações ─────────────────────────────────────────────
    Aluno --- UC01
    Aluno --- UC02
    Aluno --- UC05
    Aluno --- UC14
    Aluno --- UC15
    Aluno --- UC16
    Aluno --- UC17

    %% ── «include» ───────────────────────────────────────────────
    UC02 -->|"«include»"| UC03
    UC02 -->|"«include»"| UC04

    %% ── «extend» ────────────────────────────────────────────────
    UC05 -.->|"«extend»"| UC02
```

---

## Diagrama de Caso de Uso — Professora

```mermaid
flowchart LR
    Professora(["👤 Professora"])

    subgraph SpinFlow["SpinFlow — Visão da Professora"]
        direction TB

        subgraph SG1["Acesso"]
            UC01(["Autenticar no Sistema"])
        end

        subgraph SG2["Checkin e Reserva"]
            UC02(["Realizar Checkin"])
            UC03(["Verificar Disponibilidade\nda Bike"])
            UC04(["Visualizar Mapa da Sala"])
            UC05(["Cancelar Checkin"])
        end

        subgraph SG3["Gestão Operacional"]
            UC06(["Gerenciar Alunos\ne Grupos"])
            UC07(["Gerenciar Bikes\ne Fabricantes"])
            UC08(["Gerenciar Manutenções"])
            UC09(["Cancelar Manutenção"])
            UC10(["Gerenciar Salas\ne Turmas"])
            UC11(["Verificar Disponibilidade\nde Horário"])
            UC12(["Associar Mix à Turma"])
            UC13(["Gerenciar Mixes\ne Repertório"])
        end

        subgraph SG4["Consultas e Relatórios"]
            UC14(["Consultar Agenda Semanal"])
            UC15(["Consultar Mix e Repertório"])
            UC17(["Visualizar Dashboard"])
            UC18(["Gerar Relatórios Gerenciais"])
        end
    end

    %% ── Associações ─────────────────────────────────────────────
    Professora --- UC01
    Professora --- UC02
    Professora --- UC05
    Professora --- UC06
    Professora --- UC07
    Professora --- UC08
    Professora --- UC10
    Professora --- UC13
    Professora --- UC14
    Professora --- UC15
    Professora --- UC17
    Professora --- UC18

    %% ── «include» ───────────────────────────────────────────────
    UC02 -->|"«include»"| UC03
    UC02 -->|"«include»"| UC04
    UC10 -->|"«include»"| UC11

    %% ── «extend» ────────────────────────────────────────────────
    UC05 -.->|"«extend»"| UC02
    UC09 -.->|"«extend»"| UC08
    UC12 -.->|"«extend»"| UC10
```

---

## Casos de Uso

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

## Legenda

| Notação | Tipo | Semântica |
|---|---|---|
| `──────►` `«include»` | Include | UC base **sempre** invoca o UC incluído — fluxo obrigatório. |
| `- - - -►` `«extend»` | Extend | UC de extensão **opcionalmente** adiciona comportamento ao UC base — condicional. |
| `───────` | Associação | Ator participa do caso de uso. |

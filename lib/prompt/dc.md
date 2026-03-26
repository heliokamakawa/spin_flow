# Prompt: Diagrama de Classes — SpinFlow

## Objetivo

Gerar e manter atualizado o arquivo `lib/doc/dc.md` com o Diagrama de Classes do projeto SpinFlow completo, em formato **Mermaid** (`classDiagram`), refletindo com precisão **todo o código Dart existente em `lib/`**.

O diagrama representa a arquitetura completa do projeto, não apenas os modelos de dados. Os DTOs são um bom ponto de partida por serem a camada mais estável e central, mas o diagrama deve evoluir para incluir todas as camadas relevantes: DAOs, telas, formulários, componentes, validações, etc.

---

## Fonte da Verdade

O diagrama deve ser gerado **exclusivamente a partir dos arquivos Dart** dentro de `lib/`. Nunca inferir campos, métodos ou relacionamentos — apenas representar o que está implementado no código.

### Camadas do Projeto

| Pasta | O que contém | Incluir no DC? |
|---|---|---|
| `lib/dto/` | Modelos de dados (DTOs) | Sim — base do diagrama |
| `lib/banco/sqlite/dao/` | Acesso ao banco (DAOs) | Sim |
| `lib/banco/sqlite/` | Conexão e script SQL | Sim (classes de infraestrutura) |
| `lib/banco/mock/` | Dados mock para testes | A avaliar — incluir se relevante |
| `lib/widget/` | Telas e formulários | Sim — principais telas e forms |
| `lib/widget/componentes/` | Campos e componentes reutilizáveis | A avaliar — incluir se relevante |
| `lib/configuracoes/` | Rotas e constantes | Não — são arquivos de configuração sem classes relevantes |
| `lib/validacoes/` | Lógica de validação | A avaliar — incluir se houver classes |

| Arquivo Dart | Classe no Diagrama |
|---|---|
| `dto/dto.dart` | — (não incluir; classe abstrata auxiliar do código, não relevante para o DC) |
| `dto/dto_aluno.dart` | `Aluno` |
| `dto/dto_artista_banda.dart` | `ArtistaBanda` |
| `dto/dto_bike.dart` | `Bike` |
| `dto/dto_categoria_musica.dart` | `CategoriaMusica` |
| `dto/dto_fabricante.dart` | `Fabricante` |
| `dto/dto_grupo_alunos.dart` | `GrupoAlunos` |
| `dto/dto_mix.dart` | `Mix` |
| `dto/dto_musica.dart` | `Musica` + `LinkVideoAula` |
| `dto/dto_sala.dart` | `Sala` |
| `dto/dto_sala_posicionamento.dart` | `SalaPosicionamento` |
| `dto/dto_tipo_manutencao.dart` | `TipoManutencao` |
| `dto/dto_turma.dart` | `Turma` |
| `dto/dto_video_aula.dart` | `VideoAula` |

---

## Regras de Representação

### 1. Atributos

- Listar **todos os campos declarados** na classe Dart, na mesma ordem em que aparecem no código.
- Usar tipos genéricos independentes de linguagem: `int`, `String`, `bool`, `DateTime`, `List`.
- Não usar `?` nos tipos — opcional/nulabilidade é detalhe de implementação Dart, não do diagrama de domínio.
- Campos com valor padrão (`ativo = true`) são representados normalmente sem o valor padrão.
- Visibilidade: todos os atributos são `+` (public), pois os DTOs usam `final` público.
- **Enums são declarados separadamente com `<<enumeration>>` e usados como tipo do atributo** — sem seta de associação, pois enum é tipo de valor, não objeto com identidade própria.
- **Atributos que representam associações não são listados no bloco da classe** — a linha de associação já expressa esse relacionamento. Ex: `Bike` não lista `fabricante` como atributo porque a linha `Bike "N" --> "1" Fabricante` já o representa.

**Sintaxe Mermaid para tipos genéricos:**
- `List<DTOAluno>` → `List~DTOAluno~`
- `List<List<bool>>` → `List~List~bool~~`
- `List<List<int>>` → `List~List~int~~`

### 2. Nomenclatura das Classes

- Remover o prefixo `DTO` de todos os nomes: `DTOAluno` → `Aluno`, `DTOMusica` → `Musica`, etc.
- A classe abstrata `DTO` do código **não é incluída** no diagrama — é um detalhe de implementação Dart, irrelevante para o diagrama de domínio.
- Como consequência, não existem setas de herança vindas de `DTO`.

### 3. Relacionamentos entre Classes

Usar os seguintes critérios para o tipo de seta:

| Situação no Dart | Tipo de relação Mermaid | Sintaxe |
|---|---|---|
| Campo de outro DTO (referência simples) | Associação | `A "N" --> "1" B` |
| `List<OutroDTO>` onde B existe independentemente | Associação | `A "1" --> "N" B` |

**Regra de composição:** `DTOLinkVideoAula` é declarada dentro do arquivo `dto_musica.dart` e não possui identidade própria (sem `id`, sem herança de DTO) → relação de **composição** com `DTOMusica`.

**Multiplicidades a usar:**
- Campo simples (não lista): `"N" --> "1"` (muitos DTOs referenciam um)
- Lista: `"1" --> "N"` ou `"1" *-- "N"` conforme acima

### 4. Classes Sem Herança

- `DTOLinkVideoAula`: classe auxiliar declarada em `dto_musica.dart`. Incluir no diagrama mas **sem** a seta de herança para `DTO`.

### 5. Direção do Diagrama

- Usar `direction TB` (top to bottom).

---

## Estrutura do Arquivo `lib/doc/dc.md`

O arquivo deve conter **apenas** o bloco Mermaid, sem texto adicional:

````
```mermaid
classDiagram
    direction TB

    %% Classe base abstrata
    class DTO { ... }

    %% DTOs concretos (ordem alfabética)
    class DTOAluno { ... }
    ...

    %% Classe auxiliar (sem herança de DTO)
    class DTOLinkVideoAula { ... }

    %% Herança (implements DTO)
    DTO <|.. DTOAluno
    ...

    %% Associações
    ...
```
````

---

## Ordem das Classes no Diagrama

1. Classes de modelo em **ordem alfabética**: Aluno, ArtistaBanda, Bike, CategoriaMusica, Fabricante, GrupoAlunos, Mix, Musica, Sala, SalaPosicionamento, TipoManutencao, Turma, VideoAula
2. Classes auxiliares (ex: `LinkVideoAula`) — após os modelos principais
3. Bloco de associações — por último

## Decisões Tomadas (Histórico)

| Decisão | Justificativa |
|---|---|
| Prefixo `DTO` removido de todos os nomes | O DC representa o domínio, não detalhes de implementação Dart |
| Classe abstrata `DTO` não incluída | Detalhe de implementação; não agrega informação ao diagrama de domínio |
| Sem bloco de herança | Consequência da remoção da classe `DTO` — não há hierarquia a representar nesta camada |
| `LinkVideoAula` sem prefixo e como composição | Declarada dentro de `dto_musica.dart`, sem `id`; só existe dentro de `Musica` |
| `Musica *-- LinkVideoAula` (composição) | `LinkVideoAula` não tem identidade própria, só existe dentro de `Musica` |
| `GrupoAlunos --> Aluno` (associação, não composição) | `Aluno` tem `id` e identidade própria; existe independentemente do grupo |
| `SalaPosicionamento` sem relacionamentos | Não referencia outros modelos no código — é independente |
| Ordem alfabética para classes | Facilita localização e comparação com os arquivos Dart |
| Comentários de seção com `%%` | Separam visualmente modelos, auxiliares e associações |

---

## Processo de Atualização

Sempre que um DTO for adicionado, removido ou modificado:

1. Ler o arquivo Dart correspondente em `lib/dto/`
2. Verificar se campos, tipos e relacionamentos mudaram
3. Atualizar `lib/doc/dc.md` para refletir o código atual
4. Atualizar este arquivo (`prompt/dc.md`) se as diretrizes precisarem evoluir

---

## O que NÃO incluir no Diagrama

- Construtores — não representar
- Anotações `@override` — não representar
- Imports — irrelevantes para o diagrama
- Arquivos de constantes puras (rotas, mensagens de erro) — sem classes relevantes
- Dados mock (`lib/banco/mock/`) — apenas se usados como referência de estrutura

## Estratégia de Evolução do Diagrama

O diagrama cresce em camadas, da mais central para a mais externa:

1. **DTOs** — modelos de dados (já mapeados)
2. **DAOs** — acesso ao banco; relacionam-se com os DTOs que manipulam
3. **Conexão/Script** — infraestrutura do banco
4. **Telas e formulários** — widgets principais; relacionam-se com DAOs e DTOs
5. **Componentes reutilizáveis** — avaliar inclusão conforme complexidade

A cada evolução: ler os arquivos Dart da camada, mapear classes, atributos relevantes, métodos públicos principais e relacionamentos com outras camadas.

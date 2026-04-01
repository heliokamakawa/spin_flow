# Agrupamento de Cadastros e Listas

## Grupos Confirmados

### Cadastros/Lista Simples
Cadastros e listas que não exigem associação obrigatória com outros registros no momento do cadastro. São independentes e podem ser criados sem dependências.

- Fabricantes
- Categorias de Música
- Tipos de Manutenção
- Artistas/Bandas
- Alunos
- Salas
- Vídeo-aula *(lista ainda não implementada)*

### Cadastros/Lista com Associações
Cadastros e listas que exigem ou envolvem associação obrigatória com outros registros no momento do cadastro.

- Bikes (associação obrigatória com Fabricante)
- Músicas (associação obrigatória com Artista/Banda e Categoria)
- Mixes (associação obrigatória com Músicas)
- Turmas (associação obrigatória com Sala, dias, etc.)
- Grupos de Alunos (associação obrigatória com Alunos)

---

## Grupos em Análise

- **Vídeo-aula:** Cadastro já implementado, mas a lista ainda não está disponível. Avaliar se haverá associações futuras (ex: vincular vídeo-aula a músicas ou turmas).
- **Alunos:** Atualmente considerado simples, mas pode futuramente ter associações obrigatórias (ex: turma obrigatória no cadastro).
- **Artistas/Bandas:** Atualmente considerado simples, mas pode futuramente exigir associação obrigatória com músicas ou outros elementos.

---

## Análise do Projeto: Mapeamento de Estruturas

### DTOs (Data Transfer Objects)
- Localizados em `lib/dto/`
- Cada entidade de cadastro possui um DTO correspondente (ex: `dto_bike.dart`, `dto_fabricante.dart`, etc.)
- DTOs refletem os campos do formulário e as associações necessárias para cada entidade.

### Cadastros (Forms)
- Localizados em `lib/widget/` com prefixo `form_`
- Cada cadastro implementa a lógica de criação/edição, validação e uso dos DTOs.
- Seguem padrão de métodos: `_carregarDadosEdicao`, `_preencherCampos`, `_limparCampos`, `_criarDTO`, `_mostrarMensagem`, `_redirecionarAposSalvar`, `_salvar`.

### Scripts de Banco/Mocks
- Localizados em `lib/banco/mock/` (dados simulados) e `lib/banco/sqlite/script.dart` (scripts SQL)
- Usados para simulação e testes de persistência.

### DAOs (Data Access Objects)
- Localizados em `lib/banco/sqlite/dao/`
- Cada entidade associada a um DAO para persistência real (ex: `dao_bike.dart`, `dao_fabricante.dart`)
- DAOs implementam métodos de CRUD e refletem as associações necessárias.

### Outros
- Rotas centralizadas em `lib/configuracoes/rotas.dart`
- Componentes reutilizáveis em `lib/widget/componentes/`
- Documentação de listas e componentes em `docs/componentes/`

---

## Observações
- O agrupamento visa facilitar a navegação e o entendimento do fluxo de cadastro/listagem.
- Sempre que um cadastro passar a exigir associação obrigatória, deve ser movido para o grupo de "com associações".
- Recomenda-se manter a documentação atualizada conforme o projeto evolui. 
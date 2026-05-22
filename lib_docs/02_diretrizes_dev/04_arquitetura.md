# Arquitetura em Camadas

O SpinFlow adota uma arquitetura em camadas inspirada no padrão MVC, com uma
camada `core` de infraestrutura compartilhada.

## Visão geral

```
visão  ->  controle  ->  modelo (dto + dao)
                \              /
                   core (base + infraestrutura)
```

- A **visão** depende do **controle**.
- O **controle** depende do **modelo**.
- **Controle** e **modelo** apoiam-se no **core**.
- A visão **nunca** acessa um DAO diretamente.

## Camadas

### visão (`lib/visao/`)

Camada de apresentação. Não contém acesso a dados.

- `forms/`: formulários de cadastro (`form_*.dart`).
- `listas/`: listagens (`lista_*.dart`).
- `telas/`: demais telas, incluindo `telas/aluno/` e `telas/professora/`.
- `componentes/`: widgets reutilizáveis, inclusive `componentes/campos/`.

Cada view instancia um único controlador e o utiliza para toda operação de
dados. Formulários e telas (`StatefulWidget`) liberam o controlador no
`dispose`.

### controle (`lib/controle/`)

Um controlador por feature ou por tela (`controlador_*.dart`). Cada controlador:

- estende `ControladorBase` (um `ChangeNotifier`);
- encapsula os DAOs de que a feature precisa (inclusive auxiliares de dropdown);
- expõe métodos que delegam ao DAO, preservando assinaturas;
- é o único ponto de comunicação entre a visão e o modelo.

### modelo (`lib/modelo/`)

- `dto/`: entidades de transferência de dados (`dto_*.dart`).
- `dao/`: objetos de acesso a dados SQLite (`dao_*.dart`).

### core (`lib/core/`)

Infraestrutura comum, usada tanto pelo controle quanto pelo modelo.

- `base/controlador_base.dart`: classe base (`ChangeNotifier`) de todos os
  controladores, com estado de `carregando` e `erro`.
- `banco/`: conexão e scripts SQLite.
- `mock/`: dados de mock.
- `configuracoes/`: rotas, sessão de usuário e mensagens de erro.
- `validacoes/`: validadores reutilizáveis.

## Regra de dependência

Imports permitidos por camada:

| Camada    | Pode importar de                          |
|-----------|-------------------------------------------|
| visão     | controle, core, modelo/dto                |
| controle  | modelo (dao + dto), core                  |
| modelo    | core                                      |
| core      | apenas Flutter/Dart e pacotes externos    |

Em especial: **nenhum arquivo em `lib/visao/` importa `lib/modelo/dao/`**.

## Padrão de controlador

```dart
class ControladorFabricante extends ControladorBase {
  final DAOFabricante _dao = DAOFabricante();

  Future<List<DTOFabricante>> listar() async {
    definirCarregando(true);
    try {
      return await _dao.buscarTodos();
    } finally {
      definirCarregando(false);
    }
  }

  Future<int> salvar(DTOFabricante dto) => _dao.salvar(dto);
  Future<void> excluir(int id) => _dao.excluir(id);
}
```

A view cria o controlador, chama seus métodos e (se for `StatefulWidget`) o
libera no `dispose`.

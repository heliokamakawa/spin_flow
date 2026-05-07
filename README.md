# SpinFlow

Sistema de gerenciamento para estudio de indoor cycling (Pulse Studio Indoor), desenvolvido em Flutter com persistencia local SQLite.

## Perfis de Acesso

O sistema possui dois perfis:

- **Professora**: Gerencia turmas, alunos, bikes, mixes, check-ins, manutencoes e relatorios.
- **Aluno**: Faz check-in, consulta historico, indicadores, agenda e mix da turma.

### Credenciais de teste (seed)

| Perfil      | Email                   | Senha |
|-------------|-------------------------|-------|
| Professora  | professora@gmail.com    | 123   |
| Aluno       | aluno@gmail.com         | 123   |

## Como rodar

```bash
flutter pub get
flutter run
```

## Testes de Integracao (Apresentacao)

Os testes de integracao navegam por todas as telas do sistema automaticamente, servindo como demonstracao geral do app. Cada tela fica visivel por 2 segundos para facilitar a apresentacao.

### Pre-requisitos

- Um dispositivo fisico conectado via USB ou um emulador/simulador rodando.
- Para listar os dispositivos disponiveis:

```bash
flutter devices
```

### Rodar os testes

**Fluxo da Professora** (login, dashboard com 5 abas, listas, formularios, mapa operacional, relatorios):

```bash
flutter test integration_test/test_fluxo_professora.dart -d <DEVICE_ID>
```

**Fluxo do Aluno** (login, dashboard, drawer, historico com filtros, detalhe de aula, indicadores, agenda, check-in, perfil, logout, recuperar senha):

```bash
flutter test integration_test/test_fluxo_aluno.dart -d <DEVICE_ID>
```

Substitua `<DEVICE_ID>` pelo ID do dispositivo retornado por `flutter devices`. Exemplos:

```bash
# Emulador Android
flutter test integration_test/test_fluxo_professora.dart -d emulator-5554

# Simulador iOS
flutter test integration_test/test_fluxo_professora.dart -d iPhone-16

# Primeiro dispositivo disponivel
flutter test integration_test/test_fluxo_professora.dart -d all
```

### Estrutura dos testes

```
integration_test/
  test_fluxo_professora.dart   # Fluxo completo da professora
  test_fluxo_aluno.dart        # Fluxo completo do aluno
test_driver/
  integration_test.dart        # Driver para flutter drive (web)
```

## Tecnologias

- Flutter 3.38+
- Dart 3.10+
- SQLite (sqflite + sqflite_common_ffi_web)
- Arquitetura: DAO + DTO + Widgets

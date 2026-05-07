import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spin_flow/spim_flow_app.dart';

/// Teste de integração — Fluxo da Professora
/// Faz login como professora e navega por todas as telas do sistema.
///
/// Comando: flutter test integration_test/test_fluxo_professora.dart -d chrome
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Fluxo Professora - Apresentacao Geral', () {
    testWidgets('Login e navegacao por todas as telas', (tester) async {
      await tester.pumpWidget(const SpinFlowApp());

      // ── Splash ──
      // Aguarda splash animar e ir para login
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // ── Login ──
      expect(find.text('SpinFlow'), findsWidgets);
      expect(find.text('Entrar'), findsOneWidget);

      // Preencher email
      final campoEmail = find.byType(TextFormField).first;
      await tester.tap(campoEmail);
      await tester.pumpAndSettle();
      await tester.enterText(campoEmail, 'professora@gmail.com');
      await tester.pumpAndSettle();

      // Preencher senha
      final campoSenha = find.byType(TextFormField).at(1);
      await tester.tap(campoSenha);
      await tester.pumpAndSettle();
      await tester.enterText(campoSenha, '123');
      await tester.pumpAndSettle();

      // Tap no botão Entrar
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // ── Dashboard Professora ──
      expect(find.text('Dashboard da Professora'), findsOneWidget);

      // Aba 1: Visão Geral (já é a aba padrão)
      expect(find.text('Alunos Ativos'), findsOneWidget);
      await _pausaApresentacao(tester);

      // ── Aba 2: Cadastros ──
      await tester.tap(find.text('Cadastros'));
      await tester.pumpAndSettle();
      expect(find.text('Cadastros Simples'), findsOneWidget);
      await _pausaApresentacao(tester);

      // ── Aba 3: Listas ──
      await tester.tap(find.text('Listas'));
      await tester.pumpAndSettle();
      expect(find.text('Listas Simples'), findsOneWidget);
      await _pausaApresentacao(tester);

      // ── Aba 4: Aulas ──
      await tester.tap(find.text('Aulas'));
      await tester.pumpAndSettle();
      expect(find.text('Registrar Check-in'), findsOneWidget);
      await _pausaApresentacao(tester);

      // ── Aba 5: Manutenção ──
      await tester.tap(find.text('Manutenção'));
      await tester.pumpAndSettle();
      expect(find.text('Registrar Manutenção'), findsOneWidget);
      await _pausaApresentacao(tester);

      // ── Navegar para: Lista de Alunos ──
      await tester.tap(find.text('Listas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alunos'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Lista de Turmas ──
      await tester.tap(find.text('Turmas').first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Lista de Bikes ──
      await tester.tap(find.text('Bikes').first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Lista de Mixes ──
      await tester.tap(find.text('Mixes'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Lista de Manutenções ──
      await tester.tap(find.text('Manutenções'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Lista de Check-ins ──
      await tester.tap(find.text('Check-ins'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Aba Aulas → Mapa Operacional ──
      await tester.tap(find.text('Aulas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mapa operacional (cancelar check-ins)'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Mapa Operacional (Professora)'), findsOneWidget);
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Posicionamento de Bikes ──
      await tester.tap(find.text('Posicionamento de Bikes'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Relatórios Gerenciais ──
      await tester.tap(find.text('Relatórios Gerenciais'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Aba Cadastros → Formulário de Aluno ──
      await tester.tap(find.text('Cadastros'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alunos'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Formulário de Turma ──
      await tester.tap(find.text('Turmas'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Formulário de Sala ──
      await tester.tap(find.text('Sala'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Formulário de Bike ──
      await tester.tap(find.text('Cadastros com Associações'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bikes'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Navegar para: Formulário de Mix ──
      await tester.tap(find.text('Mix'));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await _pausaApresentacao(tester);
      await _voltar(tester);

      // ── Voltar para Visão Geral ──
      await tester.tap(find.text('Visão Geral'));
      await tester.pumpAndSettle();
      expect(find.text('Alunos Ativos'), findsOneWidget);
      await _pausaApresentacao(tester);

      // ✅ Teste concluído com sucesso!
    });
  });
}

/// Pausa de 2 segundos para visualizar a tela na apresentação.
Future<void> _pausaApresentacao(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
}

/// Simula o botão voltar do AppBar.
Future<void> _voltar(WidgetTester tester) async {
  final backButton = find.byType(BackButton);
  if (backButton.evaluate().isNotEmpty) {
    await tester.tap(backButton.first);
    await tester.pumpAndSettle();
  } else {
    // Fallback: tenta o ícone de voltar
    final arrowBack = find.byIcon(Icons.arrow_back);
    if (arrowBack.evaluate().isNotEmpty) {
      await tester.tap(arrowBack.first);
      await tester.pumpAndSettle();
    }
  }
}

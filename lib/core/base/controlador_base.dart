import 'package:flutter/foundation.dart';

/// Classe base de todos os controladores da camada de controle.
///
/// Faz parte da camada `core` e e o ponto de comunicacao comum entre as
/// camadas de controle e de modelo. Estende [ChangeNotifier] para que a
/// camada de visao possa, opcionalmente, reagir a mudancas de estado
/// (carregamento, erro) por meio de listeners.
///
/// Arquitetura (similar a MVC):
///   visao  ->  controle  ->  modelo
///                 \           /
///                    core (base + infraestrutura)
abstract class ControladorBase extends ChangeNotifier {
  bool _carregando = false;
  String? _erro;
  bool _descartado = false;

  /// Indica se o controlador esta executando uma operacao assincrona.
  bool get carregando => _carregando;

  /// Mensagem do ultimo erro registrado, ou `null` se nao houve erro.
  String? get erro => _erro;

  /// `true` quando ha um erro registrado.
  bool get temErro => _erro != null;

  @override
  void dispose() {
    _descartado = true;
    super.dispose();
  }

  /// Notifica os listeners apenas enquanto o controlador estiver ativo,
  /// evitando excecoes ao notificar apos o `dispose`.
  @protected
  void notificar() {
    if (!_descartado) {
      notifyListeners();
    }
  }

  /// Define o estado de carregamento e notifica os listeners.
  @protected
  void definirCarregando(bool valor) {
    if (_carregando != valor) {
      _carregando = valor;
      notificar();
    }
  }

  /// Registra uma mensagem de erro e notifica os listeners.
  @protected
  void definirErro(String? mensagem) {
    _erro = mensagem;
    notificar();
  }

  /// Limpa o erro atual, se houver.
  void limparErro() {
    if (_erro != null) {
      _erro = null;
      notificar();
    }
  }
}

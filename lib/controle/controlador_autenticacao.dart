import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_usuario.dart';

/// Controlador da feature Autenticacao.
///
/// Faz a mediacao entre a tela de login (`tela_login`) e a camada de modelo
/// (`DAOUsuario`). Todo o acesso a dados de autenticacao passa por este
/// controlador.
class ControladorAutenticacao extends ControladorBase {
  final DAOUsuario _daoUsuario = DAOUsuario();

  /// Autentica um usuario pelas credenciais informadas.
  Future<Map<String, dynamic>?> autenticar({
    required String email,
    required String senha,
  }) {
    return _daoUsuario.autenticar(email: email, senha: senha);
  }
}

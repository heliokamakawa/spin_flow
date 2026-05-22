import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_usuario.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';

/// Controlador da feature Recuperar Senha.
///
/// Faz a mediacao entre a tela de recuperacao de senha
/// (`tela_recuperar_senha`) e a camada de modelo (`DAOUsuario`, `DAOAluno`).
class ControladorRecuperarSenha extends ControladorBase {
  final DAOUsuario _daoUsuario = DAOUsuario();
  final DAOAluno _daoAluno = DAOAluno();

  /// Busca um usuario ativo pelo e-mail.
  Future<Map<String, dynamic>?> buscarUsuarioPorEmailAtivo(String email) {
    return _daoUsuario.buscarPorEmailAtivo(email);
  }

  /// Busca um aluno ativo pelo e-mail.
  Future<DTOAluno?> buscarAlunoPorEmailAtivo(String email) {
    return _daoAluno.buscarPorEmailAtivo(email);
  }

  /// Busca um aluno pelo seu identificador.
  Future<DTOAluno?> buscarAlunoPorId(int id) {
    return _daoAluno.buscarPorId(id);
  }

  /// Atualiza a senha de um usuario.
  Future<int> atualizarSenha(int id, String novaSenha) {
    return _daoUsuario.atualizarSenha(id, novaSenha);
  }
}

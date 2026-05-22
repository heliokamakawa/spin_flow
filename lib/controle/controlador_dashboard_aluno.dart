import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_turma.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';

/// Controlador da feature Dashboard do Aluno.
///
/// Faz a mediacao entre a tela do painel do aluno (`tela_dashboard_aluno`)
/// e a camada de modelo (`DAOAluno`, `DAOCheckin`, `DAOTurma`).
class ControladorDashboardAluno extends ControladorBase {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOTurma _daoTurma = DAOTurma();

  /// Busca um aluno ativo pelo e-mail.
  Future<DTOAluno?> buscarAlunoPorEmailAtivo(String email) {
    return _daoAluno.buscarPorEmailAtivo(email);
  }

  /// Busca os check-ins de um aluno.
  Future<List<DTOCheckin>> buscarCheckinsPorAluno(int alunoId) {
    return _daoCheckin.buscarPorAluno(alunoId);
  }

  /// Busca as turmas ativas.
  Future<List<DTOTurma>> buscarTurmasAtivas() {
    return _daoTurma.buscarAtivas();
  }
}

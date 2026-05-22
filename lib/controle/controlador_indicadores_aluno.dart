import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_checkin.dart';

/// Controlador da tela Indicadores Detalhados do Aluno.
class ControladorIndicadoresAluno extends ControladorBase {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOCheckin _daoCheckin = DAOCheckin();

  Future<DTOAluno?> buscarAlunoPorEmailAtivo(String email) {
    return _daoAluno.buscarPorEmailAtivo(email);
  }

  Future<List<DTOCheckin>> buscarCheckinsPorAluno(int alunoId) {
    return _daoCheckin.buscarPorAluno(alunoId);
  }
}

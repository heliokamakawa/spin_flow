import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_turma_mix.dart';
import 'package:spin_flow/modelo/dto/dto_turma_mix.dart';

/// Controlador da tela Mix da Turma do Aluno.
class ControladorMixTurmaAluno extends ControladorBase {
  final DAOTurmaMix _daoTurmaMix = DAOTurmaMix();

  Future<DTOTurmaMix?> buscarMixAtivoPorTurma(int turmaId, {DateTime? data}) {
    return _daoTurmaMix.buscarAtivoPorTurma(turmaId, data: data);
  }

  Future<List<DTOTurmaMix>> buscarMixesPorTurma(int turmaId) {
    return _daoTurmaMix.buscarPorTurma(turmaId);
  }
}

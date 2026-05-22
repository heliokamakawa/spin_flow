import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_manutencao.dart';
import 'package:spin_flow/modelo/dao/dao_posicao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_turma.dart';
import 'package:spin_flow/modelo/dao/dao_turma_mix.dart';
import 'package:spin_flow/modelo/dto/dto_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_posicao_bike.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';
import 'package:spin_flow/modelo/dto/dto_turma_mix.dart';

/// Controlador da tela Agenda do Aluno.
class ControladorAgendaAluno extends ControladorBase {
  final DAOTurma _daoTurma = DAOTurma();
  final DAOTurmaMix _daoTurmaMix = DAOTurmaMix();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();

  Future<List<DTOTurma>> buscarTurmasAtivas() {
    return _daoTurma.buscarAtivas();
  }

  Future<Set<int>> buscarBikeIdsEmManutencaoAtiva() {
    return _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
  }

  Future<List<DTOPosicaoBike>> buscarPosicoesPorBikeIds(Set<int> bikeIds) {
    return _daoPosicaoBike.buscarPorBikeIds(bikeIds);
  }

  Future<List<DTOCheckin>> buscarCheckinsAtivosPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) {
    return _daoCheckin.buscarAtivosPorTurmaData(turmaId: turmaId, data: data);
  }

  Future<DTOTurmaMix?> buscarMixAtivoPorTurma(int turmaId, {DateTime? data}) {
    return _daoTurmaMix.buscarAtivoPorTurma(turmaId, data: data);
  }
}

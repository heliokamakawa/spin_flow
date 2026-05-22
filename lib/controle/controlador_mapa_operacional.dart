import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_fila_espera_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_manutencao.dart';
import 'package:spin_flow/modelo/dao/dao_posicao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_turma.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_fila_espera_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_posicao_bike.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';

/// Controlador da tela Mapa Operacional (Professora).
///
/// Encapsula o acesso aos DAOs usados pela tela. Os metodos sao
/// delegacoes puras aos DAOs; a tela administra o proprio estado de loading.
class ControladorMapaOperacional extends ControladorBase {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOFilaEsperaCheckin _daoFila = DAOFilaEsperaCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();
  final DAOTurma _daoTurma = DAOTurma();

  Future<List<DTOTurma>> buscarTurmasAtivas() {
    return _daoTurma.buscarAtivas();
  }

  Future<List<DTOCheckin>> buscarCheckinsAtivosPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) {
    return _daoCheckin.buscarAtivosPorTurmaData(turmaId: turmaId, data: data);
  }

  Future<int> cancelarCheckin(int id) {
    return _daoCheckin.cancelar(id);
  }

  Future<Set<int>> buscarBikeIdsEmManutencaoAtiva() {
    return _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
  }

  Future<List<DTOPosicaoBike>> buscarPosicoesPorBikeIds(Set<int> bikeIds) {
    return _daoPosicaoBike.buscarPorBikeIds(bikeIds);
  }

  Future<List<DTOFilaEsperaCheckin>> buscarFilaEsperaAtivosPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) {
    return _daoFila.buscarAtivosPorTurmaData(turmaId: turmaId, data: data);
  }

  Future<int> sairDaFila(int id) {
    return _daoFila.sairDaFila(id);
  }

  Future<DTOAluno?> buscarAlunoPorId(int id) {
    return _daoAluno.buscarPorId(id);
  }
}

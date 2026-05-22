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

/// Controlador da tela Check-in do Aluno.
class ControladorCheckinAluno extends ControladorBase {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOTurma _daoTurma = DAOTurma();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();
  final DAOFilaEsperaCheckin _daoFilaEspera = DAOFilaEsperaCheckin();

  Future<List<DTOTurma>> buscarTurmasAtivas() {
    return _daoTurma.buscarAtivas();
  }

  Future<Set<int>> buscarBikeIdsEmManutencaoAtiva() {
    return _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
  }

  Future<List<DTOPosicaoBike>> buscarPosicoesPorBikeIds(Set<int> bikeIds) {
    return _daoPosicaoBike.buscarPorBikeIds(bikeIds);
  }

  Future<List<DTOPosicaoBike>> buscarTodasPosicoes() {
    return _daoPosicaoBike.buscarTodos();
  }

  Future<List<DTOCheckin>> buscarCheckinsAtivosPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) {
    return _daoCheckin.buscarAtivosPorTurmaData(turmaId: turmaId, data: data);
  }

  Future<List<DTOFilaEsperaCheckin>> buscarFilaAtivaPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) {
    return _daoFilaEspera.buscarAtivosPorTurmaData(turmaId: turmaId, data: data);
  }

  Future<bool> existeCheckinAtivoAluno({
    required int alunoId,
    required int turmaId,
    required DateTime data,
  }) {
    return _daoCheckin.existeCheckinAtivoAluno(
      alunoId: alunoId,
      turmaId: turmaId,
      data: data,
    );
  }

  Future<int> entrarNaFila({
    required int alunoId,
    required int turmaId,
    required DateTime data,
  }) {
    return _daoFilaEspera.entrarNaFila(
      alunoId: alunoId,
      turmaId: turmaId,
      data: data,
    );
  }

  Future<DTOAluno?> buscarAlunoPorEmailAtivo(String email) {
    return _daoAluno.buscarPorEmailAtivo(email);
  }
}

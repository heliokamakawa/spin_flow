import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_fila_espera_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_manutencao.dart';
import 'package:spin_flow/modelo/dao/dao_posicao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_turma_mix.dart';
import 'package:spin_flow/modelo/dao/dao_usuario.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_fila_espera_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_posicao_bike.dart';
import 'package:spin_flow/modelo/dto/dto_turma_mix.dart';

/// Controlador da tela Mapa de Check-in.
class ControladorMapaCheckin extends ControladorBase {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();
  final DAOTurmaMix _daoTurmaMix = DAOTurmaMix();
  final DAOUsuario _daoUsuario = DAOUsuario();
  final DAOFilaEsperaCheckin _daoFilaEspera = DAOFilaEsperaCheckin();

  Future<DTOAluno?> buscarAlunoPorEmailAtivo(String email) {
    return _daoAluno.buscarPorEmailAtivo(email);
  }

  Future<List<DTOCheckin>> buscarCheckinsAtivosPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) {
    return _daoCheckin.buscarAtivosPorTurmaData(turmaId: turmaId, data: data);
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

  Future<DTOTurmaMix?> buscarMixAtivoPorTurma(int turmaId, {DateTime? data}) {
    return _daoTurmaMix.buscarAtivoPorTurma(turmaId, data: data);
  }

  Future<Map<String, dynamic>?> buscarPrimeiraProfessoraAtiva() {
    return _daoUsuario.buscarPrimeiraProfessoraAtiva();
  }

  Future<List<DTOFilaEsperaCheckin>> buscarFilaAtivaPorTurmaData({
    required int turmaId,
    required DateTime data,
  }) {
    return _daoFilaEspera.buscarAtivosPorTurmaData(turmaId: turmaId, data: data);
  }

  Future<int> reservarComValidacao(DTOCheckin item) {
    return _daoCheckin.reservarComValidacao(item);
  }

  Future<int> cancelarCheckin(int id) {
    return _daoCheckin.cancelar(id);
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
}

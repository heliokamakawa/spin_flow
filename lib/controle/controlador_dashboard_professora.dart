import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_manutencao.dart';
import 'package:spin_flow/modelo/dao/dao_mix.dart';
import 'package:spin_flow/modelo/dao/dao_turma.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_bike.dart';
import 'package:spin_flow/modelo/dto/dto_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_mix.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';

/// Controlador da feature Dashboard da Professora.
///
/// Faz a mediacao entre a tela do dashboard da professora
/// (`tela_dashboard_professora`) e a camada de modelo (`DAOAluno`,
/// `DAOBike`, `DAOCheckin`, `DAOManutencao`, `DAOMix`, `DAOTurma`).
class ControladorDashboardProfessora extends ControladorBase {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOBike _daoBike = DAOBike();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOMix _daoMix = DAOMix();
  final DAOTurma _daoTurma = DAOTurma();

  /// Busca todos os alunos.
  Future<List<DTOAluno>> buscarTodosAlunos() {
    return _daoAluno.buscarTodos();
  }

  /// Busca todas as turmas.
  Future<List<DTOTurma>> buscarTodasTurmas() {
    return _daoTurma.buscarTodos();
  }

  /// Busca todos os mixes.
  Future<List<DTOMix>> buscarTodosMixes() {
    return _daoMix.buscarTodos();
  }

  /// Busca todas as bikes.
  Future<List<DTOBike>> buscarTodasBikes() {
    return _daoBike.buscarTodos();
  }

  /// Busca os ids das bikes em manutencao ativa.
  Future<Set<int>> buscarBikeIdsEmManutencaoAtiva() {
    return _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
  }

  /// Busca todos os check-ins.
  Future<List<DTOCheckin>> buscarTodosCheckins() {
    return _daoCheckin.buscarTodos();
  }
}

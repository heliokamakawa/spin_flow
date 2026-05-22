import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_manutencao.dart';
import 'package:spin_flow/modelo/dao/dao_turma.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_bike.dart';
import 'package:spin_flow/modelo/dto/dto_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';

/// Controlador da tela Relatorios Gerenciais (Professora).
///
/// Encapsula o acesso aos DAOs usados pela tela. Os metodos sao
/// delegacoes puras aos DAOs; a tela administra o proprio estado de loading.
class ControladorRelatoriosProfessora extends ControladorBase {
  final DAOAluno _daoAluno = DAOAluno();
  final DAOBike _daoBike = DAOBike();
  final DAOCheckin _daoCheckin = DAOCheckin();
  final DAOManutencao _daoManutencao = DAOManutencao();
  final DAOTurma _daoTurma = DAOTurma();

  Future<List<DTOAluno>> buscarTodosAlunos() {
    return _daoAluno.buscarTodos();
  }

  Future<List<DTOBike>> buscarTodasBikes() {
    return _daoBike.buscarTodos();
  }

  Future<Set<int>> buscarBikeIdsEmManutencaoAtiva() {
    return _daoManutencao.buscarBikeIdsEmManutencaoAtiva();
  }

  Future<List<DTOTurma>> buscarTodasTurmas() {
    return _daoTurma.buscarTodos();
  }

  Future<List<DTOCheckin>> buscarTodosCheckins() {
    return _daoCheckin.buscarTodos();
  }
}

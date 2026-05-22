import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_checkin.dart';
import 'package:spin_flow/modelo/dao/dao_turma.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_checkin.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';

/// Controlador da feature Checkin.
///
/// Faz a mediacao entre a camada de visao (`form_checkin`, `lista_checkins`) e
/// a camada de modelo. Encapsula o `DAOCheckin` e os DAOs auxiliares
/// (`DAOAluno`, `DAOTurma`) usados para carregar as opcoes de dropdown do
/// formulario. Toda a persistencia da feature passa por este controlador.
class ControladorCheckin extends ControladorBase {
  final DAOCheckin _dao = DAOCheckin();
  final DAOAluno _daoAluno = DAOAluno();
  final DAOTurma _daoTurma = DAOTurma();

  List<DTOCheckin> _checkins = <DTOCheckin>[];

  /// Check-ins carregados na ultima chamada a [listar].
  List<DTOCheckin> get checkins => List.unmodifiable(_checkins);

  /// Carrega todos os check-ins.
  Future<List<DTOCheckin>> listar() async {
    definirCarregando(true);
    try {
      _checkins = await _dao.buscarTodos();
      return _checkins;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca um check-in pelo seu identificador.
  Future<DTOCheckin?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) um check-in.
  Future<int> salvar(DTOCheckin checkin) {
    return _dao.salvar(checkin);
  }

  /// Reserva um check-in aplicando todas as validacoes de negocio.
  Future<int> reservarComValidacao(DTOCheckin checkin) {
    return _dao.reservarComValidacao(checkin);
  }

  /// Cancela um check-in pelo seu identificador.
  Future<int> cancelar(int id) {
    return _dao.cancelar(id);
  }

  /// Exclui (logicamente / cancela) um check-in pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Carrega os alunos disponiveis para o dropdown do formulario.
  Future<List<DTOAluno>> listarAlunos() {
    return _daoAluno.buscarTodos();
  }

  /// Carrega as turmas disponiveis para o dropdown do formulario.
  Future<List<DTOTurma>> listarTurmas() {
    return _daoTurma.buscarTodos();
  }
}

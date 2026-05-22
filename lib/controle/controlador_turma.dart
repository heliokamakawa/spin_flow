import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_sala.dart';
import 'package:spin_flow/modelo/dao/dao_turma.dart';
import 'package:spin_flow/modelo/dto/dto_sala.dart';
import 'package:spin_flow/modelo/dto/dto_turma.dart';

/// Controlador da feature Turma.
///
/// Faz a mediacao entre a camada de visao (`form_turma`, `lista_turmas`) e a
/// camada de modelo. Encapsula o `DAOTurma` e tambem o DAO auxiliar
/// (`DAOSala`) usado para carregar as opcoes de dropdown do formulario.
class ControladorTurma extends ControladorBase {
  final DAOTurma _dao = DAOTurma();
  final DAOSala _daoSala = DAOSala();

  List<DTOTurma> _turmas = <DTOTurma>[];

  /// Turmas carregadas na ultima chamada a [listar].
  List<DTOTurma> get turmas => List.unmodifiable(_turmas);

  /// Carrega todas as turmas.
  Future<List<DTOTurma>> listar() async {
    definirCarregando(true);
    try {
      _turmas = await _dao.buscarTodos();
      return _turmas;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca uma turma pelo seu identificador.
  Future<DTOTurma?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) uma turma.
  Future<int> salvar(DTOTurma turma) {
    return _dao.salvar(turma);
  }

  /// Exclui (logicamente) uma turma pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Lista as salas para preencher o dropdown do formulario.
  Future<List<DTOSala>> listarSalas() {
    return _daoSala.buscarTodos();
  }
}

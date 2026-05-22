import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dao/dao_grupo_alunos.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_grupo_alunos.dart';

/// Controlador da feature Grupo de Alunos.
///
/// Faz a mediacao entre a camada de visao (`form_grupo_alunos`,
/// `lista_grupos_alunos`) e a camada de modelo. Encapsula o `DAOGrupoAlunos`
/// e o `DAOAluno` auxiliar usado para popular a busca de alunos.
class ControladorGrupoAlunos extends ControladorBase {
  final DAOGrupoAlunos _dao = DAOGrupoAlunos();
  final DAOAluno _daoAluno = DAOAluno();

  List<DTOGrupoAlunos> _grupos = <DTOGrupoAlunos>[];

  /// Grupos carregados na ultima chamada a [listar].
  List<DTOGrupoAlunos> get grupos => List.unmodifiable(_grupos);

  /// Carrega todos os grupos de alunos.
  Future<List<DTOGrupoAlunos>> listar() async {
    definirCarregando(true);
    try {
      _grupos = await _dao.buscarTodos();
      return _grupos;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca um grupo de alunos pelo seu identificador.
  Future<DTOGrupoAlunos?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) um grupo de alunos.
  Future<int> salvar(DTOGrupoAlunos grupo) {
    return _dao.salvar(grupo);
  }

  /// Exclui (logicamente) um grupo de alunos pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Carrega todos os alunos (DAO auxiliar) para a busca multipla.
  Future<List<DTOAluno>> listarAlunos() {
    return _daoAluno.buscarTodos();
  }
}

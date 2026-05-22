import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_aluno.dart';
import 'package:spin_flow/modelo/dto/dto_aluno.dart';

/// Controlador da feature Aluno.
///
/// Faz a mediacao entre a camada de visao (`form_aluno`, `lista_alunos`) e a
/// camada de modelo (`DAOAluno`). Toda a persistencia da feature passa por
/// este controlador.
class ControladorAluno extends ControladorBase {
  final DAOAluno _dao = DAOAluno();

  List<DTOAluno> _alunos = <DTOAluno>[];

  /// Alunos carregados na ultima chamada a [listar].
  List<DTOAluno> get alunos => List.unmodifiable(_alunos);

  /// Carrega todos os alunos.
  Future<List<DTOAluno>> listar() async {
    definirCarregando(true);
    try {
      _alunos = await _dao.buscarTodos();
      return _alunos;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca um aluno pelo seu identificador.
  Future<DTOAluno?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) um aluno.
  Future<int> salvar(DTOAluno aluno) {
    return _dao.salvar(aluno);
  }

  /// Exclui (logicamente) um aluno pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }
}

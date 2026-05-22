import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_fabricante.dart';
import 'package:spin_flow/modelo/dto/dto_fabricante.dart';

/// Controlador da feature Fabricante.
///
/// Faz a mediacao entre a camada de visao (`form_fabricante`,
/// `lista_fabricantes`) e a camada de modelo (`DAOFabricante`). Toda a
/// persistencia da feature passa por este controlador.
class ControladorFabricante extends ControladorBase {
  final DAOFabricante _dao = DAOFabricante();

  List<DTOFabricante> _fabricantes = <DTOFabricante>[];

  /// Fabricantes carregados na ultima chamada a [listar].
  List<DTOFabricante> get fabricantes => List.unmodifiable(_fabricantes);

  /// Carrega todos os fabricantes.
  Future<List<DTOFabricante>> listar() async {
    definirCarregando(true);
    try {
      _fabricantes = await _dao.buscarTodos();
      return _fabricantes;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca um fabricante pelo seu identificador.
  Future<DTOFabricante?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) um fabricante.
  Future<int> salvar(DTOFabricante fabricante) {
    return _dao.salvar(fabricante);
  }

  /// Exclui (logicamente) um fabricante pelo seu identificador.
  Future<void> excluir(int id) {
    return _dao.excluir(id);
  }
}

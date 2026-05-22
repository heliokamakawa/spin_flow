import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_tipo_manutencao.dart';
import 'package:spin_flow/modelo/dto/dto_tipo_manutencao.dart';

/// Controlador da feature Tipo de Manutenção.
class ControladorTipoManutencao extends ControladorBase {
  final DAOTipoManutencao _dao = DAOTipoManutencao();

  List<DTOTipoManutencao> _tipos = <DTOTipoManutencao>[];

  List<DTOTipoManutencao> get tipos => List.unmodifiable(_tipos);

  Future<List<DTOTipoManutencao>> listar() async {
    definirCarregando(true);
    try {
      _tipos = await _dao.buscarTodos();
      return _tipos;
    } finally {
      definirCarregando(false);
    }
  }

  Future<DTOTipoManutencao?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  Future<int> salvar(DTOTipoManutencao tipo) {
    return _dao.salvar(tipo);
  }

  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }
}

import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_fabricante.dart';
import 'package:spin_flow/modelo/dto/dto_bike.dart';
import 'package:spin_flow/modelo/dto/dto_fabricante.dart';

/// Controlador da feature Bike.
///
/// Faz a mediacao entre a camada de visao (`form_bike`, `lista_bikes`) e a
/// camada de modelo. Encapsula o `DAOBike` e o `DAOFabricante` auxiliar
/// usado para popular o dropdown de fabricantes.
class ControladorBike extends ControladorBase {
  final DAOBike _dao = DAOBike();
  final DAOFabricante _daoFabricante = DAOFabricante();

  List<DTOBike> _bikes = <DTOBike>[];

  /// Bikes carregadas na ultima chamada a [listar].
  List<DTOBike> get bikes => List.unmodifiable(_bikes);

  /// Carrega todas as bikes.
  Future<List<DTOBike>> listar() async {
    definirCarregando(true);
    try {
      _bikes = await _dao.buscarTodos();
      return _bikes;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca uma bike pelo seu identificador.
  Future<DTOBike?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) uma bike.
  Future<int> salvar(DTOBike bike) {
    return _dao.salvar(bike);
  }

  /// Exclui (logicamente) uma bike pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Carrega todos os fabricantes (DAO auxiliar) para o dropdown.
  Future<List<DTOFabricante>> listarFabricantes() {
    return _daoFabricante.buscarTodos();
  }
}

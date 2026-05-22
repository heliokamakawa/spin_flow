import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_manutencao.dart';
import 'package:spin_flow/modelo/dao/dao_tipo_manutencao.dart';
import 'package:spin_flow/modelo/dto/dto_bike.dart';
import 'package:spin_flow/modelo/dto/dto_manutencao.dart';
import 'package:spin_flow/modelo/dto/dto_tipo_manutencao.dart';

/// Controlador da feature Manutencao.
///
/// Faz a mediacao entre a camada de visao (`form_manutencao`,
/// `lista_manutencoes`) e a camada de modelo. Encapsula o `DAOManutencao` e os
/// DAOs auxiliares (`DAOBike`, `DAOTipoManutencao`) usados para carregar as
/// opcoes de dropdown do formulario. Toda a persistencia da feature passa por
/// este controlador.
class ControladorManutencao extends ControladorBase {
  final DAOManutencao _dao = DAOManutencao();
  final DAOBike _daoBike = DAOBike();
  final DAOTipoManutencao _daoTipo = DAOTipoManutencao();

  List<DTOManutencao> _manutencoes = <DTOManutencao>[];

  /// Manutencoes carregadas na ultima chamada a [listar].
  List<DTOManutencao> get manutencoes => List.unmodifiable(_manutencoes);

  /// Carrega todas as manutencoes.
  Future<List<DTOManutencao>> listar() async {
    definirCarregando(true);
    try {
      _manutencoes = await _dao.buscarTodos();
      return _manutencoes;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca uma manutencao pelo seu identificador.
  Future<DTOManutencao?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) uma manutencao.
  Future<int> salvar(DTOManutencao manutencao) {
    return _dao.salvar(manutencao);
  }

  /// Exclui (logicamente) uma manutencao pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Carrega as bikes disponiveis para o dropdown do formulario.
  Future<List<DTOBike>> listarBikes() {
    return _daoBike.buscarTodos();
  }

  /// Carrega os tipos de manutencao disponiveis para o dropdown do formulario.
  Future<List<DTOTipoManutencao>> listarTiposManutencao() {
    return _daoTipo.buscarTodos();
  }
}

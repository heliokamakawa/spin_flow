import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_posicao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_sala.dart';
import 'package:spin_flow/modelo/dto/dto_posicao_bike.dart';
import 'package:spin_flow/modelo/dto/dto_sala.dart';

/// Controlador da feature Sala.
///
/// Faz a mediacao entre a camada de visao (`form_sala`, `lista_salas`) e a
/// camada de modelo. Encapsula o `DAOSala` e o `DAOPosicaoBike` auxiliar
/// usado para validar a grade de posicoes de bike.
class ControladorSala extends ControladorBase {
  final DAOSala _dao = DAOSala();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();

  List<DTOSala> _salas = <DTOSala>[];

  /// Salas carregadas na ultima chamada a [listar].
  List<DTOSala> get salas => List.unmodifiable(_salas);

  /// Carrega todas as salas.
  Future<List<DTOSala>> listar() async {
    definirCarregando(true);
    try {
      _salas = await _dao.buscarTodos();
      return _salas;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca uma sala pelo seu identificador.
  Future<DTOSala?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) uma sala.
  Future<int> salvar(DTOSala sala) {
    return _dao.salvar(sala);
  }

  /// Exclui (logicamente) uma sala pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Carrega todas as posicoes de bike cadastradas (DAO auxiliar).
  Future<List<DTOPosicaoBike>> listarPosicoesBike() {
    return _daoPosicaoBike.buscarTodos();
  }
}

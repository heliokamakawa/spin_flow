import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_posicao_bike.dart';
import 'package:spin_flow/modelo/dao/dao_sala.dart';
import 'package:spin_flow/modelo/dto/dto_bike.dart';
import 'package:spin_flow/modelo/dto/dto_posicao_bike.dart';
import 'package:spin_flow/modelo/dto/dto_sala.dart';

/// Controlador da tela Posicionamento de Bikes.
///
/// Encapsula o acesso aos DAOs usados pela tela. Os metodos sao
/// delegacoes puras aos DAOs; a tela administra o proprio estado de loading.
class ControladorPosicionamentoBikes extends ControladorBase {
  final DAOBike _daoBike = DAOBike();
  final DAOPosicaoBike _daoPosicaoBike = DAOPosicaoBike();
  final DAOSala _daoSala = DAOSala();

  Future<List<DTOSala>> buscarTodasSalas() {
    return _daoSala.buscarTodos();
  }

  Future<List<DTOBike>> buscarTodasBikes() {
    return _daoBike.buscarTodos();
  }

  Future<List<DTOPosicaoBike>> buscarTodasPosicoes() {
    return _daoPosicaoBike.buscarTodos();
  }

  Future<int> excluirPosicaoPorPosicao({
    required int fila,
    required int coluna,
  }) {
    return _daoPosicaoBike.excluirPorPosicao(fila: fila, coluna: coluna);
  }

  Future<int> salvarPosicao(DTOPosicaoBike item) {
    return _daoPosicaoBike.salvar(item);
  }
}

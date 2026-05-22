import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_video_aula.dart';
import 'package:spin_flow/modelo/dto/dto_video_aula.dart';

/// Controlador da feature Video-aula.
class ControladorVideoAula extends ControladorBase {
  final DAOVideoAula _dao = DAOVideoAula();

  List<DTOVideoAula> _videoAulas = <DTOVideoAula>[];

  List<DTOVideoAula> get videoAulas => List.unmodifiable(_videoAulas);

  Future<List<DTOVideoAula>> listar() async {
    definirCarregando(true);
    try {
      _videoAulas = await _dao.buscarTodos();
      return _videoAulas;
    } finally {
      definirCarregando(false);
    }
  }

  Future<DTOVideoAula?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  Future<int> salvar(DTOVideoAula item) {
    return _dao.salvar(item);
  }

  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }
}

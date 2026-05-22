import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_categoria_musica.dart';
import 'package:spin_flow/modelo/dto/dto_categoria_musica.dart';

/// Controlador da feature Categoria de Música.
class ControladorCategoriaMusica extends ControladorBase {
  final DAOCategoriaMusica _dao = DAOCategoriaMusica();

  List<DTOCategoriaMusica> _categorias = <DTOCategoriaMusica>[];

  List<DTOCategoriaMusica> get categorias => List.unmodifiable(_categorias);

  Future<List<DTOCategoriaMusica>> listar() async {
    definirCarregando(true);
    try {
      _categorias = await _dao.buscarTodos();
      return _categorias;
    } finally {
      definirCarregando(false);
    }
  }

  Future<DTOCategoriaMusica?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  Future<int> salvar(DTOCategoriaMusica categoria) {
    return _dao.salvar(categoria);
  }

  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }
}

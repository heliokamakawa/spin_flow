import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_artista_banda.dart';
import 'package:spin_flow/modelo/dto/dto_artista_banda.dart';

/// Controlador da feature Artista/Banda.
class ControladorArtistaBanda extends ControladorBase {
  final DAOArtistaBanda _dao = DAOArtistaBanda();

  List<DTOArtistaBanda> _artistas = <DTOArtistaBanda>[];

  List<DTOArtistaBanda> get artistas => List.unmodifiable(_artistas);

  Future<List<DTOArtistaBanda>> listar() async {
    definirCarregando(true);
    try {
      _artistas = await _dao.buscarTodos();
      return _artistas;
    } finally {
      definirCarregando(false);
    }
  }

  Future<DTOArtistaBanda?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  Future<int> salvar(DTOArtistaBanda artista) {
    return _dao.salvar(artista);
  }

  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }
}

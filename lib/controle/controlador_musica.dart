import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_artista_banda.dart';
import 'package:spin_flow/modelo/dao/dao_categoria_musica.dart';
import 'package:spin_flow/modelo/dao/dao_musica.dart';
import 'package:spin_flow/modelo/dto/dto_artista_banda.dart';
import 'package:spin_flow/modelo/dto/dto_categoria_musica.dart';
import 'package:spin_flow/modelo/dto/dto_musica.dart';

/// Controlador da feature Musica.
///
/// Faz a mediacao entre a camada de visao (`form_musica`, `lista_musicas`) e a
/// camada de modelo. Encapsula o `DAOMusica` e tambem os DAOs auxiliares
/// (`DAOArtistaBanda`, `DAOCategoriaMusica`) usados para carregar as opcoes de
/// dropdown do formulario.
class ControladorMusica extends ControladorBase {
  final DAOMusica _dao = DAOMusica();
  final DAOArtistaBanda _daoArtista = DAOArtistaBanda();
  final DAOCategoriaMusica _daoCategoria = DAOCategoriaMusica();

  List<DTOMusica> _musicas = <DTOMusica>[];

  /// Musicas carregadas na ultima chamada a [listar].
  List<DTOMusica> get musicas => List.unmodifiable(_musicas);

  /// Carrega todas as musicas.
  Future<List<DTOMusica>> listar() async {
    definirCarregando(true);
    try {
      _musicas = await _dao.buscarTodos();
      return _musicas;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca uma musica pelo seu identificador.
  Future<DTOMusica?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) uma musica.
  Future<int> salvar(DTOMusica musica) {
    return _dao.salvar(musica);
  }

  /// Exclui (logicamente) uma musica pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Lista os artistas/bandas para preencher o dropdown do formulario.
  Future<List<DTOArtistaBanda>> listarArtistas() {
    return _daoArtista.buscarTodos();
  }

  /// Lista as categorias de musica para preencher o dropdown do formulario.
  Future<List<DTOCategoriaMusica>> listarCategorias() {
    return _daoCategoria.buscarTodos();
  }
}

import 'package:spin_flow/core/base/controlador_base.dart';
import 'package:spin_flow/modelo/dao/dao_mix.dart';
import 'package:spin_flow/modelo/dao/dao_musica.dart';
import 'package:spin_flow/modelo/dto/dto_mix.dart';
import 'package:spin_flow/modelo/dto/dto_musica.dart';

/// Controlador da feature Mix.
///
/// Faz a mediacao entre a camada de visao (`form_mix`, `lista_mixes`) e a
/// camada de modelo. Encapsula o `DAOMix` e tambem o DAO auxiliar
/// (`DAOMusica`) usado para carregar as opcoes de dropdown do formulario.
class ControladorMix extends ControladorBase {
  final DAOMix _dao = DAOMix();
  final DAOMusica _daoMusica = DAOMusica();

  List<DTOMix> _mixes = <DTOMix>[];

  /// Mixes carregados na ultima chamada a [listar].
  List<DTOMix> get mixes => List.unmodifiable(_mixes);

  /// Carrega todos os mixes.
  Future<List<DTOMix>> listar() async {
    definirCarregando(true);
    try {
      _mixes = await _dao.buscarTodos();
      return _mixes;
    } finally {
      definirCarregando(false);
    }
  }

  /// Busca um mix pelo seu identificador.
  Future<DTOMix?> buscarPorId(int id) {
    return _dao.buscarPorId(id);
  }

  /// Salva (insere ou atualiza) um mix.
  Future<int> salvar(DTOMix mix) {
    return _dao.salvar(mix);
  }

  /// Exclui (logicamente) um mix pelo seu identificador.
  Future<int> excluir(int id) {
    return _dao.excluir(id);
  }

  /// Lista as musicas para preencher o dropdown do formulario.
  Future<List<DTOMusica>> listarMusicas() {
    return _daoMusica.buscarTodos();
  }
}

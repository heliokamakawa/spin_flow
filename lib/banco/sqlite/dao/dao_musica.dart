import 'dart:convert';

import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_artista_banda.dart';
import 'package:spin_flow/dto/dto_categoria_musica.dart';
import 'package:spin_flow/dto/dto_musica.dart';
import 'package:spin_flow/dto/dto_video_aula.dart';

import 'dao_artista_banda.dart';
import 'dao_categoria_musica.dart';
import 'dao_video_aula.dart';

class DAOMusica {
  static const String _tabela = 'musica';

  final DAOArtistaBanda _daoArtista = DAOArtistaBanda();
  final DAOCategoriaMusica _daoCategoria = DAOCategoriaMusica();
  final DAOVideoAula _daoVideoAula = DAOVideoAula();

  Future<int> salvar(DTOMusica item) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': item.nome,
      'artista_id': item.artista.id,
      'categoria_ids': jsonEncode(item.categorias.map((c) => c.id).whereType<int>().toList()),
      'video_aula_ids': jsonEncode(item.linksVideoAula.map((v) => v.id).whereType<int>().toList()),
      'descricao': item.descricao,
      'ativo': item.ativo ? 1 : 0,
    };

    if (item.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [item.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOMusica>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOMusica> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<DTOMusica?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return _mapParaDTO(maps.first);
  }

  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return db.update(
      _tabela,
      {'ativo': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<DTOMusica> _mapParaDTO(Map<String, dynamic> map) async {
    final artistaId = _toInt(map['artista_id']);
    final artista = artistaId != null ? await _daoArtista.buscarPorId(artistaId) : null;

    final categorias = <DTOCategoriaMusica>[];
    for (final id in _parseIds((map['categoria_ids'] as String?) ?? '[]')) {
      final categoria = await _daoCategoria.buscarPorId(id);
      if (categoria != null) categorias.add(categoria);
    }

    final videos = <DTOVideoAula>[];
    for (final id in _parseIds((map['video_aula_ids'] as String?) ?? '[]')) {
      final video = await _daoVideoAula.buscarPorId(id);
      if (video != null) videos.add(video);
    }

    return DTOMusica(
      id: _toInt(map['id']),
      nome: (map['nome'] as String?) ?? '',
      artista: artista ?? DTOArtistaBanda(nome: '', descricao: '', link: '', foto: ''),
      categorias: categorias,
      linksVideoAula: videos,
      descricao: (map['descricao'] as String?) ?? '',
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
  }

  List<int> _parseIds(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) {
        return decoded.whereType<num>().map((e) => e.toInt()).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}


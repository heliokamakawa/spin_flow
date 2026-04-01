import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/dto/dto_manutencao.dart';
import 'package:spin_flow/dto/dto_tipo_manutencao.dart';

import 'dao_bike.dart';
import 'dao_tipo_manutencao.dart';

class DAOManutencao {
  static const String _tabela = 'manutencao';
  final DAOBike _daoBike = DAOBike();
  final DAOTipoManutencao _daoTipo = DAOTipoManutencao();

  Future<int> salvar(DTOManutencao item) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'bike_id': item.bike.id,
      'tipo_manutencao_id': item.tipoManutencao.id,
      'data_solicitacao': item.dataSolicitacao.toIso8601String(),
      'data_realizacao': item.dataRealizacao.toIso8601String(),
      'descricao': item.descricao,
      'ativo': item.ativo ? 1 : 0,
    };

    if (item.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [item.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOManutencao>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOManutencao> itens = [];
    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }
    return itens;
  }

  Future<Set<int>> buscarBikeIdsEmManutencaoAtiva() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(
      _tabela,
      columns: ['bike_id'],
      where: 'ativo = 1',
    );
    final Set<int> ids = {};
    for (final map in maps) {
      final bikeId = _toInt(map['bike_id']);
      if (bikeId != null) ids.add(bikeId);
    }
    return ids;
  }

  Future<DTOManutencao?> buscarPorId(int id) async {
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

  Future<DTOManutencao> _mapParaDTO(Map<String, dynamic> map) async {
    final bikeId = _toInt(map['bike_id']);
    final tipoId = _toInt(map['tipo_manutencao_id']);

    final bike = bikeId != null ? await _daoBike.buscarPorId(bikeId) : null;
    final tipo = tipoId != null ? await _daoTipo.buscarPorId(tipoId) : null;

    return DTOManutencao(
      id: _toInt(map['id']),
      bike: bike ?? DTOBike(nome: '', numeroSerie: '', fabricante: DTOFabricante(nome: ''), dataCadastro: DateTime.now()),
      tipoManutencao: tipo ?? DTOTipoManutencao(nome: ''),
      dataSolicitacao: DateTime.tryParse((map['data_solicitacao'] as String?) ?? '') ?? DateTime.now(),
      dataRealizacao: DateTime.tryParse((map['data_realizacao'] as String?) ?? '') ?? DateTime.now(),
      descricao: (map['descricao'] as String?) ?? '',
      ativo: ((map['ativo'] as int?) ?? 1) == 1,
    );
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}


import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';

import 'dao_fabricante.dart';

class DAOBike {
  static const String _tabela = 'bike';
  final DAOFabricante _daoFabricante = DAOFabricante();

  Future<int> salvar(DTOBike bike) async {
    final db = await ConexaoSQLite.database;
    final dados = {
      'nome': bike.nome,
      'numero_serie': bike.numeroSerie,
      'fabricante_id': bike.fabricante.id,
      'data_cadastro': bike.dataCadastro.toIso8601String(),
      'ativa': bike.ativa ? 1 : 0,
    };

    if (bike.id != null) {
      return db.update(_tabela, dados, where: 'id = ?', whereArgs: [bike.id]);
    }

    return db.insert(_tabela, dados);
  }

  Future<List<DTOBike>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOBike> itens = [];

    for (final map in maps) {
      itens.add(await _mapParaDTO(map));
    }

    return itens;
  }

  Future<DTOBike?> buscarPorId(int id) async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela, where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return _mapParaDTO(maps.first);
  }

  Future<int> excluir(int id) async {
    final db = await ConexaoSQLite.database;
    return db.update(
      _tabela,
      {'ativa': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<DTOBike> _mapParaDTO(Map<String, dynamic> map) async {
    final fabricanteId = _toInt(map['fabricante_id']);
    final fabricante = fabricanteId != null
        ? await _daoFabricante.buscarPorId(fabricanteId)
        : null;

    return DTOBike(
      id: _toInt(map['id']),
      nome: (map['nome'] as String?) ?? '',
      numeroSerie: (map['numero_serie'] as String?) ?? '',
      fabricante: fabricante ?? DTOFabricante(id: fabricanteId, nome: ''),
      dataCadastro: DateTime.tryParse((map['data_cadastro'] as String?) ?? '') ?? DateTime.now(),
      ativa: ((map['ativa'] as int?) ?? 1) == 1,
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


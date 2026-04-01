import 'package:sqflite/sqflite.dart';
import 'package:spin_flow/banco/sqlite/conexao.dart';
import 'package:spin_flow/dto/dto_bike.dart';
import 'package:spin_flow/dto/dto_fabricante.dart';
import 'package:spin_flow/dto/dto_posicao_bike.dart';

import 'dao_bike.dart';

class DAOPosicaoBike {
  static const String _tabela = 'posicao_bike';
  final DAOBike _daoBike = DAOBike();

  Future<int> salvar(DTOPosicaoBike item) async {
    final db = await ConexaoSQLite.database;
    final bikeId = item.bike.id;
    if (bikeId == null) {
      throw Exception('Bike sem id nao pode ser posicionada.');
    }

    return db.transaction((txn) async {
      // Reposicionamento: uma bike ocupa apenas uma posicao e uma posicao recebe apenas uma bike.
      await txn.delete(
        _tabela,
        where: 'bike_id = ? OR (fila = ? AND coluna = ?)',
        whereArgs: [bikeId, item.fila, item.coluna],
      );

      return txn.insert(
        _tabela,
        {
          'fila': item.fila,
          'coluna': item.coluna,
          'bike_id': bikeId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<DTOPosicaoBike>> buscarTodos() async {
    final db = await ConexaoSQLite.database;
    final maps = await db.query(_tabela);
    final List<DTOPosicaoBike> itens = [];

    for (final map in maps) {
      final bikeId = _toInt(map['bike_id']);
      final bike = bikeId != null ? await _daoBike.buscarPorId(bikeId) : null;
      itens.add(
        DTOPosicaoBike(
          fila: _toInt(map['fila']) ?? 0,
          coluna: _toInt(map['coluna']) ?? 0,
          bike: bike ?? DTOBike(nome: '', numeroSerie: '', fabricante: DTOFabricante(nome: ''), dataCadastro: DateTime.now()),
        ),
      );
    }

    return itens;
  }

  Future<List<DTOPosicaoBike>> buscarPorBikeIds(Set<int> bikeIds) async {
    if (bikeIds.isEmpty) return [];
    final todos = await buscarTodos();
    return todos.where((p) => p.bike.id != null && bikeIds.contains(p.bike.id)).toList();
  }

  Future<int> excluir(DTOPosicaoBike item) async {
    final db = await ConexaoSQLite.database;
    return db.delete(
      _tabela,
      where: 'fila = ? AND coluna = ? AND bike_id = ?',
      whereArgs: [item.fila, item.coluna, item.bike.id],
    );
  }

  Future<int> excluirPorPosicao({required int fila, required int coluna}) async {
    final db = await ConexaoSQLite.database;
    return db.delete(
      _tabela,
      where: 'fila = ? AND coluna = ?',
      whereArgs: [fila, coluna],
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


import 'package:sqflite/sqflite.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/services/database_services/app_database.dart';
import 'package:tracking_app/models/encomenda.dart';

class EncomendaDao {

  static const tableSQL = "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, "
      "$nome TEXT, "
      "$codigo_rastreio TEXT, "
      "$ultimo_status TEXT, "
      "$finalizado TEXT)";

  static const tableName = "encomendas";

  static const id = "id";
  static const nome = "nome";
  static const codigo_rastreio = "codigo_rastreio";
  static const ultimo_status = "ultimo_status";
  static const finalizado = "finalizado";

  Future<int> save (Encomenda encomenda) async {
    Database db = await getDatabase();

    Map<String, dynamic> map = toMap(encomenda);

    Encomenda existente = null;
    if (encomenda.id != null){
      existente = await findById(encomenda.id);
    }

    if (existente == null) {
      return db.insert(tableName, map);
    } else {
      List<dynamic> whereArgs = List();
      whereArgs.add(encomenda.id);
      return db.update(tableName, map, where: "id = ?", whereArgs: whereArgs);
    }

  }

  Map<String, dynamic> toMap(Encomenda encomenda) {
    Map<String, dynamic> map = Map();
    map[id] = encomenda.id;
    map[nome] = encomenda.nome;
    map[codigo_rastreio] = encomenda.codigoRastreio;
    map[ultimo_status] = encomenda.ultimoStatus;
    map[finalizado] = Finalizado.S == encomenda.finalizado ? "S" : "N";
    return map;
  }

  Future<Encomenda> findById(int id) async {
    Database db = await getDatabase();

    List<dynamic> whereArgs = List();
    whereArgs.add(id);

    Encomenda m = null;
    var mapList = await db.query(tableName, where: "id = ?", whereArgs: whereArgs);
    mapList.forEach((row) {
      m = toEncomenda(row);
    });
    return m;
  }

  Future<List<Encomenda>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tableName);
    List<Encomenda> encomendaList = List();

    result.forEach((row) {
      encomendaList.add(
          toEncomenda(row)
      );
    });

    return encomendaList;
  }

  Encomenda toEncomenda(Map<String, dynamic> row) {
    return new Encomenda(
        row[id],
        row[nome],
        row[codigo_rastreio],
        row[ultimo_status],
        row[finalizado] == "S" ? Finalizado.S : Finalizado.N
    );
  }

}
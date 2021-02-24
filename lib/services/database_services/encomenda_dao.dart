import 'package:enum_to_string/enum_to_string.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/services/database_services/app_database.dart';
import 'package:tracking_app/models/encomenda.dart';

class EncomendaDao {

  static const tableSQL = "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, "
      "$nome TEXT, "
      "$codigo_rastreio TEXT, "
      "$cpf TEXT, "
      "$ultimo_status TEXT, "
      "$data_ultimo_status TEXT, "
      "$empresa TEXT, "
      "$data_finalizado TEXT, "
      "$ultima_atualizacao TEXT, "
      "$finalizado TEXT)";

  static const tableName = "encomendas";

  static const id = "id";
  static const nome = "nome";
  static const codigo_rastreio = "codigo_rastreio";
  static const cpf = "cpf";
  static const ultimo_status = "ultimo_status";
  static const data_ultimo_status = "data_ultimo_status";
  static const empresa = "empresa";
  static const data_finalizado = "data_finalizado";
  static const finalizado = "finalizado";
  static const ultima_atualizacao = "ultima_atualizacao";

  Future<Encomenda> save (Encomenda encomenda) async {
    Database db = await getDatabase();

    Map<String, dynamic> map = toMap(encomenda);

    Encomenda existente = null;
    if (encomenda.id != null){
      existente = await findById(encomenda.id);
    }
    // if (existente == null){
    //   existente = await findByCodigoRastreio(encomenda.codigoRastreio);
    // }

    if (existente == null) {
      int id = await db.insert(tableName, map);
      encomenda.id = id;
      return encomenda;
    } else {
      List<dynamic> whereArgs = List();
      whereArgs.add(encomenda.id);
      int numberOfRowsUpdated = await db.update(tableName, map, where: "id = ?", whereArgs: whereArgs);
      return encomenda;
    }

  }

  Map<String, dynamic> toMap(Encomenda encomenda) {
    Map<String, dynamic> map = Map();
    map[id] = encomenda.id;
    map[nome] = encomenda.nome;
    map[codigo_rastreio] = encomenda.codigoRastreio;
    map[ultimo_status] = encomenda.ultimoStatus;
    map[ultima_atualizacao] = encomenda.ultimaAtualizacao;
    map[finalizado] = Finalizado.S == encomenda.finalizado ? "S" : "N";
    map[cpf] = encomenda.cpf;
    map[data_finalizado] = encomenda.dataFinalizado;
    map[data_ultimo_status] = encomenda.dataUltimoStatus;
    map[empresa] = EnumToString.convertToString(encomenda.empresa);

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

  Future<Encomenda> findByCodigoRastreio(String codigo) async {
    Database db = await getDatabase();

    List<dynamic> whereArgs = List();
    whereArgs.add(codigo);

    Encomenda m = null;
    var mapList = await db.query(tableName, where: "codigo_rastreio = ?", whereArgs: whereArgs);
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

  Future<List<Encomenda>> findByStatus(Finalizado finalizado) async {
    final Database db = await getDatabase();

    List<dynamic> whereArgs = List();
    whereArgs.add(Finalizado.S == finalizado ? "S" : "N");

    final List<Map<String, dynamic>> result = await db.query(tableName, where: "finalizado = ?", whereArgs: whereArgs);
    List<Encomenda> encomendaList = List();

    result.forEach((row) {
      encomendaList.add(
          toEncomenda(row)
      );
    });

    return encomendaList;
  }

  Future<int> deleteById(int id) async {
    Database db = await getDatabase();

    List<dynamic> whereArgs = List();
    whereArgs.add(id);

    Encomenda m = null;
    int deleted = await db.delete(tableName, where: "id = ?", whereArgs: whereArgs);
    return deleted;
  }

  Encomenda toEncomenda(Map<String, dynamic> row) {
    Encomenda encomenda = new Encomenda(
        row[id],
        row[nome],
        row[codigo_rastreio],
        row[ultimo_status],
        row[finalizado] == "S" ? Finalizado.S : Finalizado.N,
        row[ultima_atualizacao],
        row[cpf]
    );
    encomenda.dataUltimoStatus = row[data_ultimo_status];
    encomenda.dataFinalizado = row[data_finalizado];
    encomenda.empresa = EnumToString.fromString(EmpresasDisponiveis.values, row[empresa]);
    return encomenda;
  }

}
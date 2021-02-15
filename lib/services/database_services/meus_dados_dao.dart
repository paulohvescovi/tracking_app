import 'package:sqflite/sqflite.dart';
import 'package:tracking_app/models/meus_dados.dart';
import 'package:tracking_app/services/database_services/app_database.dart';

class MeusDadosDao {

  static const tableSQL = "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, "
                                                   "$nome TEXT, "
                                                   "$email TEXT, "
                                                   "$cpf TEXT, "
                                                   "$permite_enviar_notificacoes INTEGER, "
                                                   "$permite_enviar_emails INTEGER)";
  static const tableName = "meus_dados";

  static const id = "id";
  static const nome = "nome";
  static const email = "email";
  static const cpf = "cpf";
  static const permite_enviar_notificacoes = "permite_enviar_notificacoes";
  static const permite_enviar_emails = "permite_enviar_emails";

  Future<int> save (MeusDados meusDados) async {
    Database db = await getDatabase();

    Map<String, dynamic> map = toMap(meusDados);

    return db.insert(tableName, map);
  }

  Map<String, dynamic> toMap(MeusDados meusDados) {
    Map<String, dynamic> map = Map();
    map[id] = meusDados.id;
    map[nome] = meusDados.nome;
    map[email] = meusDados.email;
    map[cpf] = meusDados.cpf;
    map[permite_enviar_notificacoes] = meusDados.enviarNotificacoes;
    map[permite_enviar_emails] = meusDados.enviarEmail;
    return map;
  }

  Future<MeusDados> findById() async {
    Database db = await getDatabase();

    List<dynamic> whereArgs;
    whereArgs.add(1);

    var mapList = await db.query(tableName, where: "id = ?", whereArgs: whereArgs);
    mapList.forEach((row) {
      return toMeusDados(row);
    });
    return null;
  }

  MeusDados toMeusDados(Map<String, dynamic> row) {
    return new MeusDados(
        1,
        row[nome],
        row[email],
        row[cpf],
        row[permite_enviar_notificacoes],
        row[permite_enviar_emails]
    );
  }

}
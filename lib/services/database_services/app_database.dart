import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracking_app/services/database_services/meus_dados_dao.dart';

import 'encomenda_dao.dart';

Future<Database> getDatabase() async {

  String path = join(await getDatabasesPath(), 'kurwarastreio.db');

  return openDatabase(path,
      onCreate: (db, version) {
        db.execute(MeusDadosDao.tableSQL);
        db.execute(EncomendaDao.tableSQL);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
          // if (oldVersion == 1){
          //       db.execute("ALTER TABLE meus_dados ADD manda TEXT");
          // }
      },
      version: 1);

}
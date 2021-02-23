import 'package:flutter/material.dart';
import 'package:tracking_app/components/progress_carregando.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';
import 'package:tracking_app/utils/date_utils.dart';

class EncomendasFinalizadasScreen extends StatefulWidget {
  @override
  _EncomendasFinalizadasScreenState createState() =>
      _EncomendasFinalizadasScreenState();
}

class _EncomendasFinalizadasScreenState
    extends State<EncomendasFinalizadasScreen> {

  EncomendaDao encomendaDao = new EncomendaDao();

  List<Encomenda> encomendaFinalizadaList = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encomendas finalizadas"),
      ),
      body: FutureBuilder<List<Encomenda>>(
          initialData: encomendaFinalizadaList,
          future: encomendaDao.findByStatus(Finalizado.S),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return ProgressBarCarregando();
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                encomendaFinalizadaList = snapshot.data;
                if (!encomendaFinalizadaList.isEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      Encomenda encomenda = encomendaFinalizadaList[index];
                      return Card(
                        child: ListTile(
                          title: Text(encomenda.nome+ " " + DateUtil.format(DateUtil.getDateTime(encomenda.dataUltimoStatus, DateUtil.PATTERN_REDESUL), DateUtil.PATTERN_DEFAULT)),
                          subtitle: Text(encomenda.ultimoStatus ),
                        ),
                      );
                    },
                    itemCount: encomendaFinalizadaList.length,
                  );
                } else {
                  return Text(
                    "Você ainda não tem nenhuma encomenda recebida",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black54
                    ),
                    textAlign: TextAlign.center,
                  );
                }
            }
          }
      ),
    );
  }
}

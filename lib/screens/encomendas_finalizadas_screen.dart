import 'package:flutter/material.dart';
import 'package:tracking_app/components/progress_carregando.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/screens/novo_rastreio_screen.dart';
import 'package:tracking_app/screens/rastrear_encomendas_screen.dart';
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
                          title: Text(encomenda.nome+ " " + encomenda.dataFinalizado),
                          subtitle: Text(encomenda.ultimoStatus ),
                        ),
                      );
                    },
                    itemCount: encomendaFinalizadaList.length,
                  );
                } else {
                  return ListView(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Nenhuma Encomenda",
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        color: Colors.black54
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Image.asset(
                                    'images/encomendas_vazias.png',
                                    width: 300,
                                  ),
                                  Text(
                                    "Você não tem nenhuma encomenda finalizada",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black54
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16, bottom: 16),
                                    child: SizedBox(
                                      width: 230,
                                      height: 60,
                                      child: RaisedButton(
                                        child: Text(
                                          "Cadastrar encomenda",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => NovoRastreioScreen(),
                                            ),
                                          ).then((novaEncomenda) => {
                                            if (novaEncomenda != null){
                                              direcionaPaginaDeAcompanhamento(context)
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
            }
          }
      ),
    );
  }

  direcionaPaginaDeAcompanhamento(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RastrearEncomendasScreen(),
      ),
    );
  }
}

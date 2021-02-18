import 'package:flutter/material.dart';
import 'package:tracking_app/components/progress_carregando.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/screens/novo_rastreio_screen.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';

import 'meus_dados_screen.dart';

class RastrearEncomendasScreen extends StatefulWidget {
  @override
  _RastrearEncomendasScreenState createState() =>
      _RastrearEncomendasScreenState();
}

class _RastrearEncomendasScreenState extends State<RastrearEncomendasScreen> {
  
  EncomendaDao encomendaDao = new EncomendaDao();
  
  List<Encomenda> encomendList = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rastrear"),
      ),
      body: FutureBuilder<List<Encomenda>>(
        initialData: encomendList,
        future: encomendaDao.findAll(),
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
               encomendList = snapshot.data;

              if (encomendList.isEmpty) {
                return Column(
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
                            Image.network(
                                "https://cdn1.iconfinder.com/data/icons/construction-blue-line/660/Empty_Box_Box_dropbox_empty_package_package-512.png"),
                            Text(
                              "Você ainda não cadastrou nenhuma encomenda para rastrear",
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
                                        recarregarLista
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
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Encomenda encomenda = encomendList[index];
                    return EncomendaItem(
                      encomenda,
                      onClick: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => TransactionForm(contact),
                        //   ),
                        // );
                      },
                    );
                  },
                  itemCount: encomendList.length,
                );
              }
              break;
          }
          return Text("Ocorreu um problema nesscarniça");
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NovoRastreioScreen(),
            ),
          ).then((novaEncomenda) => {
            recarregarLista()
          });
        },
      ),
    );
  }

  recarregarLista() {
    setState(() {

    });
  }
}

class EncomendaItem extends StatelessWidget {
  final Encomenda encomenda;
  final Function onClick;

  EncomendaItem(
    this.encomenda, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          encomenda.nome,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          encomenda.ultimoStatus,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tracking_app/components/progress_carregando.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/screens/novo_rastreio_screen.dart';
import 'package:tracking_app/services/api_services/redesul/redesul_client_service.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';

import 'meus_dados_screen.dart';

class RastrearEncomendasScreen extends StatefulWidget {
  @override
  _RastrearEncomendasScreenState createState() =>
      _RastrearEncomendasScreenState();
}

class _RastrearEncomendasScreenState extends State<RastrearEncomendasScreen> {
  
  EncomendaDao encomendaDao = new EncomendaDao();
  RedeSulClientService redeSulClientService = new RedeSulClientService();
  
  List<Encomenda> encomendList = List();
  ProgressDialog progressDialog;
  NAlertDialog alertDialog;

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
                                  width: 200,
                                ),
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
                                          recarregarLista(novaEncomenda)
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
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Encomenda encomenda = encomendList[index];
                    return EncomendaItem(
                        encomenda,
                        () {
                          //todo chamar tela de detalhes
                        },
                        () {
                          alertDialog = NAlertDialog(
                            title: Text("Deletar essa encomenda?"),
                            content: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(encomenda.nome),
                            ),
                            actions: [
                              FlatButton(
                                child: Text("Sim"),
                                onPressed: () {
                                  encomendaDao.deleteById(encomenda.id);
                                  Navigator.of(context).pop();
                                  setState(() {
                                    int indexOf = encomendList.indexOf(encomenda);
                                    encomendList.remove(encomenda);
                                  });
                                },
                              ),
                              FlatButton(
                                child: Text("Não"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                          alertDialog.show(context);
                        },
                        (Encomenda encomendaRefresh){
                          progressDialog = ProgressDialog(context,
                            message:Text("Atualizando encomenda"),
                            title:Text("Aguarde"),
                            // dismissable: false
                          );
                          progressDialog.show();

                          redeSulClientService.buscarEncomendaRedeSul(encomenda, (updated) {
                            progressDialog.dismiss();
                            setState(() {
                              int indexOf = encomendList.indexOf(encomenda);
                              encomendList.remove(encomenda);
                              encomendList.insert(indexOf, updated);
                            });
                          }, () {
                            progressDialog.dismiss();
                            //todo mostrar erro aqui
                          });
                        }
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
            recarregarLista(novaEncomenda)
          });
        },
      ),
    );
  }

  recarregarLista(novaEncomenda) {
    setState(() {
      if (novaEncomenda != null){
        encomendList.add(novaEncomenda);
      }
    });
  }
}

class EncomendaItem extends StatelessWidget {
  final Encomenda encomenda;
  final Function onClick;
  final Function onLongPress;
  final Function onRefresh;

  EncomendaItem(this.encomenda, this.onClick, this.onLongPress, this.onRefresh);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text(
                        encomenda.nome,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(top: 4)),
                      new Text(
                        "Cod Rastreio " + encomenda.codigoRastreio,
                        style: TextStyle(fontSize: 14),
                      ),
                      Padding(padding: EdgeInsets.only(top: 4)),
                      new Text(
                        "Ocorrência: " + encomenda.ultimoStatus,
                        style: TextStyle(fontSize: 14),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Visibility(
                        visible: encomenda.ultimaAtualizacao != null,
                        child: new Text(
                          "Detalhes: " + (encomenda.ultimaAtualizacao != null ? encomenda.ultimaAtualizacao : "Não informada"),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      new Text(
                        encomenda.ultimoStatus,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                tooltip: 'Buscando atualização da encomenda',
                onPressed: () {
                    onRefresh(encomenda);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

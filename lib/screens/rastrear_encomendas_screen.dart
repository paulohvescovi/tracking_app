import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tracking_app/components/progress_carregando.dart';
import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/screens/encomenda_detalhes_screen.dart';
import 'package:tracking_app/screens/novo_rastreio_screen.dart';
import 'package:tracking_app/services/api_services/correios/correios_client_service.dart';
import 'package:tracking_app/services/api_services/redesul/redesul_client_service.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';
import 'package:tracking_app/utils/date_utils.dart';

import 'meus_dados_screen.dart';

class RastrearEncomendasScreen extends StatefulWidget {
  @override
  _RastrearEncomendasScreenState createState() =>
      _RastrearEncomendasScreenState();
}

class _RastrearEncomendasScreenState extends State<RastrearEncomendasScreen> {
  
  EncomendaDao encomendaDao = new EncomendaDao();
  RedeSulClientService redeSulClientService = new RedeSulClientService();
  CorreioClientService correioClientService = new CorreioClientService();

  List<Encomenda> encomendList = List();
  ProgressDialog progressDialog;
  NAlertDialog alertDialog;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Encomendas rastreando"),
      ),
      body: FutureBuilder<List<Encomenda>>(
        initialData: encomendList,
        future: encomendaDao.findByStatus(Finalizado.N),
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
                                  width: 300,
                                ),
                                Text(
                                  "Você não tem nenhuma encomenda em rastreio no momento",
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
                          progressDialog = ProgressDialog(context,
                            message:Text("Buscando encomenda"),
                            title:Text("Aguarde"),
                            // dismissable: false
                          );
                          progressDialog.show();

                          buscarEncomenda(encomenda, (encomendaBuscada) {
                            if (encomendaBuscada != null){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EncomendaDetalhesScreen(encomendaBuscada),
                                ),
                              ).then((value) => {
                              });
                            } else {
                              //show mensagem erro aqui
                            }
                          });

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


                          buscarEncomenda(encomenda, (encomendaBuscada) {
                            if (encomendaBuscada != null){
                              setState(() {
                                int indexOf = encomendList.indexOf(encomenda);
                                encomendList.remove(encomenda);
                                encomendList.insert(indexOf, encomendaBuscada);
                              });
                            } else {
                              //show mensagem erro aqui
                            }
                          });

                        },
                        (){

                          alertDialog = NAlertDialog(
                            title: Text("Marcar a encomenda como recebida?"),
                            content: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(encomenda.nome),
                            ),
                            actions: [
                              FlatButton(
                                child: Text("Sim"),
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  encomenda.finalizado = Finalizado.S;
                                  encomenda.dataFinalizado = DateUtil.format(new DateTime.now(), DateUtil.PATTERN_DATETIME);
                                  encomendaDao.save(encomenda).then((value) => {
                                      setState(() {

                                      })
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

  void buscarEncomenda(Encomenda encomenda, Function onBuscada){
    if (EmpresasDisponiveis.REDESUL == encomenda.empresa){
      redeSulClientService.buscarEncomendaRedeSul(encomenda, (updated) {
        progressDialog.dismiss();
        onBuscada(updated);
      }, () {
        progressDialog.dismiss();
        onBuscada(null);
      });
    } else if (EmpresasDisponiveis.CORREIOS == encomenda.empresa){
      correioClientService.buscarEncomendaCorreios(encomenda, (updated) {
        progressDialog.dismiss();
        onBuscada(updated);
      }, () {
        progressDialog.dismiss();
        onBuscada(null);
      });
    }
  }
}

class EncomendaItem extends StatelessWidget {
  final Encomenda encomenda;
  final Function onClick;
  final Function onLongPress;
  final Function onRefresh;
  final Function onFinalizar;

  EncomendaItem(this.encomenda, this.onClick, this.onLongPress, this.onRefresh, this.onFinalizar);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onClick,
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
                    Row(
                      children: [
                        new Text(
                          encomenda.nome,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          imagemDisponivel(encomenda.empresa),
                          width: 80,
                        )
                      ],
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
                      Visibility(
                        visible: Finalizado.N == encomenda.finalizado,
                        child: FlatButton(
                            onPressed: onFinalizar,
                            child: Text("Recebi a encomenda"),
                        ),
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

  String imagemDisponivel(EmpresasDisponiveis empresa) {
    if (EmpresasDisponiveis.REDESUL == empresa){
      return 'images/rede_sul.png';
    }
    if (EmpresasDisponiveis.CORREIOS == empresa){
      return 'images/correios.jpg';
    }
    return '';
  }
}

import 'dart:io';

import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/meus_dados.dart';
import 'package:tracking_app/screens/encomendas_finalizadas_screen.dart';
import 'package:tracking_app/screens/meus_dados_screen.dart';
import 'package:tracking_app/screens/rastrear_encomendas_screen.dart';
import 'package:tracking_app/services/api_services/redesul/redesul_api_config.dart';
import 'package:tracking_app/services/api_services/redesul/redesul_client_service.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';
import 'package:tracking_app/services/database_services/meus_dados_dao.dart';

import 'novo_rastreio_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MeusDadosDao meusDadosDao = new MeusDadosDao();
  EncomendaDao encomendaDao = new EncomendaDao();
  MeusDados meusDados = MeusDadosDao.defaultMeusDados();
  
  RedeSulClientService redeSulClientService = new RedeSulClientService();

  String _qtdEncomendasEmRastreio = "0";
  String _qtdEncomendasFinalizadas = "0";

  @override
  Widget build(BuildContext context) {
   carregarMeusDados();
   carregarEncomendasEmRastreio();
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              onDetailsPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MeusDadosScreen(),
                  ),
                ).then((value) => {
                  carregarMeusDados()
                });
              },
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: AssetImage("images/drawer.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              accountName: Text(meusDados.nome),
              accountEmail: Text(meusDados.email),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 40,),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Meus Dados"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MeusDadosScreen(),
                  ),
                ).then((value) => {
                  carregarMeusDados()
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text("Rastrear encomendas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RastrearEncomendasScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.done),
              title: Text("Encomendas Recebidas"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EncomendasFinalizadasScreen(),
                  ),
                ).then((value) => {
                  // carregarMeusDados()
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MeusDadosScreen(),
                  ),
                ).then((value) => {
                  carregarMeusDados()
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text("Sugestão/Problema/Reclamação"),
              onTap: () {
                  Navigator.pop(context);
                  enviarEmailDesenvolvedor(context);
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.star_border),
            //   title: Text("Avaliar App"),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sair"),
              onTap: () {
                NAlertDialog alertDialog = NAlertDialog(
                  title: Text("Atenção"),
                  content: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Deseja sair do APP?"),
                  ),
                  actions: [
                    FlatButton(
                      child: Text("Sim"),
                      onPressed: () {
                        exit(0);
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
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Rastreamento de Encomendas"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RastrearEncomendasScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height / 6,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _qtdEncomendasEmRastreio,
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        Text(
                          "Encomendas em rastreamento",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
              ),
              Material(
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RastrearEncomendasScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height / 6,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _qtdEncomendasFinalizadas,
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        Text(
                          "Encomendas Finalizadas",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NovoRastreioScreen(),
            ),
          );
        },
      ),
    );
  }

  void carregarMeusDados() {
    meusDadosDao.findById().then((data)  {
      setState(() {
        if (data != null){
          meusDados = data;
        }
      });
    });
  }

  void carregarEncomendasEmRastreio() {
    encomendaDao.findByStatus(Finalizado.S).then((data)  {
      setState(() {
        _qtdEncomendasFinalizadas = data.length.toString();
      });
    });
    encomendaDao.findByStatus(Finalizado.N).then((data)  {
      setState(() {
        _qtdEncomendasEmRastreio = data.length.toString();
      });
    });
  }

  void enviarEmailDesenvolvedor(BuildContext context) async {
    Email email = Email(
        to: ['paulo20091994@gmail.com'],
        subject: 'Sugestão/Problema/Reclamação TrackinApp',
        body: 'Olá, escreva aqui sua mensagem'
    );
    try {
      await EmailLauncher.launch(email);
    } catch (erro) {
      String mensagem = "";
      if (erro.toString().contains("mail configuration")){
        mensagem = "Sem email configurado ou aplicativo de email, verifique se seu email esta logado na conta google ou se existe algum app de email instalado";
      } else {
        mensagem = "Ops, ocorreu um problema, mande um email para paulo20091994@gmail.com informando sua sugestão, problema ou reclamação";
      }
      NAlertDialog alertDialog = NAlertDialog(
        title: Text("Envio de Email"),
        content: Padding(
          padding: EdgeInsets.all(16),
          child: Text(mensagem),
        ),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
      alertDialog.show(context);
    }

  }

}

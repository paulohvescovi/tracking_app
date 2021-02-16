import 'package:flutter/material.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/meus_dados.dart';
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
              },
              decoration: BoxDecoration(
                color: Colors.black,
                image: const DecorationImage(
                  image: NetworkImage('https://i.pinimg.com/originals/c4/6f/3c/c46f3cfbff1b198e0276e4d577a4464c.png'),
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
              title: Text("Entregas concluidas"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Configurações"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text("Sugestão ao Desenvolvedor"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text("Avaliar App"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sair"),
              onTap: () {
                Navigator.pop(context);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              )
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
    encomendaDao.findAll().then((data)  {
      setState(() {
        if (data != null){
          int qtd = 0;
          data.forEach((element) {
            if (element.finalizado == Finalizado.N){
                qtd++;
            }
          });
          _qtdEncomendasEmRastreio = qtd.toString();
        }
      });
    });
  }

}

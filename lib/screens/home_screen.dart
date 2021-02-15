import 'package:flutter/material.dart';
import 'package:tracking_app/screens/meus_dados_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
              accountEmail: Text("email@domain.com"),
              accountName: Text("User"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 40,),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Meus Dados"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => MeusDadosScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text("Rastrear encomendas"),
              onTap: () {
                Navigator.pop(context);
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
                    //todo onclick
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
                          "4",
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

        },
      ),
    );
  }
}

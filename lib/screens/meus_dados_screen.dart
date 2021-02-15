import 'package:flutter/material.dart';
import 'package:tracking_app/models/meus_dados.dart';

class MeusDadosScreen extends StatefulWidget {
  @override
  _MeusDadosScreenState createState() => _MeusDadosScreenState();
}

class _MeusDadosScreenState extends State<MeusDadosScreen> {

  bool _permiteEnviarNotificacoes = true;
  bool _permiteEnviarEmail = true;

  TextEditingController _nomeEditController;
  TextEditingController _emailEditController;
  TextEditingController _cpfEditController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Dados"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                final String nome = _nomeEditController.text;
                final String email = _emailEditController.text;
                final String cnpjf = _cpfEditController.text;

                MeusDados meusDados = new MeusDados(1, nome, email, cnpjf,
                    _permiteEnviarNotificacoes, _permiteEnviarEmail);
                Navigator.pop(context, meusDados);
              })
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 16)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network("https://i.imgur.com/fVMGRwk.jpg"),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                TextField(
                  controller: _nomeEditController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_sharp),
                    hintText: 'Informe seu Nome',
                    labelText:'Nome',
                    border: const OutlineInputBorder(

                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                TextField(
                  controller: _emailEditController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_sharp),
                    hintText: 'Informe seu email',
                    labelText:'Email',
                    border: const OutlineInputBorder(

                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 24)),
                Text("Algumas encomendas será necessário o CPF/CNPJ para rastreio, caso voce queira poupar tempo futuramente, pode informa-lo abaixo"),
                Padding(padding: EdgeInsets.only(top: 8)),
                TextField(
                  controller: _cpfEditController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_sharp),
                    hintText: 'CPF/CNPJ',
                    labelText:'CPF/CNPJ',
                    border: const OutlineInputBorder(

                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Text("Deseja que o app faça buscas periodicas e te avise quanto tiver atualizações em suas encomendas?"),
                    ),
                    Switch(
                      value: _permiteEnviarNotificacoes,
                      onChanged: (value) {
                        setState(() {
                          _permiteEnviarNotificacoes = value;
                          //todo on change
                        });
                      },
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      child: Text("Quer receber por email também essas atualizações nas encomendas?"),
                    ),
                    Switch(
                      value: _permiteEnviarEmail,
                      onChanged: (value) {
                        setState(() {
                          _permiteEnviarEmail = value;
                          //todo
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

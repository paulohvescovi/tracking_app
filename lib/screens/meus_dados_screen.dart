import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tracking_app/components/custom_switch.dart';
import 'package:tracking_app/components/custom_textfield.dart';
import 'package:tracking_app/components/progress_carregando.dart';
import 'package:tracking_app/models/meus_dados.dart';
import 'package:tracking_app/services/database_services/meus_dados_dao.dart';

class MeusDadosScreen extends StatefulWidget {
  @override
  _MeusDadosScreenState createState() => _MeusDadosScreenState();
}

class _MeusDadosScreenState extends State<MeusDadosScreen> {

  bool _permiteEnviarNotificacoes = true;
  bool _permiteEnviarEmail = true;
  bool _jaCarregouDadosDoUsuario = false;

  TextEditingController _nomeEditController = new TextEditingController();
  TextEditingController _emailEditController = new TextEditingController();
  TextEditingController _cpfEditController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final MeusDadosDao meusDadosDao = new MeusDadosDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Dados"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                MeusDados meusDados = obtemMeusDadosdoFormulario();
                if (_formKey.currentState.validate()) {
                  salvarMeusDados(meusDados);
                  Navigator.pop(context, meusDados);
                }
              })
        ],
      ),
      body: FutureBuilder<MeusDados>(
        initialData: MeusDados(null, "", "", "", true, true),
        future: meusDadosDao.findById(),
        builder: (context, snapshot) {

          switch(snapshot.connectionState){

            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return ProgressBarCarregando();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              MeusDados meusDados = snapshot.data;
              if (meusDados == null){
                meusDados = MeusDadosDao.defaultMeusDados();
                meusDados.nome = "";
                meusDados.email = "";
              }
              if (!_jaCarregouDadosDoUsuario){
                _permiteEnviarNotificacoes = meusDados.enviarNotificacoes;
                _permiteEnviarEmail = meusDados.enviarEmail;
                _jaCarregouDadosDoUsuario = true;
              }

              _nomeEditController.text = meusDados.nome;
              _emailEditController.text = meusDados.email;
              _cpfEditController.text = meusDados.cpf;

              return ListView(
                children: [
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 16)),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'images/user.png',
                                width: 150,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            CustomTextField(
                              hintText: 'Informe seu Nome',
                              labelText: 'Nome',
                              controller: _nomeEditController,
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            CustomTextField(
                              hintText: 'Informe seu email acima',
                              labelText: "Email",
                              controller: _emailEditController,
                            ),
                            Padding(padding: EdgeInsets.only(top: 24)),
                            Text("Algumas encomendas será necessário o CPF/CNPJ para rastreio, caso voce queira poupar tempo futuramente, pode informa-lo abaixo"),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            CustomTextField(
                              hintText: 'CPF/CNPJ',
                              labelText: "CPF/CNPJ",
                              controller: _cpfEditController,
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            CustomSwitch(
                              label: "Deseja que o app faça buscas periodicas e te avise quanto tiver atualizações em suas encomendas?",
                              value: _permiteEnviarNotificacoes,
                              onchange: (newValue) {
                                setState(() {
                                  _permiteEnviarNotificacoes = newValue;
                                  //todo on change
                                });
                              },
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Container(
                            //       width: MediaQuery.of(context).size.width*0.8,
                            //       child: Text("Quer receber por email também essas atualizações nas encomendas?"),
                            //     ),
                            //     Switch(
                            //       value: _permiteEnviarEmail,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           _permiteEnviarEmail = value;
                            //           //todo
                            //         });
                            //       },
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      )
                  )
                ],
              );
              break;
          }
          return Text("Ocorreu um problema nesscarniça");
        },
      ),
    );
  }

  MeusDados obtemMeusDadosdoFormulario() {
    final String nome = _nomeEditController.text;
    final String email = _emailEditController.text;
    final String cnpjf = _cpfEditController.text;

    MeusDados meusDados = new MeusDados(1, nome, email, cnpjf,
        _permiteEnviarNotificacoes, _permiteEnviarEmail);
    return meusDados;
  }

  MeusDados salvarMeusDados(MeusDados meusDados) {
    try {
      meusDadosDao.save(meusDados);
      return meusDados;
    } on Exception catch (_) {
      return null;
    }
  }

}
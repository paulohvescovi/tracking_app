import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:path/path.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/models/meus_dados.dart';
import 'package:tracking_app/services/api_services/correios/correios_client_service.dart';
import 'package:tracking_app/services/api_services/redesul/models/redesul_track.dart';
import 'package:tracking_app/services/api_services/redesul/models/redesul_track_detail.dart';
import 'package:tracking_app/services/api_services/redesul/redesul_client_service.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';
import 'package:tracking_app/services/database_services/meus_dados_dao.dart';
import 'package:tracking_app/utils/date_utils.dart';

class NovoRastreioScreen extends StatefulWidget {
  @override
  _NovoRastreioScreenState createState() => _NovoRastreioScreenState();
}

class _NovoRastreioScreenState extends State<NovoRastreioScreen> {
  MeusDadosDao meusDadosDao = new MeusDadosDao();
  EncomendaDao encomendaDao = new EncomendaDao();

  RedeSulClientService redeSulClientService = new RedeSulClientService();
  CorreioClientService correioClientService = new CorreioClientService();

  EmpresasDisponiveis _empresaSelecionada = null;
  Encomenda encomenda = Encomenda.codigoRastreio("");
  MeusDados meusDados = null;

  TextEditingController _cpfEditTextController = TextEditingController();
  TextEditingController _numeroPedidoTextController = TextEditingController();
  TextEditingController _nomeEncomendaTextController = TextEditingController();
  TextEditingController _numeroRastreioCorreioTextController = TextEditingController();

  ProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    buscarMeusDados();
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova encomenda"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/rede_sul.png',
                      width: 150,
                    ),
                    Image.asset(
                      'images/correios.jpg',
                      width: 150,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text(
                  "1º Selecionar empresa de transporte",
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                SizedBox(
                  width: 230,
                  height: 60,
                  child: RaisedButton(
                      child: Text(
                        "Selecionar Empresa",
                        style: TextStyle(
                            fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        List<String> list = List();
                        list.add("RedeSul Logistica");
                        list.add("Correios");

                        String ex1 = "Nenhuma empresa selecionada";
                        SelectDialog.showModal<String>(
                          context,
                          showSearchBox: false,
                          label: "Selecione a empresa",
                          selectedValue: ex1,
                          items: list,
                          onChange: (String selected) {
                            setState(() {
                              if (selected == "RedeSul Logistica") {
                                _empresaSelecionada =
                                    EmpresasDisponiveis.REDESUL;
                                if (meusDados != null &&
                                    meusDados.cpf != null) {
                                  _cpfEditTextController.text = meusDados.cpf;
                                }
                              } else {
                                _empresaSelecionada =
                                    EmpresasDisponiveis.CORREIOS;
                              }
                            });
                          },
                        );
                      }
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                Visibility(
                    visible: _empresaSelecionada != null,
                    child: Column(
                      children: [
                        Text("Empresa Selecionada"),
                        Padding(padding: EdgeInsets.only(top: 8)),
                        Text(
                          _empresaSelecionada != null
                              ? _empresaSelecionada.descricao
                              : "",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text(
                  "2º Informe os dados para rastrear",
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Visibility(
                  child: TextField(
                    controller: _nomeEncomendaTextController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_sharp),
                      hintText: 'Ex: Fone, mouse, celular..',
                      labelText: 'Nome da encomenda',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Visibility(
                  visible: EmpresasDisponiveis.REDESUL == _empresaSelecionada,
                  child: TextField(
                    controller: _cpfEditTextController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      hintText: 'Informe seu CPF/CNPJ',
                      labelText: 'CNPJ/CPF',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Visibility(
                  visible: EmpresasDisponiveis.REDESUL == _empresaSelecionada,
                  child: TextField(
                    controller: _numeroPedidoTextController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_sharp),
                      hintText: 'Informe o Numero do Pedido',
                      labelText: 'Nº Pedido',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Visibility(
                  visible: EmpresasDisponiveis.CORREIOS == _empresaSelecionada,
                  child: TextField(
                    controller: _numeroRastreioCorreioTextController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_sharp),
                      hintText: 'QD592017502BR',
                      labelText: 'Código Rastreio',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                Visibility(
                  visible: _empresaSelecionada != null,
                  child: SizedBox(
                    width: 230,
                    height: 60,
                    child: RaisedButton(
                      child: Text(
                        "Buscar encomenda...",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        if (_empresaSelecionada == EmpresasDisponiveis.REDESUL){

                          encomenda.cpf = _cpfEditTextController.text.isNotEmpty ? _cpfEditTextController.text : meusDados.cpf;

                          encomenda.codigoRastreio = _numeroPedidoTextController.text;
                          if (_nomeEncomendaTextController.text.isEmpty){
                            encomenda.nome = "Encomenda Rede Sul";
                          } else {
                            encomenda.nome = _nomeEncomendaTextController.text;
                          }
                          progressDialog = ProgressDialog(context,
                            message:Text("Buscando dados da encomenda"),
                            title:Text("Aguarde"),
                            // dismissable: false
                          );
                          progressDialog.show();
                          redeSulClientService.buscarEncomendaRedeSul(encomenda, (Encomenda encomendaSalva) {
                            if (encomendaSalva == null){
                              progressDialog.dismiss();
                              NAlertDialog(
                                title: Text("Oops"),
                                content: Text("Não encontramos a encomenda com o CPF/CNPJ e Numero do pedido fornecido"),
                                actions: [
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ).show(context);
                            } else {
                              progressDialog.dismiss();
                              Navigator.pop(context, encomendaSalva);
                            }
                          }, () {
                            progressDialog.dismiss();
                            NAlertDialog(
                              title: Text("Erro"),
                              content: Text("Não encontramos a encomenda com o CPF/CNPJ e Numero do pedido fornecido"),
                            ).show(context);
                          });
                        } else {

                          if (_numeroRastreioCorreioTextController.text.isEmpty){
                            NAlertDialog alertDialog = NAlertDialog(
                              title: Text("Ops"),
                              content: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text("Informe o codigo de rastreio"),
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
                            return;
                          }

                          encomenda.codigoRastreio = _numeroRastreioCorreioTextController.text;
                          if (_nomeEncomendaTextController.text.isEmpty){
                            encomenda.nome = "Encomenda Correios";
                          } else {
                            encomenda.nome = _nomeEncomendaTextController.text;
                          }
                          progressDialog = ProgressDialog(context,
                            message:Text("Buscando dados da encomenda"),
                            title:Text("Aguarde"),
                            // dismissable: false
                          );
                          progressDialog.show();
                          correioClientService.buscarEncomendaCorreios(encomenda, (Encomenda encomendaSalva) {
                            if (encomendaSalva == null){
                              progressDialog.dismiss();
                              NAlertDialog(
                                title: Text("Oops"),
                                content: Text("Não encontramos a encomenda codigo de rastreio informado"),
                                actions: [
                                  FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ).show(context);
                            } else {
                              progressDialog.dismiss();
                              Navigator.pop(context, encomendaSalva);
                            }
                          }, () {
                            progressDialog.dismiss();
                            NAlertDialog(
                              title: Text("Erro"),
                              content: Text("Deu um problema ao buscar a encomenda, avise o desenvolvedor pelo menu sugestão/reclamação"),
                            ).show(context);
                          });

                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void buscarMeusDados() {
    setState(() {
      meusDadosDao.findById().then((value) => {
            if (value != null) {
              meusDados = value
            }
          });
    });
  }

}

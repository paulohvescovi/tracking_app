import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:path/path.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/models/meus_dados.dart';
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

  EmpresasDisponiveis _empresaSelecionada = null;
  Encomenda encomenda = Encomenda.codigoRastreio("");
  MeusDados meusDados = null;

  TextEditingController _cpfEditTextController = TextEditingController();
  TextEditingController _numeroPedidoTextController = TextEditingController();
  TextEditingController _nomeEncomendaTextController = TextEditingController();

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
                Padding(padding: EdgeInsets.only(top: 8)),
                Text(
                  "Selecione empresa da encomenda",
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          color: Theme.of(context).primaryColor, width: 2.0),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      customBorder: ContinuousRectangleBorder(),
                      onTap: () {
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
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'images/rede_sul.png',
                            width: 200,
                          ),
                          Image.asset(
                            'images/correios.jpg',
                            width: 200,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                Visibility(
                    visible: _empresaSelecionada != null,
                    child: Column(
                      children: [
                        Text("Empresa Selecionada"),
                        Padding(padding: EdgeInsets.only(top: 8)),
                        Text(_empresaSelecionada != null
                            ? _empresaSelecionada.descricao
                            : ""),
                      ],
                    )),
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
                          buscarEncomendaRedeSul(context);
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

  void buscarEncomendaRedeSul(BuildContext context) async {
    RedeSulTrack encomendaEncontrada = null;

    try {
      encomendaEncontrada = await redeSulClientService.findEncomenda(encomenda.codigoRastreio, meusDados.cpf);
    } catch (erro) {
      progressDialog.dismiss();
      NAlertDialog(
        title: Text("Erro"),
        content: Text("Não encontramos a encomenda com o CPF/CNPJ e Numero do pedido fornecido"),
      ).show(context);
      return;
    }

    progressDialog.dismiss();
    if (encomendaEncontrada == null){
      NAlertDialog(
        title: Text("Oops"),
        content: Text("Não encontramos a encomenda com o CPF/CNPJ e Numero do pedido fornecido"),
      ).show(context);
    }
    encomendaEncontrada.tracking.sort((a,b) => b.getDataHoraEfetiva().compareTo(a.getDataHoraEfetiva()));
    RedeSulTrackDetail ultimoStatusTrackin = encomendaEncontrada.tracking[0];

    encomenda.ultimoStatus = ultimoStatusTrackin.descricao;
    encomenda.finalizado = Finalizado.N;

    encomendaDao.save(encomenda).then((savedEncomenda) => {
      Navigator.pop(context, savedEncomenda)
    });

  }

}

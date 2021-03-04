import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tracking_app/components/button_grande.dart';
import 'package:tracking_app/components/custom_textfield.dart';
import 'package:tracking_app/components/text_20.dart';
import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/models/meus_dados.dart';
import 'package:tracking_app/services/api_services/correios/correios_client_service.dart';
import 'package:tracking_app/services/api_services/redesul/redesul_client_service.dart';
import 'package:tracking_app/services/api_services/sequoia/sequoia_client_service.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';
import 'package:tracking_app/services/database_services/meus_dados_dao.dart';
import 'package:tracking_app/utils/dialog_utils.dart';

import 'banners_empresa.dart';

class NovoRastreioScreen extends StatefulWidget {
  @override
  _NovoRastreioScreenState createState() => _NovoRastreioScreenState();
}

class _NovoRastreioScreenState extends State<NovoRastreioScreen> {
  MeusDadosDao meusDadosDao = new MeusDadosDao();
  EncomendaDao encomendaDao = new EncomendaDao();

  RedeSulClientService redeSulClientService = new RedeSulClientService();
  CorreioClientService correioClientService = new CorreioClientService();
  SequioaClientService sequoiaClientService = new SequioaClientService();

  EmpresasDisponiveis _empresaSelecionada = null;
  Encomenda encomenda = Encomenda.codigoRastreio("");
  MeusDados meusDados = null;

  TextEditingController _cpfEditTextController = TextEditingController();
  TextEditingController _numeroPedidoTextController = TextEditingController();
  TextEditingController _nomeEncomendaTextController = TextEditingController();
  TextEditingController _numeroRastreioCorreioTextController =
      TextEditingController();

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
                BannersEmpresa(),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text20("1º Selecionar empresa de transporte"),
                Padding(padding: EdgeInsets.only(top: 8)),
                ButtonGrande(
                  "Selecionar Empresa",
                  onPressed: () {
                    DialogUtils.select(context, "Selecione a Empresa",
                        obtemOptionsEmpresasDisponiveis(), (String selected) {
                      setState(() {
                        _empresaSelecionada = obtemEmpresaSelecionada(selected);
                      });
                    });
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                Visibility(
                    visible: _empresaSelecionada != null,
                    child: Column(
                      children: [
                        Text("Empresa Selecionada"),
                        Padding(padding: EdgeInsets.only(top: 8)),
                        Text20(
                          _empresaSelecionada != null
                              ? _empresaSelecionada.descricao
                              : "",
                          color: Theme.of(context).primaryColor,
                          negrito: true,
                        ),
                      ],
                    )),
                Padding(padding: EdgeInsets.only(top: 8)),
                Text20("2º Informe os dados para rastrear"),
                CustomTextField(
                  labelText: "Nome da encomenda",
                  hintText: "Ex: Fone, mouse, celular..",
                  icon: Icon(Icons.person_outline_sharp),
                  controller: _nomeEncomendaTextController,
                ),
                CustomTextField(
                  visibility: _empresaSelecionada.visibilityCnpjCpf,
                  hintText: 'Informe seu CPF/CNPJ',
                  labelText: 'CNPJ/CPF',
                  icon: Icon(Icons.vpn_key),
                  controller: _cpfEditTextController,
                ),
                CustomTextField(
                  visibility: _empresaSelecionada.visibilityCodigoPedido,
                  hintText: 'Informe o Numero do Pedido',
                  labelText: 'Nº Pedido',
                  icon: Icon(Icons.person_outline_sharp),
                  controller: _numeroPedidoTextController,
                ),
                CustomTextField(
                  visibility: _empresaSelecionada.visibilityCodigoRastreio,
                  hintText: 'QD592017502BR',
                  labelText: 'Código Rastreio',
                  icon: Icon(Icons.person_outline_sharp),
                  controller: _numeroRastreioCorreioTextController,
                ),
                Padding(padding: EdgeInsets.only(top: 16)),
                ButtonGrande(
                  "Buscar encomenda...",
                  onPressed: () {
                    switch (_empresaSelecionada) {
                      case EmpresasDisponiveis.REDESUL:
                        buscarDadosRedeSul(context);
                        break;
                      case EmpresasDisponiveis.CORREIOS:
                        buscarDadosCorreios(context);
                        break;
                      case EmpresasDisponiveis.SEQUOIA:
                        buscarDadosSequoia(context);
                        break;
                    }
                  },
                ),
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
            if (value != null) {meusDados = value}
          });
    });
  }

  void buscarDadosSequoia(BuildContext context) {
    try {
      //valida os campos
      if (!informouNumeroDeRastreio()) {
        DialogUtils.ok(
            context, "Informe o código de rastreio antes de continuar");
        return;
      }

      //obtem as informacoes para buscar a encomenda no correios
      encomenda.codigoRastreio =
          obtemCodigoRastreio(EmpresasDisponiveis.SEQUOIA);
      encomenda.nome = obtemNomeEncomenda(EmpresasDisponiveis.SEQUOIA);

      //exibir o dialog
      progressDialog =
          DialogUtils.loading(context, "Buscando encomenda no Sequoia");
      sequoiaClientService.buscarEncomenda(encomenda,
          (Encomenda encomendaSalva) {
        progressDialog.dismiss();
        if (encomendaSalva == null) {
          DialogUtils.ok(context,
              "Não encontramos a encomenda codigo de rastreio informado");
        } else {
          Navigator.pop(context, encomendaSalva);
        }
      }, () {
        progressDialog.dismiss();
        DialogUtils.ok(context,
            "Ocorreu um problema ao fazer a busca no SEQUOIA, informe o desenvolvedor pelo menu sugestão/reclamação junto aos dados da encomenda",
            title: "Erro");
      });
    } catch (error) {
      progressDialog.dismiss;
      DialogUtils.ok(
          context, "Não encontramos a encomenda codigo de rastreio informado");
    }
  }

  void buscarDadosCorreios(BuildContext context) {
    //valida os campos
    if (!informouNumeroDeRastreio()) {
      DialogUtils.ok(
          context, "Informe o código de rastreio antes de continuar");
      return;
    }

    //obtem as informacoes para buscar a encomenda no correios
    encomenda.codigoRastreio =
        obtemCodigoRastreio(EmpresasDisponiveis.CORREIOS);
    encomenda.nome = obtemNomeEncomenda(EmpresasDisponiveis.CORREIOS);

    //exibir o dialog
    progressDialog =
        DialogUtils.loading(context, "Buscando encomenda no correios");

    //chama o metodo que faz a busca no site que busca no coreios
    correioClientService.buscarEncomendaCorreios(encomenda,
        (Encomenda encomendaSalva) {
      progressDialog.dismiss();
      if (encomendaSalva == null) {
        DialogUtils.ok(context,
            "Não encontramos a encomenda codigo de rastreio informado");
      } else {
        Navigator.pop(context, encomendaSalva);
      }
    }, () {
      progressDialog.dismiss();
      DialogUtils.ok(context,
          "Ocorreu um problema ao fazer a busca no CORREIOS, informe o desenvolvedor pelo menu sugestão/reclamação junto aos dados da encomenda",
          title: "Erro");
    });
  }

  ///obtem os dados informados na interface e busca na rede sul a encomenda
  void buscarDadosRedeSul(BuildContext context) {
    //obtem informacoes para fazer a busca
    encomenda.cpf = obtemCpf();
    encomenda.nome = obtemNomeEncomenda(EmpresasDisponiveis.REDESUL);
    encomenda.codigoRastreio = obtemCodigoRastreio(EmpresasDisponiveis.REDESUL);

    //exibir o dialog
    progressDialog = DialogUtils.loading(context, "Buscando Encomenda");

    //busca a encomenda, e caso encontre grava no banco de dados para dficar mnonitorando
    redeSulClientService.buscarEncomendaRedeSul(encomenda,
        (Encomenda encomendaSalva) {
      progressDialog.dismiss();
      if (encomendaSalva == null) {
        DialogUtils.ok(context,
            "Não encontramos a encomenda com o CPF/CNPJ e Numero do pedido fornecido");
      } else {
        Navigator.pop(context, encomendaSalva);
      }
    }, () {
      progressDialog.dismiss();
      DialogUtils.ok(context,
          "Ocorreu um problema ao fazer a busca na Rede Sul, informe o desenvolvedor pelo menu sugestão/reclamação junto aos dados da encomenda",
          title: "Erro");
    });
  }

  String obtemCpf() {
    return _cpfEditTextController.text.isNotEmpty
        ? _cpfEditTextController.text
        : meusDados.cpf;
  }

  String obtemNomeEncomenda(EmpresasDisponiveis empresa) {
    if (_nomeEncomendaTextController.text.isEmpty) {
      return "Encomenda " + empresa.descricao;
    } else {
      return _nomeEncomendaTextController.text;
    }
  }

  String obtemCodigoRastreio(EmpresasDisponiveis empresa) {
    if (empresa == EmpresasDisponiveis.REDESUL) {
      return _numeroPedidoTextController.text;
    } else if (empresa == EmpresasDisponiveis.CORREIOS) {
      return _numeroRastreioCorreioTextController.text;
    } else if (empresa == EmpresasDisponiveis.SEQUOIA) {
      return _numeroRastreioCorreioTextController.text;
    } else {
      //def
      return _numeroRastreioCorreioTextController.text;
    }
  }

  bool informouNumeroDeRastreio() {
    return !_numeroRastreioCorreioTextController.text.isEmpty;
  }

  EmpresasDisponiveis obtemEmpresaSelecionada(String selected) {
    if (EmpresasDisponiveis.REDESUL.descricao == selected) {
      return EmpresasDisponiveis.REDESUL;
    }
    if (EmpresasDisponiveis.CORREIOS.descricao == selected) {
      return EmpresasDisponiveis.CORREIOS;
    }
    if (EmpresasDisponiveis.SEQUOIA.descricao == selected) {
      return EmpresasDisponiveis.SEQUOIA;
    }
  }

  List<String> obtemOptionsEmpresasDisponiveis() {
    List<String> list = List();
    EmpresasDisponiveis.values.forEach((element) {
      list.add(element.descricao);
    });
    return list;
  }
}

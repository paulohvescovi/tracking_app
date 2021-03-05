import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http2;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:http/io_client.dart';
import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/models/encomenda_detail.dart';
import 'package:tracking_app/services/api_services/rastreadordepacotes/models/rastreador_de_pacotes.dart';
import 'package:tracking_app/services/api_services/rastreadordepacotes/rastreador_de_pacotes_service.dart';
import 'package:tracking_app/services/api_services/sequoia/models/sequoia_track_detailt.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';
import 'package:tracking_app/utils/date_utils.dart';

import 'models/sequoia_track_header.dart';

class SequioaClientService {
  final EncomendaDao encomendaDao = new EncomendaDao();
  final RastreadorDePacotesService rastreadorDePacotesService =
      new RastreadorDePacotesService();

  ///@deprecated 401 os cara bloquearam a bagassa
  // buscarEncomendaSequoiaDiretoNaSequoia(
  //     Encomenda encomenda, Function onSucess, Function onError) async {
  //   String codigoRastreio = encomenda.codigoRastreio;
  //   String urlFindPedidoByCodigoRastreio =
  //       "https://portalvesta-api.sequoialog.com.br/ConsultaDetalhes/SelecionarRastreamentoPedidos?codRastreioNumPedido=$codigoRastreio&itensPorPagina=5&paginaAtual=1&";

  //   Map<String, String> headers = {
  //     "Host": "portalvesta-api.sequoialog.com.br",
  //     "Content-Type": "application/json",
  //     "Cookie":
  //         "_ga=GA1.3.646349162.1614629972; _gid=GA1.3.1334743211.1614811431; auth_cookie=CfDJ8BVjeAyUxp1ImYGSvO89DulpSu2g7P6666c_zoD6zDMy7oOiJhdfPH1TxcBXiwZnFk1jjY2T33-7cJKJkdn9zkXcbf8M7OEufCbPK0ID7eSvjSi8gkVrS7OhT0jJqGcBrKeW5igb9wtjgRFqLph6NGUYENPbsl66kbb5_qn3xHVak7XPBkyqy0eusScQKszjsMIaSFPEy66nDB5o7nvusFerW9tw0BFElHqZXHQEz4cLh6xFM8MqIS71ZUk3Q12NFzQ-2ZiyzBP_yyvIpIV9dAc7LMsN-_Skw50UvnrZxNW0h8qCednjwPxNBgKgLy51-Lx6mBZYcdvDOUaael44m0vmD3JARwSyXfVz0GkCSQumKQxTewKW7F7TsEauWFqUokUhdTVe9vk7ASiA-2PIlOmnP_ttz5dRR9aWp50Wm9AHtAsdv2m9JqRYINiRBR16-QMI59rFGZaVdpGHvNzN1hduD-16wY6LvN5T9pnGHI4Ox317DjoDfU4xHmR0vLrOKA"
  //   };

  //   Response response = null;
  //   final ioc = new HttpClient();
  //   ioc.badCertificateCallback =
  //       (X509Certificate cert, String host, int port) => true;
  //   final http = new IOClient(ioc);
  //   try {
  //     response =
  //         await http.get(urlFindPedidoByCodigoRastreio, headers: headers);
  //   } on FormatException catch (_) {
  //     print(_.toString());
  //     onError();
  //     return;
  //   } catch (error) {
  //     print(error.toString());
  //     onError();
  //     return;
  //   }

  //   if (response.statusCode == 401) {
  //     onError();
  //     return;
  //   }

  //   if (jsonDecode(response.body).length == 0) {
  //     onSucess(null);
  //   }
  //   SequoiaTrack endomendaSequoia =
  //       SequoiaTrack.fromJson(jsonDecode(response.body)[0]);

  //   String urlFindDetails =
  //       "https://portalvesta-api.sequoialog.com.br/ConsultaDetalhes/SelecionarRastreamentoPedidoHistorico/" +
  //           endomendaSequoia.pedidoID.toString();

  //   Response responseDetails = await http.get(urlFindDetails, headers: headers);

  //   //List<Map<String, dynamic>> detailsJson = jsonDecode(responseDetails.body);
  //   SequoiaTrackDetail lastStatus =
  //       SequoiaTrackDetail.fromJson(jsonDecode(responseDetails.body)[0]);

  //   encomenda.ultimoStatus = endomendaSequoia.situacao;
  //   encomenda.finalizado = Finalizado.N;
  //   encomenda.ultimaAtualizacao = lastStatus.situacao + " - " + lastStatus.data;
  //   encomenda.dataUltimoStatus = lastStatus.data;
  //   encomenda.cpf = endomendaSequoia.pedidoID.toString();
  //   encomenda.empresa = EmpresasDisponiveis.SEQUOIA;

  //   Encomenda encomendaSalva = await encomendaDao.save(encomenda);

  //   //popular details
  //   List<dynamic> detailsListMap = jsonDecode(responseDetails.body);
  //   List<SequoiaTrackDetail> sequoiaDetails = new List();
  //   encomenda.details = List();
  //   detailsListMap.forEach((element) {
  //     sequoiaDetails.add(SequoiaTrackDetail.fromJson(element));
  //   });

  //   sequoiaDetails.forEach((trackin) {
  //     EncomendaDetail encomendaDetail = new EncomendaDetail();

  //     String dataString = DateUtil.format(
  //         trackin.getDataHoraEfetiva(), DateUtil.PATTERN_DATETIME);

  //     encomendaDetail.ocorrencia = trackin.situacao;
  //     encomendaDetail.cidade =
  //         trackin.localidade != null ? trackin.localidade : "Cidade Final";
  //     encomendaDetail.data_hora = dataString;
  //     encomendaDetail.descricao = trackin.situacao;

  //     if (trackin.situacao.contains("Entregue")) {
  //       encomendaDetail.tipo = "Concluido";
  //     } else if (trackin.situacao.contains("entrega")) {
  //       encomendaDetail.tipo = "Quase chegando";
  //     } else if (trackin.situacao.contains("Em transfe")) {
  //       encomendaDetail.tipo = "Em Transferência";
  //     } else {
  //       encomendaDetail.tipo = "Em Transporte";
  //     }

  //     encomenda.details.add(encomendaDetail);
  //   });

  //   onSucess(encomendaSalva);
  // }

  buscarEncomenda(Encomenda encomenda, Function onSucess, Function onError) {
    rastreadorDePacotesService
        .buscarEncomenda(EmpresasDisponiveis.SEQUOIA, encomenda.codigoRastreio,
            onSucess: (RastreadorDePacotes enc) {
      if (enc == null) {
        onSucess(null);
        return;
      }
      encomenda.ultimoStatus = enc.status;
      encomenda.finalizado = Finalizado.N;
      encomenda.ultimaAtualizacao = enc.detalhes[0].data;
      encomenda.cpf = "";
      encomenda.empresa = EmpresasDisponiveis.SEQUOIA;

      encomendaDao.save(encomenda).then((endomendaSalva) {
        encomenda = endomendaSalva;
        encomenda.details = List();
        enc.detalhes.forEach((trackin) {
          EncomendaDetail encomendaDetail = new EncomendaDetail();

          String dataString = DateUtil.format(
              trackin.getDataHoraEfetiva(), DateUtil.PATTERN_DATETIME);

          encomendaDetail.ocorrencia = trackin.detalhesFormatado;
          encomendaDetail.data_hora = dataString;
          encomendaDetail.descricao = trackin.detalhesFormatado;

          if (trackin.statusPosicao.contains("Entregue")) {
            encomendaDetail.tipo = "Mercadoria Entregue";
            encomendaDetail.descricao = enc.informacoesRemessa[2].value;
          } else if (trackin.statusPosicao.contains("SaiuParaEntrega")) {
            encomendaDetail.tipo = "Em processo de entrega no destino";
            encomendaDetail.descricao = enc.informacoesRemessa[2].value;
          } else if (trackin.statusPosicao.contains("EmTransito")) {
            encomendaDetail.tipo = "Em Transferência para outra unidade";
            encomendaDetail.descricao = "Cidade não informada";
          } else if (trackin.statusPosicao.contains("Postado")) {
            encomendaDetail.tipo = "Mercadoria Postada";
            encomendaDetail.descricao = enc.informacoesRemessa[1].value;
          } else {
            encomendaDetail.tipo = "Em Transporte";
          }

          encomenda.details.add(encomendaDetail);
        });
        onSucess(encomenda);
      });
    }, onError: () {
      onError();
      return;
    });
  }
}

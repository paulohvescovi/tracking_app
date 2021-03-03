import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:http/io_client.dart';
import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/models/encomenda_detail.dart';
import 'package:tracking_app/services/api_services/sequoia/models/sequoia_track_detailt.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';
import 'package:tracking_app/utils/date_utils.dart';

import 'models/sequoia_track_header.dart';

class SequioaClientService {
  final EncomendaDao encomendaDao = new EncomendaDao();

  buscarEncomendaSequoia(
      Encomenda encomenda, Function onSucess, Function onError) async {
    String codigoRastreio = encomenda.codigoRastreio;
    String urlFindPedidoByCodigoRastreio =
        "https://portalvesta-api.sequoialog.com.br/ConsultaDetalhes/SelecionarRastreamentoPedidos?codRastreioNumPedido=$codigoRastreio&itensPorPagina=5&paginaAtual=1&";

    Map<String, String> headers = {
      "Host": "portalvesta-api.sequoialog.com.br",
      "Content-Type": "application/json",
      "Cookie":
          "_ga=GA1.3.646349162.1614629972; _gid=GA1.3.579198336.1614629972; auth_cookie=CfDJ8B60nzq-7E5Ijd-f0r3Q9kLa4SmHRGZ-ETns4t-5Urp877YarqkqUKcnmqIcw5Ey5Chz154IS-_FydhoUVgW24P7soSkWe0iY-jqI7NDwYbNYlQlRkRFJARu8BJ7DVfR3Adv4D7vY8ODLa61E3z9BvdF8Z6rEre0bI_3k8Z1WqhxEE53BNeH-RFI_nEwTTjvIo5VCAAIgADXBWyRcm-jnGzSDfeRP98RPrDDypI5FrPj_xvMFfHwqq33-FjC9KXtsN9aasoy5ttHVhhvVYLn9M6jYQSmQjYqA3VIOHU-t_g-BsUqT0_xEn366DQOtFP6OTbMiqkYtifI38ZfyCO2DUauKAfbjwfcBxPU6H_LMb19pc5S4RXl19Z8_EFR1hpwVxcM2UhYDJw93s-seM9brI6CSGt7AGQ6KRyD8Yyt_79lsuix5lM4o9rjBzIt3s9DJ0CAco7YX7esgJe96wj-qbKym_TZyjh5yIx7MXOfq3hTOOWKdMrYzPHmrysPGIKpZQ"
    };

    Response response = null;
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    try {
      response =
          await http.get(urlFindPedidoByCodigoRastreio, headers: headers);
    } catch (erro) {
      print(erro.toString());
      onError();
    }

    if (jsonDecode(response.body).length == 0) {
      onSucess(null);
    }
    SequoiaTrack endomendaSequoia =
        SequoiaTrack.fromJson(jsonDecode(response.body)[0]);

    String urlFindDetails =
        "https://portalvesta-api.sequoialog.com.br/ConsultaDetalhes/SelecionarRastreamentoPedidoHistorico/" +
            endomendaSequoia.pedidoID.toString();

    Response responseDetails = await http.get(urlFindDetails, headers: headers);

    //List<Map<String, dynamic>> detailsJson = jsonDecode(responseDetails.body);
    SequoiaTrackDetail lastStatus =
        SequoiaTrackDetail.fromJson(jsonDecode(responseDetails.body)[0]);

    encomenda.ultimoStatus = endomendaSequoia.situacao;
    encomenda.finalizado = Finalizado.N;
    encomenda.ultimaAtualizacao = lastStatus.situacao + " - " + lastStatus.data;
    encomenda.dataUltimoStatus = lastStatus.data;
    encomenda.cpf = endomendaSequoia.pedidoID.toString();
    encomenda.empresa = EmpresasDisponiveis.SEQUOIA;

    Encomenda encomendaSalva = await encomendaDao.save(encomenda);

    //popular details
    List<dynamic> detailsListMap = jsonDecode(responseDetails.body);
    List<SequoiaTrackDetail> sequoiaDetails = new List();
    encomenda.details = List();
    detailsListMap.forEach((element) {
      sequoiaDetails.add(SequoiaTrackDetail.fromJson(element));
    });

    sequoiaDetails.forEach((trackin) {
      EncomendaDetail encomendaDetail = new EncomendaDetail();

      String dataString = DateUtil.format(
          trackin.getDataHoraEfetiva(), DateUtil.PATTERN_DATETIME);

      encomendaDetail.ocorrencia = trackin.situacao;
      encomendaDetail.cidade =
          trackin.localidade != null ? trackin.localidade : "Cidade Final";
      encomendaDetail.data_hora = dataString;
      encomendaDetail.descricao = trackin.situacao;

      if (trackin.situacao.contains("Entregue")) {
        encomendaDetail.tipo = "Concluido";
      } else if (trackin.situacao.contains("entrega")) {
        encomendaDetail.tipo = "Quase chegando";
      } else if (trackin.situacao.contains("Em transfe")) {
        encomendaDetail.tipo = "Em Transferência";
      } else {
        encomendaDetail.tipo = "Em Transporte";
      }

      encomenda.details.add(encomendaDetail);
    });

    onSucess(encomendaSalva);
  }
}

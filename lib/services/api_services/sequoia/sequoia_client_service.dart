import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

import 'models/sequoia_track_header.dart';

class SequioaClientService {

  Future<SequoiaTrack> findEncomenda(String codigoRastreio) async {

    String urlFindPedidoByCodigoRastreio = "https://portalvesta-api.sequoialog.com.br/ConsultaDetalhes/SelecionarRastreamentoPedidos?codRastreioNumPedido=$codigoRastreio&itensPorPagina=5&paginaAtual=1&";

    Map<String, String> headers = {
      "Host": "portalvesta-api.sequoialog.com.br",
      "Content-Type": "application/json",
      "Cookie": "_ga=GA1.3.646349162.1614629972; _gid=GA1.3.579198336.1614629972; auth_cookie=CfDJ8B60nzq-7E5Ijd-f0r3Q9kLa4SmHRGZ-ETns4t-5Urp877YarqkqUKcnmqIcw5Ey5Chz154IS-_FydhoUVgW24P7soSkWe0iY-jqI7NDwYbNYlQlRkRFJARu8BJ7DVfR3Adv4D7vY8ODLa61E3z9BvdF8Z6rEre0bI_3k8Z1WqhxEE53BNeH-RFI_nEwTTjvIo5VCAAIgADXBWyRcm-jnGzSDfeRP98RPrDDypI5FrPj_xvMFfHwqq33-FjC9KXtsN9aasoy5ttHVhhvVYLn9M6jYQSmQjYqA3VIOHU-t_g-BsUqT0_xEn366DQOtFP6OTbMiqkYtifI38ZfyCO2DUauKAfbjwfcBxPU6H_LMb19pc5S4RXl19Z8_EFR1hpwVxcM2UhYDJw93s-seM9brI6CSGt7AGQ6KRyD8Yyt_79lsuix5lM4o9rjBzIt3s9DJ0CAco7YX7esgJe96wj-qbKym_TZyjh5yIx7MXOfq3hTOOWKdMrYzPHmrysPGIKpZQ"
    };

    Response response = null;
    try {
      response = await  http.get(urlFindPedidoByCodigoRastreio, headers: headers);
    } catch (erro) {
      print(erro.toString());
      return null;
    }
    if (jsonDecode(response.body)["success"] == false){//nao enconrtou
      if (jsonDecode(response.body)["message"] == "Nenhuma encomenda localizado"){
        return null;
      }
    }
    return SequoiaTrack.fromJson(jsonDecode(response.body));
  }

  
}
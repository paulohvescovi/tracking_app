import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/services/api_services/redesul/redesul_api_config.dart';
import 'package:tracking_app/services/api_services/redesul/models/redesul_track.dart';
import 'package:tracking_app/services/api_services/redesul/models/redesul_track_detail.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';

import 'models/redesul_track.dart';

class RedeSulClientService {

  Future<RedeSulTrack> findEncomenda(String numeroPedido, String cpf) async {
    String body = json.encode({"cnpj": cpf, "senha": '', "pedido" : numeroPedido});

    Map<String, String> headers = {
      "Host": "ssw.inf.br",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };
    Response response = null;
    try {
      response = await  clientRedeSul
          .post(urlTracking, headers: headers, body: body);
    } catch (erro) {
      print(erro.toString());
      return null;
    }
    if (jsonDecode(response.body)["success"] == false){//nao enconrtou
      if (jsonDecode(response.body)["message"] == "Nenhum documento localizado"){
        return null;
      }
    }
    return RedeSulTrack.fromJson(jsonDecode(response.body));
  }

  void buscarEncomendaRedeSul(Encomenda encomenda, Function onSucess, Function onError) async {
    EncomendaDao encomendaDao = new EncomendaDao();
    RedeSulTrack encomendaEncontrada = null;

    try {
      encomendaEncontrada = await findEncomenda(encomenda.codigoRastreio, encomenda.cpf);
    } catch (erro) {
      onError();
      return;
    }

    if (encomendaEncontrada == null){
      onSucess(null);
    }
    encomendaEncontrada.tracking.sort((a,b) => b.getDataHoraEfetiva().compareTo(a.getDataHoraEfetiva()));
    RedeSulTrackDetail ultimoStatusTrackin = encomendaEncontrada.tracking[0];

    encomenda.ultimoStatus = ultimoStatusTrackin.ocorrencia;
    encomenda.finalizado = Finalizado.N;
    encomenda.ultimaAtualizacao = ultimoStatusTrackin.descricao;
    encomenda.dataUltimoStatus = ultimoStatusTrackin.data_hora;

    Encomenda encomendaSalva = await encomendaDao.save(encomenda);
    encomendaSalva.redeSulList = encomendaEncontrada.tracking;
    onSucess(encomendaSalva);

  }

}

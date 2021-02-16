import 'dart:convert';

import 'package:http/http.dart';
import 'package:tracking_app/services/api_services/redesul/redesul_api_config.dart';

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

  // Future<RedeSulTrack> save(RedeSulTrack transaction) async {
  //   final String transactionJson = jsonEncode(transaction.toJson());
  //
  //   final Response response = await client.post(baseUrl,
  //       headers: {
  //         'Content-type': 'application/json',
  //         'password': '1000',
  //       },
  //       body: transactionJson);
  //
  //   return Transaction.fromJson(jsonDecode(response.body));
  // }

}

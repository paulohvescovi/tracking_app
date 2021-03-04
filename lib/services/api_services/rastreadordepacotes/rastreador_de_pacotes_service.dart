import 'package:tracking_app/models/encomenda.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:tracking_app/services/api_services/rastreadordepacotes/models/rastreador_de_pacotes.dart';
import 'dart:convert';

class RastreadorDePacotesService {
  buscarEncomendaSequoia(String codigoRastreio,
      {Function onSucess, Function onError}) async {
    http.Response response = await http.get(
        'https://www.rastreadordepacotes.com.br/rastreio/sequoia/' +
            codigoRastreio);

    dom.Document document = parser.parse(response.body);

    List<dom.Element> elementsByClassName =
        document.getElementsByClassName('is-hidden-mobile');

    if (elementsByClassName == null || elementsByClassName.isEmpty) {
      onSucess(null);
      return;
    }

    String text = document.outerHtml;
    int index = text.indexOf("var pacote = ");
    int inde2 = text.indexOf("\"};");

    String jsonString = text.substring(index, inde2);
    jsonString = jsonString.replaceAll("var pacote = ", "");
    jsonString = jsonString + "\"}";

    var map = json.decode(jsonString) as Map;

    RastreadorDePacotes rastreadorDePacotes = RastreadorDePacotes.fromJson(map);

    onSucess(rastreadorDePacotes);
  }
}

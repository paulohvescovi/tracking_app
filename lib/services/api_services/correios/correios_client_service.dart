import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:tracking_app/enums/EmpresasDisponiveis.dart';
import 'package:tracking_app/enums/Finalizado.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/models/encomenda_detail.dart';
import 'package:tracking_app/services/api_services/rastreadordepacotes/models/rastreador_de_pacotes.dart';
import 'package:tracking_app/services/api_services/rastreadordepacotes/rastreador_de_pacotes_service.dart';
import 'package:tracking_app/services/database_services/encomenda_dao.dart';
import 'package:tracking_app/utils/date_utils.dart';

class CorreioClientService {
  RastreadorDePacotesService rastreadorDePacotesService =
      new RastreadorDePacotesService();
  EncomendaDao encomendaDao = new EncomendaDao();

  buscarEncomendaCorreiosLinkCorreios(
      Encomenda encomenda, Function onSucess, Function onError) async {
    try {
      http.Response response = await http
          .get('https://www.linkcorreios.com.br/' + encomenda.codigoRastreio);

      dom.Document document = parser.parse(response.body);

      List<dom.Element> elementsByClassName =
          document.getElementsByClassName('linha_status');

      if (elementsByClassName == null || elementsByClassName.isEmpty) {
        onSucess(null);
        return;
      }
      encomenda.details = List();

      for (dom.Element elementRastreio in elementsByClassName) {
        EncomendaDetail encomendaDetail = new EncomendaDetail();

        String status = elementRastreio.nodes[1].nodes[1].nodes.toString();
        String data = elementRastreio.nodes[3].nodes[0].toString();
        String local = elementRastreio.nodes[5].nodes[0].toString();

        status = status.replaceAll("[\"", "");
        status = status.replaceAll("\"]", "");
        data = data.replaceAll("[\"", "");
        data = data.replaceAll("\"]", "");
        data = data.replaceAll("\"", "");
        local = local.replaceAll("[\"", "");
        local = local.replaceAll("\"]", "");
        local = local.replaceAll("\"", "");

        String dataString =
            data.substring(8, 18) + " " + data.substring(27, 32);
        String descricao = status +
            " em " +
            dataString +
            " / " +
            (local.replaceAll("Local:", ""));

        encomendaDetail.ocorrencia = status;
        encomendaDetail.cidade = local;
        encomendaDetail.data_hora = dataString;
        encomendaDetail.descricao = descricao;

        if (status.contains("trânsito")) {
          encomendaDetail.tipo = "Em transporte";
        } else if (status.contains("postado")) {
          encomendaDetail.tipo = "Postado";
        } else if (status.contains("entregue")) {
          encomendaDetail.tipo = "Concluido";
        } else {
          String _tipo;
        }

        encomenda.details.add(encomendaDetail);
      }

      encomenda.details.sort(
          (a, b) => b.getDataHoraDatetime().compareTo(a.getDataHoraDatetime()));
      EncomendaDetail ultimoStatusTrackin = encomenda.details[0];

      encomenda.ultimoStatus = ultimoStatusTrackin.ocorrencia;
      encomenda.finalizado = Finalizado.N;
      encomenda.ultimaAtualizacao = ultimoStatusTrackin.descricao;
      encomenda.dataUltimoStatus = ultimoStatusTrackin.data_hora;
      encomenda.empresa = EmpresasDisponiveis.CORREIOS;

      Encomenda encomendaSalva = await encomendaDao.save(encomenda);

      onSucess(encomendaSalva);
    } catch (erro) {
      onError();
      return;
    }
  }

  buscarEncomendaCorreios(
      Encomenda encomenda, Function onSucess, Function onError) {
    rastreadorDePacotesService
        .buscarEncomenda(EmpresasDisponiveis.CORREIOS, encomenda.codigoRastreio,
            onSucess: (RastreadorDePacotes enc) {
      if (enc == null) {
        onSucess(null);
        return;
      }
      encomenda.ultimoStatus = enc.status;
      encomenda.finalizado = Finalizado.N;
      encomenda.ultimaAtualizacao = enc.detalhes[0].data;
      encomenda.cpf = "";
      encomenda.empresa = EmpresasDisponiveis.CORREIOS;

      encomendaDao.save(encomenda).then((endomendaSalva) {
        encomenda = endomendaSalva;
        encomenda.details = List();
        enc.detalhes.forEach((trackin) {
          EncomendaDetail encomendaDetail = new EncomendaDetail();

          String dataString = DateUtil.format(
              trackin.getDataHoraEfetiva(), DateUtil.PATTERN_DATETIME);

          encomendaDetail.ocorrencia = trackin.detalhes;
          encomendaDetail.data_hora = dataString;
          encomendaDetail.descricao = trackin.detalhesFormatado;

          if (trackin.statusPosicao.contains("Entregue")) {
            encomendaDetail.tipo = "Mercadoria Entregue";
          } else if (trackin.statusPosicao.contains("SaiuParaEntrega")) {
            encomendaDetail.tipo = "Em processo de entrega no destino";
          } else if (trackin.statusPosicao.contains("AguardandoRetirada")) {
            encomendaDetail.tipo = "Aguardando Retirada";
          } else if (trackin.statusPosicao.contains("ChegouNoBrasil")) {
            encomendaDetail.tipo = "Chegou no Brasil";
          } else if (trackin.statusPosicao.contains("EmTransito")) {
            encomendaDetail.tipo = "Em Transferência para outra unidade";
          } else if (trackin.statusPosicao.contains("Postado")) {
            encomendaDetail.tipo = "Mercadoria Postada";
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

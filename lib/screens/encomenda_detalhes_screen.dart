
import 'package:flutter/material.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/services/api_services/redesul/models/redesul_track_detail.dart';
import 'package:tracking_app/utils/date_utils.dart';

class EncomendaDetalhesScreen extends StatefulWidget {

  Encomenda encomenda;

  EncomendaDetalhesScreen(this.encomenda);

  @override
  _EncomendaDetalhesScreenState createState() => _EncomendaDetalhesScreenState(encomenda);
}

class _EncomendaDetalhesScreenState extends State<EncomendaDetalhesScreen> {

  Encomenda encomenda;

  _EncomendaDetalhesScreenState(this.encomenda);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(encomenda.nome),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            RedeSulTrackDetail detail = encomenda.redeSulList[index];
            return Card(
              child: ListTile(
                title: Text(detail.ocorrencia + " " + DateUtil.format(DateUtil.getDateTime(detail.data_hora, DateUtil.PATTERN_REDESUL), DateUtil.PATTERN_DEFAULT)),
                subtitle: Text(detail.descricao),
              ),
            );
          },
          itemCount: encomenda.redeSulList.length,
        ),
      ),
    );
  }
}

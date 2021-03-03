import 'package:flutter/material.dart';
import 'package:tracking_app/models/encomenda.dart';
import 'package:tracking_app/models/encomenda_detail.dart';

class EncomendaDetalhesScreen extends StatefulWidget {
  Encomenda encomenda;

  EncomendaDetalhesScreen(this.encomenda);

  @override
  _EncomendaDetalhesScreenState createState() =>
      _EncomendaDetalhesScreenState(encomenda);
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
            EncomendaDetail detail = encomenda.details[index];
            return Card(
              child: ListTile(
                title: Text(detail.ocorrencia + " " + detail.data_hora),
                subtitle: Text(detail.descricao),
              ),
            );
          },
          itemCount: encomenda.details.length,
        ),
      ),
    );
  }
}

import 'package:tracking_app/services/api_services/rastreadordepacotes/models/rastreador_de_pacotes_details.dart';
import 'package:tracking_app/services/api_services/rastreadordepacotes/models/rastreador_de_pacotes_informacoes_remessa.dart';

class RastreadorDePacotes {
  String _codigoRastreio;
  String _codigoRastreioOriginal;
  String _codigoRastreioStr;
  String _status;
  int _qtdDias;
  String _qtdDiasStr;
  List<RastreadorDePacotesDetails> _detalhes;
  String _fromCountry;
  String _festinationCountry;
  String _categoria;
  String _nomeTipoCategoria;
  List<RastreadorDePacotesInformacoesRemessa> _informacoesRemessa;
  int _idTransportadora;
  String _nomeTransportadora;
  int _idPacote;
  bool _sucesso;
  String _message;

  RastreadorDePacotes(
    this._codigoRastreio,
    this._codigoRastreioOriginal,
    this._codigoRastreioStr,
    this._status,
    this._qtdDias,
    this._qtdDiasStr,
    this._detalhes,
    this._fromCountry,
    this._festinationCountry,
    this._categoria,
    this._nomeTipoCategoria,
    this._informacoesRemessa,
    this._idTransportadora,
    this._nomeTransportadora,
    this._idPacote,
    this._sucesso,
    this._message,
  );

  RastreadorDePacotes.fromJson(Map<String, dynamic> json)
      : _codigoRastreio = json['CodigoRastreio'],
        _codigoRastreioOriginal = json['CodigoRastreioOriginal'],
        _codigoRastreioStr = json['CodigoRastreioStr'],
        _status = json['Status'],
        _qtdDias = json['QtdDias'],
        _qtdDiasStr = json['QtdDiasStr'],
        _detalhes = getDetails(json['Posicoes']),
        _fromCountry = json['FromCountry'],
        _festinationCountry = json['DestinationCountry'],
        _categoria = json['Categoria'],
        _nomeTipoCategoria = json['NomeTipoCategoria'],
        _informacoesRemessa = getInformacoesRemessa(json['Vrf']),
        _idTransportadora = json['IdTransportadora'],
        _nomeTransportadora = json['NomeTransportadora'],
        _idPacote = json['Id'],
        _sucesso = json['Success'],
        _message = json['Message'];

  Map<String, dynamic> toJson() => {
        'CodigoRastreio': codigoRastreio,
        'CodigoRastreioOriginal': codigoRastreioOriginal,
        'CodigoRastreioStr': codigoRastreioStr,
        'Status': status,
        'QtdDias': qtdDias,
        'QtdDiasStr': qtdDiasStr,
        'Posicoes': _detalhes,
        'FromCountry': fromCountry,
        'DestinationCountry': festinationCountry,
        'Categoria': categoria,
        'Vrf': informacoesRemessa,
        'IdTransportadora': idTransportadora,
        'NomeTransportadora': nomeTransportadora,
        'Id': idPacote,
        'Success': sucesso,
        'Message': message
      };

  static List<RastreadorDePacotesDetails> getDetails(List<dynamic> values) {
    List<RastreadorDePacotesDetails> retorno = List();
    for (var value in values) {
      var redeSulTrackDetail = RastreadorDePacotesDetails.fromJson(value);
      retorno.add(redeSulTrackDetail);
    }
    return retorno;
  }

  static List<RastreadorDePacotesInformacoesRemessa> getInformacoesRemessa(
      List<dynamic> values) {
    List<RastreadorDePacotesInformacoesRemessa> retorno = List();
    for (var value in values) {
      var redeSulTrackDetail =
          RastreadorDePacotesInformacoesRemessa.fromJson(value);
      retorno.add(redeSulTrackDetail);
    }
    return retorno;
  }

  String get codigoRastreio => this._codigoRastreio;

  set codigoRastreio(String value) => this._codigoRastreio = value;

  get codigoRastreioOriginal => this._codigoRastreioOriginal;

  set codigoRastreioOriginal(value) => this._codigoRastreioOriginal = value;

  get codigoRastreioStr => this._codigoRastreioStr;

  set codigoRastreioStr(value) => this._codigoRastreioStr = value;

  String get status => this._status;

  set status(value) => this._status = value;

  get qtdDias => this._qtdDias;

  set qtdDias(value) => this._qtdDias = value;

  get qtdDiasStr => this._qtdDiasStr;

  set qtdDiasStr(value) => this._qtdDiasStr = value;

  List<RastreadorDePacotesDetails> get detalhes => this._detalhes;

  set detalhes(value) => this._detalhes = value;

  get fromCountry => this._fromCountry;

  set fromCountry(value) => this._fromCountry = value;

  get festinationCountry => this._festinationCountry;

  set festinationCountry(value) => this._festinationCountry = value;

  get categoria => this._categoria;

  set categoria(value) => this._categoria = value;

  get nomeTipoCategoria => this._nomeTipoCategoria;

  set nomeTipoCategoria(value) => this._nomeTipoCategoria = value;

  List<RastreadorDePacotesInformacoesRemessa> get informacoesRemessa =>
      this._informacoesRemessa;

  set informacoesRemessa(value) => this._informacoesRemessa = value;

  get idTransportadora => this._idTransportadora;

  set idTransportadora(value) => this._idTransportadora = value;

  get nomeTransportadora => this._nomeTransportadora;

  set nomeTransportadora(value) => this._nomeTransportadora = value;

  get idPacote => this._idPacote;

  set idPacote(value) => this._idPacote = value;

  get sucesso => this._sucesso;

  set sucesso(value) => this._sucesso = value;

  get message => this._message;

  set message(value) => this._message = value;
}

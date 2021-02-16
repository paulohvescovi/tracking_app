
class RedeSulTrackHeader {

  String _remetente;
  String _destinatario;

  RedeSulTrackHeader(this._remetente, this._destinatario);

  RedeSulTrackHeader.fromJson(Map<String, dynamic> json):
        _remetente = json['remetente'],
        _destinatario = json['destinatario'];

  Map<String, dynamic> toJson() => {
    'remetente': _remetente,
    'destinatatio': _destinatario
  };

}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tracking_app/utils/constants.dart';

class DonationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doação"),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Text(
                "Gostou do App?",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54
                ),
              ),

              Text(
                "Quer fazer uma doação?",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54
                ),
              ),
              Text(
                "Quer ajudar com o desenvolvimento?",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36),
              ),
              Image.asset(
                'images/picpay.png',
                width: 250,
              ),
              Text(
                Constants.PICPAY,
                style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black54
                ),
              ),
              RaisedButton(
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(text: Constants.PICPAY));
                    NAlertDialog alertDialog = NAlertDialog(
                      title: Text("PICPAY"),
                      content: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Copiado com sucesso!"),
                      ),
                      actions: [
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                    alertDialog.show(context);
                  },
                  child: Text(
                    "Copiar picpay",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36),
              ),
              Image.asset(
                'images/pix.png',
                width: 250,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Text(
                Constants.PIX,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: Constants.PIX));
                  NAlertDialog alertDialog = NAlertDialog(
                    title: Text("Chave PIX"),
                    content: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Chave copiada com sucesso!"),
                    ),
                    actions: [
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                  alertDialog.show(context);
                },
                child: Text(
                  "Copiar chave",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

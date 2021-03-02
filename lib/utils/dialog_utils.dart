import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:path/path.dart';

class DialogUtils {
  static NAlertDialog ok(BuildContext context, String body,
      {String title, Function onOkClick}) {
    NAlertDialog alertDialog = NAlertDialog(
      title: Text(title != null ? title : "Ops"),
      content: Padding(
        padding: EdgeInsets.all(16),
        child: Text(body),
      ),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            onOkClick != null ? onOkClick() : Navigator.of(context).pop();
          },
        )
      ],
    );
    alertDialog.show(context);
    return alertDialog;
  }

  static ProgressDialog loading(BuildContext context, String message) {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      message: Text(message),
      title: Text("Aguarde"),
      // dismissable: false
    );
    progressDialog.show();
    return progressDialog;
  }
}

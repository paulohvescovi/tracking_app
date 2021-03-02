import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:path/path.dart';
import 'package:select_dialog/select_dialog.dart';

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

  static SelectDialog select(BuildContext context, String title, List<String> options, Function onSelect) {
    SelectDialog.showModal<String>(
      context,
      showSearchBox: false,
      label: title,
      selectedValue: "",
      items: options,
      onChange: (String selected) {
        onSelect(selected);
      },
    );
  }
}

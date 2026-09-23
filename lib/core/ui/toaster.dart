import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

abstract interface class Toaster {
  void show(String message);
}

class FlutterToastToaster implements Toaster {
  const FlutterToastToaster();

  @override
  void show(String message) {
    unawaited(Fluttertoast.cancel());
    unawaited(
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      ),
    );
  }
}

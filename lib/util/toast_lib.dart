import 'package:fluttertoast/fluttertoast.dart';
import 'package:recollar/util/configuration.dart';

class ToastLib{
  static void error(String msg){
    Fluttertoast.cancel();
    Fluttertoast.showToast(

        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: colorBlack.withOpacity(0.5),
        textColor: colorWhite,
        fontSize: 14
    );
}
  static void ok(String msg){
    Fluttertoast.cancel();
    Fluttertoast.showToast(

        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: colorBlack.withOpacity(0.5),
        textColor: colorWhite,
        fontSize: 14
    );
  }
}
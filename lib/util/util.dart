import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_medic_by_ferian/page/login.dart';
import 'package:smart_medic_by_ferian/util/session.dart';

dialog(_context, msg, {title}) {
  showDialog(
    context: _context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Perhatian!'),
        content: Text(msg),
      );
    },
  );
}

Widget largetButton(
    {String label = "Simpan", IconData iconData, Function onPressed}) {
  iconData = iconData ?? Icons.done_all;
  return Container(
    height: 60,
    width: double.infinity,
    child: new RaisedButton.icon(
        disabledColor: Colors.grey,
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        elevation: 4.0,
        icon: Icon(iconData, color: Colors.white),
        color: Colors.blue,
        onPressed: onPressed),
  );
}

String toRupiah(int val) {
  return NumberFormat.currency(locale: 'IDR').format(val);
}

void logOut(BuildContext context) {
  clearSession().then((value) => Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return LoginPage();
      }, transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }),
      (route) => false));
}

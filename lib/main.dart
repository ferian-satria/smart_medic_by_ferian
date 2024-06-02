import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_medic_by_ferian/page/login.dart';
import 'package:smart_medic_by_ferian/page/modul_pasien/index.dart' as IndexPasien;
import 'package:smart_medic_by_ferian/page/modul_pegawai/index.dart' as IndexPegawai;
import 'package:smart_medic_by_ferian/util/session.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: FutureBuilder(
        future: _loadSession(),
        builder: (context, snapshot) {
          final SharedPreferences prefs = snapshot.data;
          Widget result;
          if (snapshot.connectionState == ConnectionState.waiting) {
            result = Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (prefs.getBool(IS_LOGIN) ?? false) {
                if (prefs.getString(JENIS_LOGIN) ==
                    jenisLogin.PASIEN.toString()) {
                  result = IndexPasien.IndexPage();
                } else {
                  result = IndexPegawai.IndexPage();
                }
              } else {
                result = LoginPage();
              }
            } else {
              return Container(child: Text('Error..'));
            }
          }

          return result;
        },
      ),
    );
  }

  Future _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}

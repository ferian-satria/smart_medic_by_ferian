import 'package:flutter/material.dart';
import 'package:smart_medic_by_ferian/model/regis_poli.dart';
import 'package:smart_medic_by_ferian/page/list_widget/regis_poli.dart';
import 'package:smart_medic_by_ferian/page/modul_pasien/regis_poli/create.dart'
    as RegisPoliCreate;
import 'package:smart_medic_by_ferian/util/util.dart';

class RegisPoliContent extends StatefulWidget {
  static String title = "Registrasi Poli";

  @override
  _RegisPoliContentState createState() => _RegisPoliContentState();
}

class _RegisPoliContentState extends State<RegisPoliContent> {
  Future<List<RegisPoli>> regisPolis;

  @override
  void initState() {
    super.initState();
    regisPolis = fetchRegisPolis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RegisPoliCreate.CreatePage()));
            if (result != null) {
              dialog(context, result);
              setState(() {
                regisPolis = fetchRegisPolis();
              });
            }
          },
          backgroundColor: Colors.teal,
          child: Icon(Icons.edit)),
      body: Center(
        child: FutureBuilder(
            future: regisPolis,
            builder: (context, snapshot) {
              Widget result;
              if (snapshot.hasError) {
                result = Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                result = RegisPoliList(regisPolis: snapshot.data);
              } else {
                result = CircularProgressIndicator();
              }
              return result;
            }),
      ),
    );
  }
}

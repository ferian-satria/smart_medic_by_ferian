import 'package:flutter/material.dart';
import 'package:smart_medic_by_ferian/model/pesan_obat.dart';
import 'package:smart_medic_by_ferian/page/list_widget/pesan_obat_pegawai.dart';
import 'package:smart_medic_by_ferian/util/util.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Future<List<PesanObat>> pesanObats;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  _reloadData() {
    setState(() {
      pesanObats = fetchPesanObats(isSelesai: '0');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Index Pegawai'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => logOut(context))
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: pesanObats,
            builder: (context, snapshot) {
              Widget result;
              if (snapshot.hasError) {
                result = Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                result = PesanObatPegawaiList(
                    parentAction: _reloadData, pesanObats: snapshot.data);
              } else {
                result = CircularProgressIndicator();
              }
              return result;
            }),
      ),
    );
  }
}

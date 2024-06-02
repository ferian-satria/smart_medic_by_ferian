import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_medic_by_ferian/util/config.dart';
import 'package:http/http.dart' as http;
import 'package:smart_medic_by_ferian/util/session.dart';
import 'pasien.dart';
import 'dokter.dart';

class RegisPoli {
  final String idRegisPoli, tglBooking, poli;
  final Pasien idPasien;
  final Dokter idDokter;

  RegisPoli(
      {this.idRegisPoli,
      this.idPasien,
      this.idDokter,
      this.tglBooking,
      this.poli});

  factory RegisPoli.fromJson(Map<String, dynamic> json) {
    return RegisPoli(
        idRegisPoli: json['id_regis_poli'],
        idPasien: Pasien.fromJson(json['id_pasien']),
        idDokter: Dokter.fromJson(json['id_dokter']),
        tglBooking: json['tgl_booking'],
        poli: json['poli']);
  }
}

List<RegisPoli> regisPoliFromJson(jsonData) {
  List<RegisPoli> result =
      List<RegisPoli>.from(jsonData.map((item) => RegisPoli.fromJson(item)));

  return result;
}

Future<List<RegisPoli>> fetchRegisPolis() async {
  final prefs = await SharedPreferences.getInstance();
  String idPasien = prefs.getString(ID_PASIEN) ?? "";
  String route =
      AppConfig.API_ENDPOINT + "regis-poli/index.php?id_pasien=$idPasien";
  final response = await http.get(route);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return regisPoliFromJson(jsonResp);
  } else {
    throw Exception('Failed load $route, status : ${response.statusCode}');
  }
}

Future regisPoliCreate(RegisPoli regisPoli) async {
  final prefs = await SharedPreferences.getInstance();
  String route = AppConfig.API_ENDPOINT + "regis-poli/create.php";
  try {
    final response = await http.post(route,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id_pasien': prefs.getString(ID_PASIEN),
          'id_dokter': regisPoli.idDokter.idDokter,
          'tgl_booking': regisPoli.tglBooking,
          'poli': regisPoli.poli
        }));

    return response;
  } catch (e) {
    print("Error : ${e.toString()}");
    return null;
  }
}

Future deleteRegisPoli(id) async {
  String route = AppConfig.API_ENDPOINT + "regis-poli/delete.php?id=$id";
  final response = await http.get(route);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return jsonResp['message'];
  } else {
    return response.body.toString();
  }
}

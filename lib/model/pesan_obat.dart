import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_medic_by_ferian/util/config.dart';
import 'package:smart_medic_by_ferian/util/session.dart';
import 'pasien.dart';

class PesanObat {
  final String idPesanObat,
      waktu,
      alamat,
      lat,
      lng,
      listPesanan,
      totalBiaya,
      ket;
  bool isSelesai;

  final Pasien idPasien;

  PesanObat(
      {this.idPesanObat,
      this.idPasien,
      this.waktu,
      this.alamat,
      this.lat,
      this.lng,
      this.listPesanan,
      this.totalBiaya,
      this.ket,
      this.isSelesai});

  factory PesanObat.fromJson(Map<String, dynamic> json) {
    return PesanObat(
        idPesanObat: json['id_pesan_obat'],
        idPasien: Pasien.fromJson(json['id_pasien']),
        waktu: json['waktu'],
        alamat: json['alamat'],
        lat: json['lat'],
        lng: json['lng'],
        listPesanan: json['list_pesanan'],
        totalBiaya: json['total_biaya'],
        ket: json['ket'] ?? "",
        isSelesai: (json['is_selesai'] == "1") ? true : false);
  }
}

List<PesanObat> pesanObatFromJson(jsonData) {
  List<PesanObat> result =
      List<PesanObat>.from(jsonData.map((item) => PesanObat.fromJson(item)));

  return result;
}

Future<List<PesanObat>> fetchPesanObats({isSelesai}) async {
  isSelesai = isSelesai ?? "";
  final prefs = await SharedPreferences.getInstance();
  String idPasien = prefs.getString(ID_PASIEN) ?? "";
  String route = AppConfig.API_ENDPOINT +
      "pesan-obat/index.php?id_pasien=$idPasien&is_selesai=$isSelesai";
  final response = await http.get(route);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return pesanObatFromJson(jsonResp);
  } else {
    throw Exception('Failed load $route, status : ${response.statusCode}');
  }
}

Future pesanObatCreate(PesanObat pesanObat) async {
  final prefs = await SharedPreferences.getInstance();
  String route = AppConfig.API_ENDPOINT + "pesan-obat/create.php";
  try {
    final response = await http.post(route,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id_pasien': prefs.getString(ID_PASIEN),
          'alamat': pesanObat.alamat,
          'lat': pesanObat.lat,
          'lng': pesanObat.lng,
          'list_pesanan': pesanObat.listPesanan,
          'total_biaya': pesanObat.totalBiaya,
          'ket': pesanObat.ket
        }));

    return response;
  } catch (e) {
    print("Error : ${e.toString()}");
    return null;
  }
}

Future deletePesanObat(id) async {
  String route = AppConfig.API_ENDPOINT + "pesan-obat/delete.php?id=$id";
  final response = await http.get(route);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return jsonResp['message'];
  } else {
    return response.body.toString();
  }
}

Future updatePesanObat(id) async {
  String route = AppConfig.API_ENDPOINT + "pesan-obat/update.php?id=$id";
  final response = await http.get(route);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return jsonResp['message'];
  } else {
    return response.body.toString();
  }
}

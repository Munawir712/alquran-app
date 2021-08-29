import 'dart:convert';

import 'package:alquran_app/model/al-quran/detail_surah.dart';
import 'package:alquran_app/model/al-quran/list_alquran.dart';
import 'package:http/http.dart' as http;

class AlQuranServices {
	static String baseURL = "https://api.quran.sutanlab.id/surah/";
	
	static Future<List<ListAlQuran>> getListAlquran({http.Client client, String query}) async {
		client ??= http.Client();
		
		final response = await client.get(Uri.parse(baseURL));

		if(response.statusCode != 200) {
			print("get data failed");
		}

		final data = jsonDecode(response.body);

		List<ListAlQuran> listAlQuran = (data['data'] as Iterable).map((e) => ListAlQuran.fromJson(e)).toList();
		if(query != null) {
			listAlQuran = listAlQuran.where((e) => e.name.transliteration.id.toLowerCase().contains(query.toLowerCase())).toList();
		}
		return listAlQuran;

	}

	static Future<DetailSurah> getDetailSurah(int idSurah, {http.Client client}) async {
		client ??= http.Client();

		final response = await client.get(Uri.parse(baseURL + "/$idSurah"));

		if(response.statusCode != 200) {
			print('get data failed');
		}

		final data = jsonDecode(response.body);

		return DetailSurah.fromJson(data['data']); 
	}
}
import 'dart:convert';

import 'package:alquran_app/model/hadits/hadits.dart';
import 'package:alquran_app/model/hadits/hadits_people.dart';

import 'package:http/http.dart' as http;

class HaditsServices {
	static String baseURL = "https://api-hadits.azharimm.tk/books";

	static Future<List<Hadits>> getListHadist({http.Client client}) async {
		client ??= http.Client();

		final response = await client.get(Uri.parse(baseURL));

		if(response.statusCode != 200) {
			print("get data failed");
		}

		final data = jsonDecode(response.body);

		List<Hadits> listHadist = (data['data'] as Iterable).map((e) => Hadits.fromJson(e)).toList();

		return listHadist;
	}

	static Future<List<HaditsPeople>> getHaditsByPeople({http.Client client, String idPeople, int page}) async {
		// String url = "$baseURL/$idPeople?page=$page}";
		String url = "https://api-hadits.azharimm.tk/books/$idPeople?page=$page";

		client ??= http.Client();

		final response = await client.get(Uri.parse(url));

		if(response.statusCode != 200) {
			print("get data failed");
		}

		final data = jsonDecode(response.body);

		List<HaditsPeople> listHaditsPoeple = (data['data']['hadits'] as Iterable).map((e) => HaditsPeople.fromJson(e)).toList();

		return listHaditsPoeple;

	}

}
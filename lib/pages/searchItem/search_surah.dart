import 'package:alquran_app/model/al-quran/list_alquran.dart';
import 'package:alquran_app/pages/detail_surah_page.dart';
import 'package:alquran_app/services/al-quran_services.dart';
import 'package:alquran_app/theme.dart';
import 'package:flutter/material.dart';

class SearchSurah extends SearchDelegate{
	List<ListAlQuran> listAlquran = [];
  @override
  List<Widget> buildActions(BuildContext context) {
			return [
				IconButton(icon: Icon(Icons.cancel), onPressed: (){
					query = '';
				})
			];
		}
	
		@override
		Widget buildLeading(BuildContext context) {
			return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context));
		}
	
		@override
		Widget buildResults(BuildContext context) {
			return FutureBuilder<List<ListAlQuran>>(
				future: AlQuranServices.getListAlquran(query: query),
				builder: (context, snapshot) {
					if(snapshot.hasData) {
						listAlquran = snapshot.data;
						return ListView.separated(
							padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
							itemCount: listAlquran.length,
							separatorBuilder: (context, index) => SizedBox(height: 10), 
							itemBuilder: (context, index) {
								return InkWell(
									onTap: () => Navigator.push(context, MaterialPageRoute(
										builder: (context) => DetailSurahPage(idSurah: listAlquran[index].number, nameSurah: listAlquran[index].name.transliteration.id,)
										)
									),
								  child: Container(
								  	decoration: BoxDecoration(
								  		color: Colors.white,
								  		borderRadius: BorderRadius.circular(6),
								  		boxShadow: [
								  			BoxShadow(
								  				color: Colors.black12.withOpacity(0.3),
								  				blurRadius: 2.1,
								  			),
								  		]
								  	),
								    child: ListTile(
								    	leading: Container(
												height: 50,
												width: 50,
												alignment: Alignment.center,
												decoration: BoxDecoration(
													shape: BoxShape.circle,
													color: Colors.white,
													// border: Border.all(),
													image: DecorationImage(
														image: AssetImage("assets/segidelapan.png"),
														fit: BoxFit.cover,
													)
												),
												child: Text(listAlquran[index].number.toString(), style: TextStyle(fontSize: 14, color: Colors.lightBlue),),
											),
								    	title: Text(listAlquran[index].name.transliteration.id),
								    	subtitle: Text(
								    		"${listAlquran[index].name.translation.id} | ${listAlquran[index].numberOfVerses} Ayat"
								    	),
								    	trailing: Text(listAlquran[index].name.short, style: arabicFont.copyWith(fontSize: 24),),
								    ),
								  ),
								);
							}, 
						);
					} else {
						return Center(child: CircularProgressIndicator(),);
					}
				},
			);
		}
	
		@override
		Widget buildSuggestions(BuildContext context) {
			return Center(child: Text("Cari Surah"));
  	}

}
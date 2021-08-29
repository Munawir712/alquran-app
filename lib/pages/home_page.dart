import 'package:alquran_app/model/al-quran/list_alquran.dart';
import 'package:alquran_app/pages/detail_surah_page.dart';
import 'package:alquran_app/pages/searchItem/search_surah.dart';
import 'package:alquran_app/services/al-quran_services.dart';
import 'package:alquran_app/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

	@override
	_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	List<ListAlQuran> listAlquran = [];

	@override
  void initState() {
    super.initState();
		// listAlquran = AlQuranServices.getListAlquran();
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.lightBlue,
			appBar: AppBar(
				title: Text("Al-Quran App"),
				elevation: 0,
				backgroundColor: Colors.lightBlue,
				centerTitle: true,
				actions: [
					IconButton(
						icon: Icon(Icons.search), 
						onPressed: () => showSearch(context: context, delegate: SearchSurah())
					)
				],
			),
			body: FutureBuilder<List<ListAlQuran>>(
				future: AlQuranServices.getListAlquran(),
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
			),
		);
	}
}



class RPSCustomPainter extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint_0 = new Paint()
      ..color = Color.fromARGB(255, 252, 252, 252)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
     
         
    Path path_0 = Path();
    path_0.moveTo(size.width*0.4987500,size.height*0.2020000);
    path_0.lineTo(size.width*0.4400000,size.height*0.2980000);
    path_0.lineTo(size.width*0.3750000,size.height*0.3020000);
    path_0.lineTo(size.width*0.3737500,size.height*0.4000000);
    path_0.lineTo(size.width*0.3112500,size.height*0.4980000);
    path_0.lineTo(size.width*0.3762500,size.height*0.5980000);
    path_0.lineTo(size.width*0.3750000,size.height*0.7020000);
    path_0.lineTo(size.width*0.4375000,size.height*0.7020000);
    path_0.lineTo(size.width*0.5000000,size.height*0.7960000);
    path_0.lineTo(size.width*0.5625000,size.height*0.7020000);
    path_0.lineTo(size.width*0.6262500,size.height*0.7020000);
    path_0.lineTo(size.width*0.6250000,size.height*0.5980000);
    path_0.lineTo(size.width*0.6862500,size.height*0.5040000);
    path_0.lineTo(size.width*0.6275000,size.height*0.4020000);
    path_0.lineTo(size.width*0.6237500,size.height*0.2980000);
    path_0.lineTo(size.width*0.5625000,size.height*0.2980000);
    path_0.lineTo(size.width*0.4987500,size.height*0.2020000);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}

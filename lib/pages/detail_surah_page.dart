import 'package:alquran_app/model/al-quran/detail_surah.dart';
import 'package:alquran_app/services/al-quran_services.dart';
import 'package:alquran_app/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DetailSurahPage extends StatefulWidget {
	final int idSurah;
	final String nameSurah; 
	const DetailSurahPage({ Key key, this.idSurah, this.nameSurah }) : super(key: key);

	@override
	_DetailSurahPageState createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends State<DetailSurahPage> {
	AudioPlayer audioPlayer = AudioPlayer();
	DetailSurah detailSurah;
	List<Verse> listSurah;
	int indexAudio = 0;
	List<String> urlAudio = [];
	int ayat = 0;
	int _currentSelectedAyat = -1;
	bool autoPlay = false;
	bool showButtomPlay = false;

	@override
  void initState() {
    super.initState();
		ayatEnd();
		// getDetailSurah();
  }

	void getDetailSurah() async {
		detailSurah = await AlQuranServices.getDetailSurah(widget.idSurah);
		setState(() {});
	}

	void ayatEnd() {
		audioPlayer.onPlayerCompletion.listen((event) { 
			setState(() {
			  _currentSelectedAyat = -1;
				indexAudio = 0;
				ayat = indexAudio;
			});
			if(autoPlay) {
				autoPlayAyat();
			}
		});
	}

	void autoPlayAyat() async {
		if(indexAudio == urlAudio.length -1) {
			setState(() {
				indexAudio = 0;
				ayat = indexAudio;
				_currentSelectedAyat = -1;
				audioPlayer.stop();
			});
		} else {
			setState(() {
				indexAudio++;
				ayat = indexAudio;
			});
			_currentSelectedAyat = indexAudio;
			if(_currentSelectedAyat == indexAudio) {
				await audioPlayer.play(urlAudio[indexAudio]);
			}
		}
	}

	@override
  void dispose() {
    super.dispose();
		audioPlayer.dispose();
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.red,
			appBar: AppBar(
				title: Text(widget.nameSurah),
				centerTitle: true,
				backgroundColor: Colors.lightBlue,
				elevation: 0,
				actions: [
					// IconButton(icon: Icon(Icons.more_vert), onPressed: (){}),
					PopupMenuButton(
						itemBuilder: (context) => List.generate(1, (index) => 
							PopupMenuItem(
								value: autoPlay,
								child: Row(
								  children: [
								    Text("Auto Play: "),
								    Text(autoPlay ? "Enable" : "Disable"),
								  ],
								),
							)
						),
						onSelected: (bool val) {
							setState((){autoPlay = !val;});
							SnackBar snackBar = SnackBar(content: Text("Auto Play: " +  (autoPlay ? "Enable" : "Disable"),), duration: Duration(seconds: 1),);
							ScaffoldMessenger.of(context).showSnackBar(snackBar);
						},
					),
				],
			),
			body: FutureBuilder<DetailSurah>(
				future: AlQuranServices.getDetailSurah(widget.idSurah),
				builder: (context, snapshot) {
					if(snapshot.hasData) {
						detailSurah = snapshot.data;
						return Stack(
						  children: [
						    ListView(
						    	// padding: EdgeInsets.symmetric(vertical: 10, ),
						      children: [
						    		detailSurah.number == 1 
						    		? Container() 
						    		: Container(
						    			height: 100,
						    			alignment: Alignment.center,
						    			decoration: BoxDecoration(
						    				color: Colors.white,
						    			),
						    			child: Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", style: arabicFont.copyWith(fontSize: 30, fontWeight: FontWeight.bold),),
						    		),
						        Container(
						          child: ListView.builder(
						    				shrinkWrap: true,
						          	physics: NeverScrollableScrollPhysics(),
						          	itemCount: detailSurah.verses.length,
						          	// separatorBuilder: (context, index) => SizedBox(height: 10,), 
						          	itemBuilder: (context, index) {
						          		var surah = detailSurah.verses[index];
						    					urlAudio = detailSurah.verses.map((e) => e.audio.primary).toList();
						    					return GestureDetector(
						    					  onTap: () {
															setState(() {
															  showButtomPlay = !showButtomPlay;
																indexAudio = index;
																ayat = indexAudio;
															});
														},
						    					  child: SurahItem(surah: surah, color: index % 2 == 0 ? Colors.lightBlue.shade50 : Colors.white),
						    					);
						          	}, 
						          ),
						        ),
										SizedBox(height: 100,)
						      ],
						    ),
								Align(
									alignment: Alignment.bottomCenter,
								  child: BottomAppBar(
								  	color: Colors.lightBlue,
								  	child: showButtomPlay ? playAudioSurah() : SizedBox(),
								  ),
								),
								
						  ],
						);
					} else {
						return Center(child: CircularProgressIndicator(),);
					}
				},
			),
		);
	}

	Widget playAudioSurah() {
	return Container(
		padding: EdgeInsets.symmetric(vertical: 8),
		height: 100,
		child: Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				Text(widget.nameSurah, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
				Text("Ayat ${ayat+1}/${detailSurah.verses.length}", style: TextStyle(fontSize: 14, color: Colors.white),),
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						IconButton(
							icon: Icon(Icons.skip_previous, color: Colors.white,), 
							onPressed: () async {
								setState(() {
									indexAudio == 0 ? indexAudio = urlAudio.length -1 : indexAudio-- ;
									ayat = indexAudio;
								});
								_currentSelectedAyat = indexAudio;
								if(_currentSelectedAyat == indexAudio) {
									await audioPlayer.play(urlAudio[indexAudio]);
								}
							} 
						),
						IconButton(
							icon: Icon(
								_currentSelectedAyat != indexAudio ? Icons.play_circle_fill : Icons.pause_circle_filled, 
								color: Colors.white,
								size: 30,
							),
							onPressed: () async {
								// print(urlAudio);
								//  print(indexAudio);
								// print(ayat);
								if(_currentSelectedAyat == indexAudio) {
									_currentSelectedAyat = -1;
										if(_currentSelectedAyat == -1) {
											await audioPlayer.pause();
										}
								} else {
									_currentSelectedAyat = indexAudio;
									if(_currentSelectedAyat == indexAudio) {
										await audioPlayer.play(urlAudio[indexAudio]);
									}
								}
								setState(() {
									
								});
							}
						),
						IconButton(
							icon: Icon(Icons.skip_next_rounded, color: Colors.white,), 
							onPressed: () async {
								if(indexAudio == urlAudio.length -1) {
									setState(() {
										indexAudio = 0;
										ayat = 0;
									});
									_currentSelectedAyat = indexAudio;
									if(_currentSelectedAyat == indexAudio) {
										await audioPlayer.play(urlAudio[indexAudio]);
									}
								} else {
									setState(() {
										indexAudio++;
										ayat++;
									});
									_currentSelectedAyat = indexAudio;
									if(_currentSelectedAyat == indexAudio) {
										await audioPlayer.play(urlAudio[indexAudio]);
									}
								}
							}
						),
					],
				),
			],
		),
	);
}


}

class SurahItem extends StatelessWidget {
	final Color color;
	final Verse surah;
	const SurahItem({ Key key, this.surah, this.color }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.symmetric(vertical: 10, ),
			decoration: BoxDecoration(
				color: color,
				// borderRadius: BorderRadius.circular(6)
			),
			child: ListTile(
				leading: Container(
					height: 30,
					width: 30,
					alignment: Alignment.center,
					decoration: BoxDecoration(
						image: DecorationImage(
							image: AssetImage("assets/segidelapan.png"),
							fit: BoxFit.cover,
						)
					),
					child: Text(surah.number.inSurah.toString(), style: TextStyle(fontSize: 12),),
				),
				title: Text(
					surah.text.arab,
					style: arabicFont.copyWith(fontSize: 30, ),
					textAlign: TextAlign.end,
				),
				subtitle: Text(surah.translation.id, style: arabicFont.copyWith(fontWeight: FontWeight.w700),),
			)
		);
	}
}


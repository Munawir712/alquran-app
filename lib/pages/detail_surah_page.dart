import 'package:alquran_app/model/al-quran/detail_surah.dart';
import 'package:alquran_app/services/al-quran_services.dart';
import 'package:alquran_app/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DetailSurahPage extends StatefulWidget {
	final int idSurah;
	final String nameSurah; 
	const DetailSurahPage({ Key key, this.idSurah, this.nameSurah }) : super(key: key);

	@override
	_DetailSurahPageState createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends State<DetailSurahPage> {
	AudioPlayer audioPlayer = AudioPlayer();
	ScrollController scrollController = ScrollController();
	DetailSurah detailSurah;
	List<Verse> listSurah;
	int indexAudio = 0;
	List<String> urlAudio = [];
	int ayat = 0;
	int _currentSelectedAyat = -1;
	bool autoPlay = false;
	bool showButtomPlay = true;

	@override
  void initState() {
    super.initState();
		ayatEnd();
		// getDetailSurah();
		// scrollController.addListener(listenScrollUp);
  }

	// listenScrollUp() {
	// 	final direction = scrollController.position.userScrollDirection;
	// 		if(direction == ScrollDirection.reverse) {
	// 			setState(() {
	// 			  showButtomPlay = false;
	// 			});	
	// 		} else {
	// 			setState(() {
	// 			  showButtomPlay = true;
	// 			});
	// 		} 
	// }

	void ayatEnd() {
		audioPlayer.onPlayerCompletion.listen((event) { 
			setState(() {
			  _currentSelectedAyat = -1;
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
			// backgroundColor: Colors.red,
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
									controller: scrollController,
						      children: [
										Container(
											padding: EdgeInsets.symmetric(horizontal: 11),
											color: Colors.lightBlue.shade200,
											child: Row(
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
												children: [
													Text(
														"${detailSurah.numberOfVerses} Ayat",
														style: arabicFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
													),
													Text(
														"Juz " + detailSurah.verses.first.meta.juz.toString(),
														style: arabicFont.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
													),
												],
											),
										),
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
						    					  child: Stack(
						    					    children: [
						    					      SurahItem(surah: surah, enable: _currentSelectedAyat == indexAudio && indexAudio == index, color: index % 2 == 0 ? Colors.lightBlue.shade50 : Colors.white),
																if(_currentSelectedAyat == indexAudio && indexAudio == index)
																	Positioned(
																		left: 5,
																		top: 5,
																		child: Text("Playing ...", style: TextStyle(color: Colors.blue)),
																	),
						    					    ],
						    					  ),
						    					);
						          	}, 
						          ),
						        ),
										showButtomPlay ? SizedBox(height: 100,) : SizedBox()
						      ],
						    ),
								Align(
									alignment: Alignment.bottomCenter,
								  child: showButtomPlay ? playAudioSurah() : SizedBox(),
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
		decoration: BoxDecoration(color: Colors.lightBlue, borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
		child: Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				Text(widget.nameSurah, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),),
				Text("Ayat ${ayat+1}/${detailSurah.verses.length}", style: TextStyle(fontSize: 14, color: Colors.white),),
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						IconButton(
							icon: Icon(Icons.skip_previous_rounded, color: Colors.white,), 
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
	final enable;
	const SurahItem({ Key key, this.surah, this.color, this.enable = true }) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.symmetric(vertical: 10, ),
			decoration: BoxDecoration(
				color: color,
				// borderRadius: BorderRadius.circular(6)
			),
			child: ListTile(
				selected: enable,
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


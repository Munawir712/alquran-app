import 'package:alquran_app/model/hadits/hadits.dart';
import 'package:alquran_app/pages/detail_list_hadits.dart';
import 'package:alquran_app/services/hadits_services.dart';
import 'package:flutter/material.dart';

class HaditsPage extends StatefulWidget {
	const HaditsPage({ Key key }) : super(key: key);

	@override
	_HaditsPageState createState() => _HaditsPageState();
}

class _HaditsPageState extends State<HaditsPage> {
	List<Hadits> listHadits;

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Hadits>>(
			future: HaditsServices.getListHadist(),
			builder: (context, snapshot) {
				if(snapshot.hasData) {
					listHadits = snapshot.data;
					return ListView.builder(
						itemCount: listHadits.length,
						itemBuilder: (context, index) {
							return GestureDetector(
								onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailListHadits(idPeople: listHadits[index].id, name: listHadits[index].name,))),
							  child: Container(
							  	decoration: BoxDecoration(
							  		color: Colors.white,
							  		border: Border(bottom: BorderSide(color: index != listHadits.length-1 ? Colors.black12 : Colors.transparent) ),
							  	),
							  	child: ListTile(
							  		leading: Container(
							  			height: 30,
							  			width: 30,
							  			alignment: Alignment.center,
							  			decoration: BoxDecoration(
							  				color: Colors.lightBlue.shade300,
							  				shape: BoxShape.circle
							  			),
							  			child: Text("${index + 1}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
							  		),
							  		title: Text(listHadits[index].name),
							  		trailing: Text(listHadits[index].available.toString(), style: TextStyle(fontSize: 12, color: Colors.grey),),
							  	),
							  ),
							);
						}
					);
				} else {
					return Center(child: CircularProgressIndicator());
				}
 			},
		);
	}
}
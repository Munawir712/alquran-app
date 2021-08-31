import 'package:alquran_app/model/hadits/hadits_people.dart';
import 'package:alquran_app/services/hadits_services.dart';
import 'package:alquran_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DetailListHadits extends StatefulWidget {
	final String idPeople;
	final String name;
	const DetailListHadits({ Key key, this.idPeople, this.name  }) : super(key: key);

	@override
	_DetailListHaditsState createState() => _DetailListHaditsState();
}

class _DetailListHaditsState extends State<DetailListHadits> {
	ScrollController scrollController = ScrollController();
	List<HaditsPeople> listHaditsPeople = [];
	int page = 1;

	bool hasReachMax = false;
	bool _isLoading = false;
	bool isShow = false;

	bool get _isLoadingMore => _isLoading && page > 1;

	@override
  void initState() {
    super.initState();
		getListHaditsPeople();
		scrollController.addListener(onScroll);
  }

	void getListHaditsPeople() async {
		listHaditsPeople = await HaditsServices.getHaditsByPeople(idPeople: widget.idPeople, page: page);
		setState(() {
		  
		}); 
	}

	void onScroll() async {
		double maxScroll = scrollController.position.maxScrollExtent;
		double currentScroll = scrollController.position.pixels;
		var scrollDirection = scrollController.position.userScrollDirection;
		if(currentScroll == maxScroll) {
			loadPerPage();
		}
		if(scrollDirection == ScrollDirection.forward) {
			setState(() {
			  isShow = true;
			});
		} else  {
			setState(() {
			  isShow = false;
			});
		}
	}

	Future<void> loadPerPage() async {
		if(!_isLoading) {
			setState(() {
			  _isLoading = true;
			});

			List<HaditsPeople> listHadits = await HaditsServices.getHaditsByPeople(idPeople: widget.idPeople, page: page + 1);

			setState(() {
			  if(listHadits == null) {
					print("fect Data faild ");
				} else {
					if(listHadits.isEmpty) {
						hasReachMax = true;
					} else {
						listHaditsPeople = [...listHaditsPeople, ...listHadits];
						page += 1;
						hasReachMax = false;
					}
				}
			});

			setState(() {
			  _isLoading = false;
			});

		}
	}

	void scrollToTop() {
		scrollController.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
	}

	void scrollToBottom() {
		double maxScroll = scrollController.position.maxScrollExtent;
		scrollController.animateTo(maxScroll, duration: Duration(milliseconds: 200), curve: Curves.linear);
	}

	@override
	Widget build(BuildContext context) {
		
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.name),
			),
			floatingActionButton: isShow ? Row(
				mainAxisAlignment: MainAxisAlignment.end,
			  children: [
			    FloatingActionButton(
			    	mini: true,
			    	child: Icon(Icons.arrow_downward),
			    	onPressed: scrollToBottom,
			    ),
			    FloatingActionButton(
			    	mini: true,
			    	child: Icon(Icons.arrow_upward),
			    	onPressed: scrollToTop,
			    ),
			  ],
			) : SizedBox(),
			body:Builder(
				builder: (context) {
					// if(_isLoading) {
					// 	return Center(child: CircularProgressIndicator());
					// }
					if(listHaditsPeople != null) {
						return ListView.builder(
							controller: scrollController,
							itemCount: listHaditsPeople.length + 1,
							itemBuilder: (context, index) {
								bool isItem = index < listHaditsPeople.length;
								bool isLastIndex = index == listHaditsPeople.length;
								bool isLoadingMore = isLastIndex && _isLoadingMore;
								if(isItem) {
									return Container(
										decoration: BoxDecoration(
											color: Colors.white,
											border: Border(bottom: BorderSide(color: index != listHaditsPeople.length -1 ? Colors.black12 : Colors.transparent))
										),
										child: listTileHadits(listHaditsPeople[index]),
									);
								}
								if(isLoadingMore) return Center(child: CircularProgressIndicator(),);
								return Container();
							}
						);
					} else {
						Center(child: CircularProgressIndicator());
					}
					return Container();
				}
			),
		);
	}

	ListTile listTileHadits(HaditsPeople hadits) {
	  return ListTile(
			leading: CircleAvatar(
				radius: 15,
				backgroundColor: Colors.lightBlue.shade300,
				child: Text(hadits.number.toString(), style: TextStyle(color: Colors.white),),
			),
			title: Text(hadits.arab, style: arabicFont.copyWith(fontSize: 30), textAlign: TextAlign.right),
			subtitle: Text(hadits.id),
		);
	}
}


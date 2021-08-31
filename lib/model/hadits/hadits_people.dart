class HaditsPeople {
	int number;
	String arab;
	String id;

	HaditsPeople({this.number, this.arab, this.id});

	factory HaditsPeople.fromJson(Map<String, dynamic> json) => HaditsPeople(
		number: json['number'],
		arab: json['arab'],
		id: json['id'],
	);
	
}
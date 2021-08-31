class Hadits {
	String id;
	int available;
	String name;
	
	Hadits({
		this.id,
		this.available,
		this.name
	});

	factory Hadits.fromJson(Map<String, dynamic> json) => Hadits(
		id: json['id'],
		available: json['available'],
		name: json['name']
	);
}
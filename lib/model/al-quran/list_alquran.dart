class ListAlQuran {
	int number;
	int sequence;
	int numberOfVerses;
	Name name;
	Revelation revelation;
	Tafsir tafsir;

	ListAlQuran({
		this.number,
		this.sequence,
		this.numberOfVerses,
		this.revelation,
		this.tafsir,
	});

	ListAlQuran.fromJson(Map<String, dynamic> json) {
		number = json['number'];
		sequence = json['sequence'];
		numberOfVerses = json['numberOfVerses'];
		name = json['name'] != null ? Name.fromJson(json['name']) : null;
		revelation = json['revelation'] != null ? Revelation.fromJson(json['revelation']) : null;
		tafsir = json['tafsir'] != null ? Tafsir.fromJson(json['tafsir']) : null; 
	}

}

class Name {
	String short;
	String long;
	TransliterationAlQuran transliteration;
	TransliterationAlQuran translation;

	Name({this.short, this.long, this.transliteration, this.translation});

	Name.fromJson(Map<String, dynamic> json) {
		short = json['short'];
		long = json['long'];
		transliteration = json['transliteration'] != null ? TransliterationAlQuran.fromJson(json['transliteration'])  : null;
		translation = json['translation'] != null ? TransliterationAlQuran.fromJson(json['translation']) : null;
	}
}

class TransliterationAlQuran {
	String en;
	String id;

	TransliterationAlQuran({this.en, this.id});

	TransliterationAlQuran.fromJson(Map<String, dynamic> json) {
		en = json['en'];
		id = json['id'];
	}
}

class Revelation {
	String arab;
	String en;
	String id;

	Revelation({this.arab, this.en, this.id});

	Revelation.fromJson(Map<String, dynamic> json) {
		arab = json['arab'];
		en = json['en'];
		id = json['id'];
	}
}

class Tafsir {
	String id;

	Tafsir({this.id});

	Tafsir.fromJson(Map<String, dynamic> json) {
		id = json['id'];
	}
}
class DetailSurah {
	int number;
	int sequence;
	int numberOfVerses;
	Name name;
	Revelation revelation;
	DataTafsir tafsir;
	dynamic preBismillah;
	List<Verse> verses;
	
	DetailSurah({
		this.number, 
		this.sequence, 
		this.numberOfVerses, 
		this.name, 
		this.revelation, 
		this.tafsir, 
		this.preBismillah, 
		this.verses
	});

	factory DetailSurah.fromJson(Map<String, dynamic> json) => DetailSurah(
		number: json['number'],
		sequence: json['sequence'],
		numberOfVerses: json['numberOfVerses'],
		name: Name.fromJson(json['name']),
		revelation: Revelation.fromJson(json['revelation']),
		tafsir: DataTafsir.fromJson(json['tafsir']),
		preBismillah: json['preBismillah'],
		verses: List<Verse>.from(json['verses'].map((e) => Verse.fromJson(e))),
	);
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

class DataTafsir {
	String id;

	DataTafsir({this.id});

	DataTafsir.fromJson(Map<String, dynamic> json) {
		id = json['id'];
	}
}

class Verse {
	Number number;
	Meta meta;
	TextQuran text;
	TransliterationAlQuran translation;
	Audio audio;
	VerseTafsir tafsir;

	Verse({
		this.number,
		this.meta,
		this.text,
		this.translation,
		this.audio,
		this.tafsir,
	});
	
	factory Verse.fromJson(Map<String, dynamic> json) => Verse(
		number: Number.fromJson(json['number']),
		meta: Meta.fromJson(json['meta']),
		text: TextQuran.fromJson(json['text']),
		audio: Audio.fromJson(json['audio']),
		translation: TransliterationAlQuran.fromJson(json['translation']),
		tafsir: VerseTafsir.fromJson(json['tafsir']) 
	);

}

class Number {
	int inQuran;
	int inSurah;

	Number({this.inQuran, this.inSurah});

	factory Number.fromJson(Map<String, dynamic> json) => Number(
		inQuran: json['inQuran'],
		inSurah: json['inSurah'],
	);
}

class Meta {
	int juz;
	int page;
	int manzil;
	int ruku;
	int hizbQuarter;
	Sajda sajda;

	Meta({this.juz, this.page, this.manzil, this.ruku, this.hizbQuarter, this.sajda});

	factory Meta.fromJson(Map<String, dynamic> json) => Meta(
		juz: json['juz'],
		page: json['page'],
		manzil: json['manzil'],
		ruku: json['ruku'],
		hizbQuarter: json['hizbQuarter'],
		sajda: Sajda.fromJson(json['sajda']),
	);
}

class Sajda {
	bool recommended;
	bool obligatory;

	Sajda({this.recommended, this.obligatory});

	factory Sajda.fromJson(Map<String, dynamic> json) => Sajda(
		recommended: json['recommended'], 
		obligatory: json['obligatory']
	);
}

class TextQuran {
	String arab;
	TransliterationAlQuran transliteration;

	TextQuran({this.arab, this.transliteration});

	factory TextQuran.fromJson(Map<String, dynamic> json) => TextQuran(
		arab: json['arab'],
		transliteration: TransliterationAlQuran.fromJson(json['transliteration']), 
	);
}

class Audio {
	String primary;
	List<String> secondary;

	Audio({this.primary, this.secondary});

	factory Audio.fromJson(Map<String, dynamic> json) => Audio(
		primary: json['primary'],
		secondary: List<String>.from(json['secondary'].map((e) => e)), 
	);
}

class VerseTafsir {
	Id id;

	VerseTafsir({this.id});
	factory VerseTafsir.fromJson(Map<String, dynamic> json) => VerseTafsir(id: Id.fromJson(json['id']));
}

class Id {
	String short;
	String long;

	Id({this.short, this.long});

	factory Id.fromJson(Map<String, dynamic> json) => Id(short: json['short'], long: json['long']);
}
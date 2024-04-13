import 'dart:convert';

class PrayerTimeModel {
  final int code;
  final String status;
  final List<Datum> data;

  PrayerTimeModel({
    required this.code,
    required this.status,
    required this.data,
  });

  PrayerTimeModel copyWith({
    int? code,
    String? status,
    List<Datum>? data,
  }) =>
      PrayerTimeModel(
        code: code ?? this.code,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory PrayerTimeModel.fromJson(String str) =>
      PrayerTimeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrayerTimeModel.fromMap(Map<String, dynamic> json) => PrayerTimeModel(
        code: json["code"],
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  final Timings timings;
  final Date date;
  final Meta meta;

  Datum({
    required this.timings,
    required this.date,
    required this.meta,
  });

  Datum copyWith({
    Timings? timings,
    Date? date,
    Meta? meta,
  }) =>
      Datum(
        timings: timings ?? this.timings,
        date: date ?? this.date,
        meta: meta ?? this.meta,
      );

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        timings: Timings.fromMap(json["timings"]),
        date: Date.fromMap(json["date"]),
        meta: Meta.fromMap(json["meta"]),
      );

  Map<String, dynamic> toMap() => {
        "timings": timings.toMap(),
        "date": date.toMap(),
        "meta": meta.toMap(),
      };
}

class Date {
  final String readable;
  final String timestamp;
  final Gregorian gregorian;
  final Hijri hijri;

  Date({
    required this.readable,
    required this.timestamp,
    required this.gregorian,
    required this.hijri,
  });

  Date copyWith({
    String? readable,
    String? timestamp,
    Gregorian? gregorian,
    Hijri? hijri,
  }) =>
      Date(
        readable: readable ?? this.readable,
        timestamp: timestamp ?? this.timestamp,
        gregorian: gregorian ?? this.gregorian,
        hijri: hijri ?? this.hijri,
      );

  factory Date.fromJson(String str) => Date.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Date.fromMap(Map<String, dynamic> json) => Date(
        readable: json["readable"],
        timestamp: json["timestamp"],
        gregorian: Gregorian.fromMap(json["gregorian"]),
        hijri: Hijri.fromMap(json["hijri"]),
      );

  Map<String, dynamic> toMap() => {
        "readable": readable,
        "timestamp": timestamp,
        "gregorian": gregorian.toMap(),
        "hijri": hijri.toMap(),
      };
}

class Gregorian {
  final String date;
  final String format;
  final String day;
  final GregorianWeekday weekday;
  final GregorianMonth month;
  final String year;
  final Designation designation;

  Gregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
  });

  Gregorian copyWith({
    String? date,
    String? format,
    String? day,
    GregorianWeekday? weekday,
    GregorianMonth? month,
    String? year,
    Designation? designation,
  }) =>
      Gregorian(
        date: date ?? this.date,
        format: format ?? this.format,
        day: day ?? this.day,
        weekday: weekday ?? this.weekday,
        month: month ?? this.month,
        year: year ?? this.year,
        designation: designation ?? this.designation,
      );

  factory Gregorian.fromJson(String str) => Gregorian.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Gregorian.fromMap(Map<String, dynamic> json) => Gregorian(
        date: json["date"],
        format: json["format"],
        day: json["day"],
        weekday: GregorianWeekday.fromMap(json["weekday"]),
        month: GregorianMonth.fromMap(json["month"]),
        year: json["year"],
        designation: Designation.fromMap(json["designation"]),
      );

  Map<String, dynamic> toMap() => {
        "date": date,
        "format": format,
        "day": day,
        "weekday": weekday.toMap(),
        "month": month.toMap(),
        "year": year,
        "designation": designation.toMap(),
      };
}

class Designation {
  final String abbreviated;
  final String expanded;

  Designation({
    required this.abbreviated,
    required this.expanded,
  });

  Designation copyWith({
    String? abbreviated,
    String? expanded,
  }) =>
      Designation(
        abbreviated: abbreviated ?? this.abbreviated,
        expanded: expanded ?? this.expanded,
      );

  factory Designation.fromJson(String str) =>
      Designation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Designation.fromMap(Map<String, dynamic> json) => Designation(
        abbreviated: json["abbreviated"],
        expanded: json["expanded"],
      );

  Map<String, dynamic> toMap() => {
        "abbreviated": abbreviated,
        "expanded": expanded,
      };
}

class GregorianMonth {
  final int number;
  final String en;

  GregorianMonth({
    required this.number,
    required this.en,
  });

  GregorianMonth copyWith({
    int? number,
    String? en,
  }) =>
      GregorianMonth(
        number: number ?? this.number,
        en: en ?? this.en,
      );

  factory GregorianMonth.fromJson(String str) =>
      GregorianMonth.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GregorianMonth.fromMap(Map<String, dynamic> json) => GregorianMonth(
        number: json["number"],
        en: json["en"],
      );

  Map<String, dynamic> toMap() => {
        "number": number,
        "en": en,
      };
}

class GregorianWeekday {
  final String en;

  GregorianWeekday({
    required this.en,
  });

  GregorianWeekday copyWith({
    String? en,
  }) =>
      GregorianWeekday(
        en: en ?? this.en,
      );

  factory GregorianWeekday.fromJson(String str) =>
      GregorianWeekday.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GregorianWeekday.fromMap(Map<String, dynamic> json) =>
      GregorianWeekday(
        en: json["en"],
      );

  Map<String, dynamic> toMap() => {
        "en": en,
      };
}

class Hijri {
  final String date;
  final String format;
  final String day;
  final HijriWeekday weekday;
  final HijriMonth month;
  final String year;
  final Designation designation;
  final List<String> holidays;

  Hijri({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
    required this.holidays,
  });

  Hijri copyWith({
    String? date,
    String? format,
    String? day,
    HijriWeekday? weekday,
    HijriMonth? month,
    String? year,
    Designation? designation,
    List<String>? holidays,
  }) =>
      Hijri(
        date: date ?? this.date,
        format: format ?? this.format,
        day: day ?? this.day,
        weekday: weekday ?? this.weekday,
        month: month ?? this.month,
        year: year ?? this.year,
        designation: designation ?? this.designation,
        holidays: holidays ?? this.holidays,
      );

  factory Hijri.fromJson(String str) => Hijri.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hijri.fromMap(Map<String, dynamic> json) => Hijri(
        date: json["date"],
        format: json["format"],
        day: json["day"],
        weekday: HijriWeekday.fromMap(json["weekday"]),
        month: HijriMonth.fromMap(json["month"]),
        year: json["year"],
        designation: Designation.fromMap(json["designation"]),
        holidays: List<String>.from(json["holidays"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "date": date,
        "format": format,
        "day": day,
        "weekday": weekday.toMap(),
        "month": month.toMap(),
        "year": year,
        "designation": designation.toMap(),
        "holidays": List<dynamic>.from(holidays.map((x) => x)),
      };
}

class HijriMonth {
  final int number;
  final String en;
  final String ar;

  HijriMonth({
    required this.number,
    required this.en,
    required this.ar,
  });

  HijriMonth copyWith({
    int? number,
    String? en,
    String? ar,
  }) =>
      HijriMonth(
        number: number ?? this.number,
        en: en ?? this.en,
        ar: ar ?? this.ar,
      );

  factory HijriMonth.fromJson(String str) =>
      HijriMonth.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HijriMonth.fromMap(Map<String, dynamic> json) => HijriMonth(
        number: json["number"],
        en: json["en"],
        ar: json["ar"],
      );

  Map<String, dynamic> toMap() => {
        "number": number,
        "en": en,
        "ar": ar,
      };
}

class HijriWeekday {
  final String en;
  final String ar;

  HijriWeekday({
    required this.en,
    required this.ar,
  });

  HijriWeekday copyWith({
    String? en,
    String? ar,
  }) =>
      HijriWeekday(
        en: en ?? this.en,
        ar: ar ?? this.ar,
      );

  factory HijriWeekday.fromJson(String str) =>
      HijriWeekday.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HijriWeekday.fromMap(Map<String, dynamic> json) => HijriWeekday(
        en: json["en"],
        ar: json["ar"],
      );

  Map<String, dynamic> toMap() => {
        "en": en,
        "ar": ar,
      };
}

class Meta {
  final double latitude;
  final double longitude;
  final String timezone;
  final Method method;
  final String latitudeAdjustmentMethod;
  final String midnightMode;
  final String school;
  final Map<String, int> offset;

  Meta({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.method,
    required this.latitudeAdjustmentMethod,
    required this.midnightMode,
    required this.school,
    required this.offset,
  });

  Meta copyWith({
    double? latitude,
    double? longitude,
    String? timezone,
    Method? method,
    String? latitudeAdjustmentMethod,
    String? midnightMode,
    String? school,
    Map<String, int>? offset,
  }) =>
      Meta(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        timezone: timezone ?? this.timezone,
        method: method ?? this.method,
        latitudeAdjustmentMethod:
            latitudeAdjustmentMethod ?? this.latitudeAdjustmentMethod,
        midnightMode: midnightMode ?? this.midnightMode,
        school: school ?? this.school,
        offset: offset ?? this.offset,
      );

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        timezone: json["timezone"],
        method: Method.fromMap(json["method"]),
        latitudeAdjustmentMethod: json["latitudeAdjustmentMethod"],
        midnightMode: json["midnightMode"],
        school: json["school"],
        offset:
            Map.from(json["offset"]).map((k, v) => MapEntry<String, int>(k, v)),
      );

  Map<String, dynamic> toMap() => {
        "latitude": latitude,
        "longitude": longitude,
        "timezone": timezone,
        "method": method.toMap(),
        "latitudeAdjustmentMethod": latitudeAdjustmentMethod,
        "midnightMode": midnightMode,
        "school": school,
        "offset":
            Map.from(offset).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Method {
  final int id;
  final String name;
  final Params params;

  Method({
    required this.id,
    required this.name,
    required this.params,
  });

  Method copyWith({
    int? id,
    String? name,
    Params? params,
  }) =>
      Method(
        id: id ?? this.id,
        name: name ?? this.name,
        params: params ?? this.params,
      );

  factory Method.fromJson(String str) => Method.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Method.fromMap(Map<String, dynamic> json) => Method(
        id: json["id"],
        name: json["name"],
        params: Params.fromMap(json["params"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "params": params.toMap(),
      };
}

class Params {
  final int fajr;
  final int isha;

  Params({
    required this.fajr,
    required this.isha,
  });

  Params copyWith({
    int? fajr,
    int? isha,
  }) =>
      Params(
        fajr: fajr ?? this.fajr,
        isha: isha ?? this.isha,
      );

  factory Params.fromJson(String str) => Params.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Params.fromMap(Map<String, dynamic> json) => Params(
        fajr: json["Fajr"],
        isha: json["Isha"],
      );

  Map<String, dynamic> toMap() => {
        "Fajr": fajr,
        "Isha": isha,
      };
}

class Timings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;

  Timings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
  });

  Timings copyWith({
    String? fajr,
    String? sunrise,
    String? dhuhr,
    String? asr,
    String? sunset,
    String? maghrib,
    String? isha,
    String? imsak,
    String? midnight,
  }) =>
      Timings(
        fajr: fajr ?? this.fajr,
        sunrise: sunrise ?? this.sunrise,
        dhuhr: dhuhr ?? this.dhuhr,
        asr: asr ?? this.asr,
        sunset: sunset ?? this.sunset,
        maghrib: maghrib ?? this.maghrib,
        isha: isha ?? this.isha,
        imsak: imsak ?? this.imsak,
        midnight: midnight ?? this.midnight,
      );

  factory Timings.fromJson(String str) => Timings.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Timings.fromMap(Map<String, dynamic> json) => Timings(
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        sunset: json["Sunset"],
        maghrib: json["Maghrib"],
        isha: json["Isha"],
        imsak: json["Imsak"],
        midnight: json["Midnight"],
      );

  Map<String, dynamic> toMap() => {
        "Fajr": fajr,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": asr,
        "Sunset": sunset,
        "Maghrib": maghrib,
        "Isha": isha,
        "Imsak": imsak,
        "Midnight": midnight,
      };
}

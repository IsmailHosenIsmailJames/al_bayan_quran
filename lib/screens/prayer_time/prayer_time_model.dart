import 'dart:convert';

class PrayerTimeModel {
  int? code;
  String? status;
  List<Datum>? data;

  PrayerTimeModel({
    this.code,
    this.status,
    this.data,
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
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Timings? timings;
  Date? date;
  Meta? meta;

  Datum({
    this.timings,
    this.date,
    this.meta,
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
        timings:
            json["timings"] == null ? null : Timings.fromMap(json["timings"]),
        date: json["date"] == null ? null : Date.fromMap(json["date"]),
        meta: json["meta"] == null ? null : Meta.fromMap(json["meta"]),
      );

  Map<String, dynamic> toMap() => {
        "timings": timings?.toMap(),
        "date": date?.toMap(),
        "meta": meta?.toMap(),
      };
}

class Date {
  String? readable;
  String? timestamp;
  Gregorian? gregorian;
  Hijri? hijri;

  Date({
    this.readable,
    this.timestamp,
    this.gregorian,
    this.hijri,
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
        gregorian: json["gregorian"] == null
            ? null
            : Gregorian.fromMap(json["gregorian"]),
        hijri: json["hijri"] == null ? null : Hijri.fromMap(json["hijri"]),
      );

  Map<String, dynamic> toMap() => {
        "readable": readable,
        "timestamp": timestamp,
        "gregorian": gregorian?.toMap(),
        "hijri": hijri?.toMap(),
      };
}

class Gregorian {
  String? date;
  String? format;
  String? day;
  GregorianWeekday? weekday;
  GregorianMonth? month;
  String? year;
  Designation? designation;

  Gregorian({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
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
        weekday: json["weekday"] == null
            ? null
            : GregorianWeekday.fromMap(json["weekday"]),
        month: json["month"] == null
            ? null
            : GregorianMonth.fromMap(json["month"]),
        year: json["year"],
        designation: json["designation"] == null
            ? null
            : Designation.fromMap(json["designation"]),
      );

  Map<String, dynamic> toMap() => {
        "date": date,
        "format": format,
        "day": day,
        "weekday": weekday?.toMap(),
        "month": month?.toMap(),
        "year": year,
        "designation": designation?.toMap(),
      };
}

class Designation {
  String? abbreviated;
  String? expanded;

  Designation({
    this.abbreviated,
    this.expanded,
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
  int? number;
  String? en;

  GregorianMonth({
    this.number,
    this.en,
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
  String? en;

  GregorianWeekday({
    this.en,
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
  String? date;
  String? format;
  String? day;
  HijriWeekday? weekday;
  HijriMonth? month;
  String? year;
  Designation? designation;
  List<String>? holidays;

  Hijri({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
    this.holidays,
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
        weekday: json["weekday"] == null
            ? null
            : HijriWeekday.fromMap(json["weekday"]),
        month: json["month"] == null ? null : HijriMonth.fromMap(json["month"]),
        year: json["year"],
        designation: json["designation"] == null
            ? null
            : Designation.fromMap(json["designation"]),
        holidays: json["holidays"] == null
            ? []
            : List<String>.from(json["holidays"]!.map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "date": date,
        "format": format,
        "day": day,
        "weekday": weekday?.toMap(),
        "month": month?.toMap(),
        "year": year,
        "designation": designation?.toMap(),
        "holidays":
            holidays == null ? [] : List<dynamic>.from(holidays!.map((x) => x)),
      };
}

class HijriMonth {
  int? number;
  String? en;
  String? ar;

  HijriMonth({
    this.number,
    this.en,
    this.ar,
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
  String? en;
  String? ar;

  HijriWeekday({
    this.en,
    this.ar,
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
  double? latitude;
  double? longitude;
  String? timezone;
  Method? method;
  String? latitudeAdjustmentMethod;
  String? midnightMode;
  String? school;
  Map<String, int>? offset;

  Meta({
    this.latitude,
    this.longitude,
    this.timezone,
    this.method,
    this.latitudeAdjustmentMethod,
    this.midnightMode,
    this.school,
    this.offset,
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
        method: json["method"] == null ? null : Method.fromMap(json["method"]),
        latitudeAdjustmentMethod: json["latitudeAdjustmentMethod"],
        midnightMode: json["midnightMode"],
        school: json["school"],
        offset: Map.from(json["offset"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
      );

  Map<String, dynamic> toMap() => {
        "latitude": latitude,
        "longitude": longitude,
        "timezone": timezone,
        "method": method?.toMap(),
        "latitudeAdjustmentMethod": latitudeAdjustmentMethod,
        "midnightMode": midnightMode,
        "school": school,
        "offset":
            Map.from(offset!).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Method {
  int? id;
  String? name;
  Params? params;

  Method({
    this.id,
    this.name,
    this.params,
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
        params: json["params"] == null ? null : Params.fromMap(json["params"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "params": params?.toMap(),
      };
}

class Params {
  int? fajr;
  int? isha;

  Params({
    this.fajr,
    this.isha,
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
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? sunset;
  String? maghrib;
  String? isha;
  String? imsak;
  String? midnight;

  Timings({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
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

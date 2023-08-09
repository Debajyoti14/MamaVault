class HospitalList {
  Summary? summary;
  List<Results>? results;

  HospitalList({this.summary, this.results});

  HospitalList.fromJson(Map<String, dynamic> json) {
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  String? queryType;
  int? queryTime;
  int? numResults;
  int? offset;
  int? totalResults;
  int? fuzzyLevel;
  GeoBias? geoBias;
  String? geobiasCountry;

  Summary(
      {this.queryType,
      this.queryTime,
      this.numResults,
      this.offset,
      this.totalResults,
      this.fuzzyLevel,
      this.geoBias,
      this.geobiasCountry});

  Summary.fromJson(Map<String, dynamic> json) {
    queryType = json['queryType'];
    queryTime = json['queryTime'];
    numResults = json['numResults'];
    offset = json['offset'];
    totalResults = json['totalResults'];
    fuzzyLevel = json['fuzzyLevel'];
    geoBias =
        json['geoBias'] != null ? GeoBias.fromJson(json['geoBias']) : null;
    geobiasCountry = json['geobiasCountry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['queryType'] = queryType;
    data['queryTime'] = queryTime;
    data['numResults'] = numResults;
    data['offset'] = offset;
    data['totalResults'] = totalResults;
    data['fuzzyLevel'] = fuzzyLevel;
    if (geoBias != null) {
      data['geoBias'] = geoBias!.toJson();
    }
    data['geobiasCountry'] = geobiasCountry;
    return data;
  }
}

class GeoBias {
  double? lat;
  double? lon;

  GeoBias({this.lat, this.lon});

  GeoBias.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}

class Results {
  String? type;
  String? id;
  double? score;
  double? dist;
  String? info;
  Poi? poi;
  Address? address;
  GeoBias? position;
  Viewport? viewport;
  List<EntryPoints>? entryPoints;
  DataSources? dataSources;

  Results(
      {this.type,
      this.id,
      this.score,
      this.dist,
      this.info,
      this.poi,
      this.address,
      this.position,
      this.viewport,
      this.entryPoints,
      this.dataSources});

  Results.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    score = json['score'];
    dist = json['dist'];
    info = json['info'];
    poi = json['poi'] != null ? Poi.fromJson(json['poi']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    position =
        json['position'] != null ? GeoBias.fromJson(json['position']) : null;
    viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
    if (json['entryPoints'] != null) {
      entryPoints = <EntryPoints>[];
      json['entryPoints'].forEach((v) {
        entryPoints!.add(EntryPoints.fromJson(v));
      });
    }
    dataSources = json['dataSources'] != null
        ? DataSources.fromJson(json['dataSources'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['score'] = score;
    data['dist'] = dist;
    data['info'] = info;
    if (poi != null) {
      data['poi'] = poi!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    if (viewport != null) {
      data['viewport'] = viewport!.toJson();
    }
    if (entryPoints != null) {
      data['entryPoints'] = entryPoints!.map((v) => v.toJson()).toList();
    }
    if (dataSources != null) {
      data['dataSources'] = dataSources!.toJson();
    }
    return data;
  }
}

class Poi {
  String? name;
  String? phone;
  List<CategorySet>? categorySet;
  String? url;
  List<String>? categories;
  List<Classifications>? classifications;

  Poi(
      {this.name,
      this.phone,
      this.categorySet,
      this.url,
      this.categories,
      this.classifications});

  Poi.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    if (json['categorySet'] != null) {
      categorySet = <CategorySet>[];
      json['categorySet'].forEach((v) {
        categorySet!.add(CategorySet.fromJson(v));
      });
    }
    url = json['url'];
    categories = json['categories'].cast<String>();
    if (json['classifications'] != null) {
      classifications = <Classifications>[];
      json['classifications'].forEach((v) {
        classifications!.add(Classifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    if (categorySet != null) {
      data['categorySet'] = categorySet!.map((v) => v.toJson()).toList();
    }
    data['url'] = url;
    data['categories'] = categories;
    if (classifications != null) {
      data['classifications'] =
          classifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategorySet {
  int? id;

  CategorySet({this.id});

  CategorySet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Classifications {
  String? code;
  List<Names>? names;

  Classifications({this.code, this.names});

  Classifications.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['names'] != null) {
      names = <Names>[];
      json['names'].forEach((v) {
        names!.add(Names.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (names != null) {
      data['names'] = names!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Names {
  String? nameLocale;
  String? name;

  Names({this.nameLocale, this.name});

  Names.fromJson(Map<String, dynamic> json) {
    nameLocale = json['nameLocale'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nameLocale'] = nameLocale;
    data['name'] = name;
    return data;
  }
}

class Address {
  String? streetName;
  String? municipalitySubdivision;
  String? municipality;
  String? countrySecondarySubdivision;
  String? countrySubdivision;
  String? countrySubdivisionName;
  String? postalCode;
  String? extendedPostalCode;
  String? countryCode;
  String? country;
  String? countryCodeISO3;
  String? freeformAddress;
  String? localName;
  String? streetNumber;

  Address(
      {this.streetName,
      this.municipalitySubdivision,
      this.municipality,
      this.countrySecondarySubdivision,
      this.countrySubdivision,
      this.countrySubdivisionName,
      this.postalCode,
      this.extendedPostalCode,
      this.countryCode,
      this.country,
      this.countryCodeISO3,
      this.freeformAddress,
      this.localName,
      this.streetNumber});

  Address.fromJson(Map<String, dynamic> json) {
    streetName = json['streetName'];
    municipalitySubdivision = json['municipalitySubdivision'];
    municipality = json['municipality'];
    countrySecondarySubdivision = json['countrySecondarySubdivision'];
    countrySubdivision = json['countrySubdivision'];
    countrySubdivisionName = json['countrySubdivisionName'];
    postalCode = json['postalCode'];
    extendedPostalCode = json['extendedPostalCode'];
    countryCode = json['countryCode'];
    country = json['country'];
    countryCodeISO3 = json['countryCodeISO3'];
    freeformAddress = json['freeformAddress'];
    localName = json['localName'];
    streetNumber = json['streetNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['streetName'] = streetName;
    data['municipalitySubdivision'] = municipalitySubdivision;
    data['municipality'] = municipality;
    data['countrySecondarySubdivision'] = countrySecondarySubdivision;
    data['countrySubdivision'] = countrySubdivision;
    data['countrySubdivisionName'] = countrySubdivisionName;
    data['postalCode'] = postalCode;
    data['extendedPostalCode'] = extendedPostalCode;
    data['countryCode'] = countryCode;
    data['country'] = country;
    data['countryCodeISO3'] = countryCodeISO3;
    data['freeformAddress'] = freeformAddress;
    data['localName'] = localName;
    data['streetNumber'] = streetNumber;
    return data;
  }
}

class Viewport {
  GeoBias? topLeftPoint;
  GeoBias? btmRightPoint;

  Viewport({this.topLeftPoint, this.btmRightPoint});

  Viewport.fromJson(Map<String, dynamic> json) {
    topLeftPoint = json['topLeftPoint'] != null
        ? GeoBias.fromJson(json['topLeftPoint'])
        : null;
    btmRightPoint = json['btmRightPoint'] != null
        ? GeoBias.fromJson(json['btmRightPoint'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (topLeftPoint != null) {
      data['topLeftPoint'] = topLeftPoint!.toJson();
    }
    if (btmRightPoint != null) {
      data['btmRightPoint'] = btmRightPoint!.toJson();
    }
    return data;
  }
}

class EntryPoints {
  String? type;
  GeoBias? position;

  EntryPoints({this.type, this.position});

  EntryPoints.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    position =
        json['position'] != null ? GeoBias.fromJson(json['position']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (position != null) {
      data['position'] = position!.toJson();
    }
    return data;
  }
}

class DataSources {
  Geometry? geometry;

  DataSources({this.geometry});

  DataSources.fromJson(Map<String, dynamic> json) {
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    return data;
  }
}

class Geometry {
  String? id;

  Geometry({this.id});

  Geometry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

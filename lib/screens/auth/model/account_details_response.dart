// To parse this JSON data, do
//
//     final storiesResponse = storiesResponseFromJson(jsonString);
//     final album = albumFromJson(jsonString);
//     final track = trackFromJson(jsonString);

import 'dart:convert';

dynamic storiesResponseFromJson(String str) => json.decode(str);

String storiesResponseToJson(dynamic data) => json.encode(data);

Album albumFromJson(String str) => Album.fromJson(json.decode(str) as Map<String, dynamic>);

String albumToJson(Album data) => json.encode(data.toJson());

Track trackFromJson(String str) => Track.fromJson(json.decode(str) as Map<String, dynamic>);

String trackToJson(Track data) => json.encode(data.toJson());

class AccountDetails {
  AccountDetails({
    this.id,
    this.name,
    this.url,
    this.description,
    this.link,
    this.slug,
    this.avatarUrls,
    this.meta,
    this.links,
  });

  int id;
  String name;
  String url;
  String description;
  String link;
  String slug;
  Map<String, String> avatarUrls;
  List<dynamic> meta;
  Links links;

  factory AccountDetails.fromJson(Map<String, dynamic> json) => AccountDetails(
    id: int.parse(json["id"].toString()),
    name: json["name"].toString(),
    url: json["url"].toString(),
    description: json["description"].toString(),
    link: json["link"].toString(),
    slug: json["slug"].toString(),
    avatarUrls: Map.from(json["avatar_urls"] as Map<String,dynamic>).map((k, v) => MapEntry<String, String>(k.toString(), v.toString())),
    // ignore: avoid_dynamic_calls
    meta: List<dynamic>.from(json["meta"].map((x) => x) as Iterable<dynamic>),
    links: Links.fromJson(json["_links"] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
    "description": description,
    "link": link,
    "slug": slug,
    "avatar_urls": Map.from(avatarUrls).map((k, v) => MapEntry<String, dynamic>(k.toString(), v)),
    "meta": List<dynamic>.from(meta.map((x) => x)),
    "_links": links.toJson(),
  };
}

class Links {
  Links({
    this.self,
    this.collection,
  });

  List<Collection> self;
  List<Collection> collection;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: List<Collection>.from(json["self"].map((x) => Collection.fromJson(x as Map<String, dynamic> )) as Iterable<dynamic>),
    collection: List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x as Map<String, dynamic> )) as Iterable<dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "self": List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
  };
}

class Collection {
  Collection({
    this.href,
  });

  String href;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    href: json["href"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

class ArtistClass {
  ArtistClass({
    this.name,
    this.founded,
    this.members,
  });

  String name;
  int founded;
  List<String> members;

  factory ArtistClass.fromJson(Map<String, dynamic> json) => ArtistClass(
    name: json["name"].toString(),
    founded: int.parse(json["founded"].toString()),
    members: List<String>.from(json["members"].map((x) => x) as Iterable<dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "founded": founded,
    "members": List<dynamic>.from(members.map((x) => x)),
  };
}

class Album {
  Album({
    this.name,
    this.artist,
    this.tracks,
  });

  String name;
  ArtistClass artist;
  List<Track> tracks;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    name: json["name"].toString(),
    artist: ArtistClass.fromJson(json["artist"] as Map<String, dynamic>),
    tracks: List<Track>.from(json["tracks"].map((x) => Track.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "artist": artist.toJson(),
    "tracks": List<dynamic>.from(tracks.map((x) => x.toJson())),
  };
}

class Track {
  Track({
    this.name,
    this.duration,
  });

  String name;
  int duration;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
    name: json["name"].toString(),
    duration: int.parse(json["duration"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "duration": duration,
  };
}

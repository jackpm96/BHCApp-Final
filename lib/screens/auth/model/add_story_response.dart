// To parse this JSON data, do
//
//     final AddStoryResponse = AddStoryResponseFromJson(jsonString);
//     final album = albumFromJson(jsonString);
//     final track = trackFromJson(jsonString);

import 'dart:convert';

AddStoryResponse AddStoryResponseFromJson(String str) => AddStoryResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String AddStoryResponseToJson(AddStoryResponse data) => json.encode(data.toJson());

Album albumFromJson(String str) => Album.fromJson(json.decode(str) as Map<String, dynamic>);

String albumToJson(Album data) => json.encode(data.toJson());

Track trackFromJson(String str) => Track.fromJson(json.decode(str) as Map<String, dynamic>);

String trackToJson(Track data) => json.encode(data.toJson());

class AddStoryResponse {
  AddStoryResponse({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.password,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.commentStatus,
    this.pingStatus,
    this.sticky,
    this.template,
    this.format,
    this.meta,
    this.categories,
    this.tags,
    this.permalinkTemplate,
    this.generatedSlug,
    this.featuredMediaSrcUrl,
    this.links,
    this.name,
    this.founded,
    this.members,
  });

  int id;
  DateTime date;
  DateTime dateGmt;
  Guid guid;
  DateTime modified;
  DateTime modifiedGmt;
  String password;
  String slug;
  String status;
  String type;
  String link;
  Guid title;
  Content content;
  Content excerpt;
  int author;
  int featuredMedia;
  String commentStatus;
  String pingStatus;
  bool sticky;
  String template;
  String format;
  Meta meta;
  List<int> categories;
  List<dynamic> tags;
  String permalinkTemplate;
  String generatedSlug;
  dynamic featuredMediaSrcUrl;
  Links links;
  String name;
  int founded;
  List<String> members;

  factory AddStoryResponse.fromJson(Map<String, dynamic> json) => AddStoryResponse(
    id: json["id"] == null ? null : json["id"] as int,
    date: json["date"] == null ? null : DateTime.parse(json["date"].toString()),
    dateGmt: json["date_gmt"] == null ? null : DateTime.parse(json["date_gmt"].toString()),
    guid: json["guid"] == null ? null : Guid.fromJson(json["guid"] as Map<String, dynamic>),
    modified: json["modified"] == null ? null : DateTime.parse(json["modified"].toString()),
    modifiedGmt: json["modified_gmt"] == null ? null : DateTime.parse(json["modified_gmt"].toString()),
    password: json["password"] == null ? null : json["password"].toString(),
    slug: json["slug"] == null ? null : json["slug"].toString(),
    status: json["status"] == null ? null : json["status"].toString(),
    type: json["type"] == null ? null : json["type"].toString(),
    link: json["link"] == null ? null : json["link"].toString(),
    title: json["title"] == null ? null : Guid.fromJson(json["title"] as Map<String, dynamic>),
    content: json["content"] == null ? null : Content.fromJson(json["content"] as Map<String, dynamic>),
    excerpt: json["excerpt"] == null ? null : Content.fromJson(json["excerpt"] as Map<String, dynamic>),
    author: json["author"] == null ? null : int.parse(json["author"].toString()),
    featuredMedia: json["featured_media"] == null ? null : int.parse(json["featured_media"].toString()),
    commentStatus: json["comment_status"] == null ? null : json["comment_status"].toString(),
    pingStatus: json["ping_status"] == null ? null : json["ping_status"].toString(),
    sticky: json["sticky"] == null ? null : json["sticky"] as bool,
    template: json["template"] == null ? null : json["template"].toString(),
    format: json["format"] == null ? null : json["format"].toString(),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"] as Map<String, dynamic>),
    categories: json["categories"] == null ? null : List<int>.from(json["categories"].map((x) => x) as Iterable<dynamic>),
    tags: json["tags"] == null ? null : List<dynamic>.from(json["tags"].map((x) => x) as Iterable<dynamic>),
    permalinkTemplate: json["permalink_template"] == null ? null : json["permalink_template"].toString(),
    generatedSlug: json["generated_slug"] == null ? null : json["generated_slug"].toString(),
    featuredMediaSrcUrl: json["featured_media_src_url"],
    links: json["_links"] == null ? null : Links.fromJson(json["_links"] as Map<String, dynamic>),
    name: json["name"] == null ? null : json["name"].toString(),
    founded: json["founded"] == null ? null : int.parse(json["founded"].toString()),
    members: json["members"] == null ? null : List<String>.from(json["members"].map((x) => x) as Iterable<dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date": date == null ? null : date.toIso8601String(),
    "date_gmt": dateGmt == null ? null : dateGmt.toIso8601String(),
    "guid": guid == null ? null : guid.toJson(),
    "modified": modified == null ? null : modified.toIso8601String(),
    "modified_gmt": modifiedGmt == null ? null : modifiedGmt.toIso8601String(),
    "password": password == null ? null : password,
    "slug": slug == null ? null : slug,
    "status": status == null ? null : status,
    "type": type == null ? null : type,
    "link": link == null ? null : link,
    "title": title == null ? null : title.toJson(),
    "content": content == null ? null : content.toJson(),
    "excerpt": excerpt == null ? null : excerpt.toJson(),
    "author": author == null ? null : author,
    "featured_media": featuredMedia == null ? null : featuredMedia,
    "comment_status": commentStatus == null ? null : commentStatus,
    "ping_status": pingStatus == null ? null : pingStatus,
    "sticky": sticky == null ? null : sticky,
    "template": template == null ? null : template,
    "format": format == null ? null : format,
    "meta": meta == null ? null : meta.toJson(),
    "categories": categories == null ? null : List<dynamic>.from(categories.map((x) => x)),
    "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
    "permalink_template": permalinkTemplate == null ? null : permalinkTemplate,
    "generated_slug": generatedSlug == null ? null : generatedSlug,
    "featured_media_src_url": featuredMediaSrcUrl,
    "_links": links == null ? null : links.toJson(),
    "name": name == null ? null : name,
    "founded": founded == null ? null : founded,
    "members": members == null ? null : List<dynamic>.from(members.map((x) => x)),
  };
}

class Content {
  Content({
    this.raw,
    this.rendered,
    this.protected,
    this.blockVersion,
  });

  String raw;
  String rendered;
  bool protected;
  int blockVersion;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    raw: json["raw"].toString(),
    rendered: json["rendered"].toString(),
    protected: json["protected"] as bool,
    blockVersion: json["block_version"] == null ? null : int.parse(json["block_version"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "raw": raw,
    "rendered": rendered,
    "protected": protected,
    "block_version": blockVersion == null ? null : blockVersion,
  };
}

class Guid {
  Guid({
    this.rendered,
    this.raw,
  });

  String rendered;
  String raw;

  factory Guid.fromJson(Map<String, dynamic> json) => Guid(
    rendered: json["rendered"].toString(),
    raw: json["raw"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "rendered": rendered,
    "raw": raw,
  };
}

class Links {
  Links({
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
    this.versionHistory,
    this.wpAttachment,
    this.wpTerm,
    this.wpActionPublish,
    this.wpActionUnfilteredHtml,
    this.wpActionSticky,
    this.wpActionAssignAuthor,
    this.wpActionCreateCategories,
    this.wpActionAssignCategories,
    this.wpActionCreateTags,
    this.wpActionAssignTags,
    this.curies,
  });

  List<About> self;
  List<About> collection;
  List<About> about;
  List<Author> author;
  List<Author> replies;
  List<VersionHistory> versionHistory;
  List<About> wpAttachment;
  List<WpTerm> wpTerm;
  List<About> wpActionPublish;
  List<About> wpActionUnfilteredHtml;
  List<About> wpActionSticky;
  List<About> wpActionAssignAuthor;
  List<About> wpActionCreateCategories;
  List<About> wpActionAssignCategories;
  List<About> wpActionCreateTags;
  List<About> wpActionAssignTags;
  List<Cury> curies;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: List<About>.from(json["self"].map((x) => About.fromJson(x as Map<String,dynamic>)) as Iterable<dynamic>),
    collection: List<About>.from(json["collection"].map((x) => About.fromJson(x as Map<String,dynamic>)) as Iterable<dynamic>),
    about: List<About>.from(json["about"].map((x) => About.fromJson(x as Map<String,dynamic>))as Iterable<dynamic>),
    author: List<Author>.from(json["author"].map((x) => Author.fromJson(x as Map<String,dynamic>))as Iterable<dynamic>),
    replies: List<Author>.from(json["replies"].map((x) => Author.fromJson(x as Map<String,dynamic>))as Iterable<dynamic>),
    versionHistory: List<VersionHistory>.from(json["version-history"].map((x) => VersionHistory.fromJson(x as Map<String, dynamic>))as Iterable<dynamic>),
    wpAttachment: List<About>.from(json["wp:attachment"].map((x) => About.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
    wpTerm: List<WpTerm>.from(json["wp:term"].map((x) => WpTerm.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic> ),
    wpActionPublish: List<About>.from(json["wp:action-publish"].map((x) => About.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
    wpActionUnfilteredHtml: List<About>.from(json["wp:action-unfiltered-html"].map((x) => About.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
    wpActionSticky: List<About>.from(json["wp:action-sticky"].map((x) => About.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
    wpActionAssignAuthor: List<About>.from(json["wp:action-assign-author"].map((x) => About.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
    wpActionCreateCategories: List<About>.from(json["wp:action-create-categories"].map((x) => About.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
    wpActionAssignCategories: List<About>.from(json["wp:action-assign-categories"].map((x) => About.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
    wpActionCreateTags: List<About>.from(json["wp:action-create-tags"].map((x) => About.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
    wpActionAssignTags: List<About>.from(json["wp:action-assign-tags"].map((x) => About.fromJson(x as Map<String, dynamic>))as Iterable<dynamic>),
    curies: List<Cury>.from(json["curies"].map((x) => Cury.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "self": List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
    "about": List<dynamic>.from(about.map((x) => x.toJson())),
    "author": List<dynamic>.from(author.map((x) => x.toJson())),
    "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
    "version-history": List<dynamic>.from(versionHistory.map((x) => x.toJson())),
    "wp:attachment": List<dynamic>.from(wpAttachment.map((x) => x.toJson())),
    "wp:term": List<dynamic>.from(wpTerm.map((x) => x.toJson())),
    "wp:action-publish": List<dynamic>.from(wpActionPublish.map((x) => x.toJson())),
    "wp:action-unfiltered-html": List<dynamic>.from(wpActionUnfilteredHtml.map((x) => x.toJson())),
    "wp:action-sticky": List<dynamic>.from(wpActionSticky.map((x) => x.toJson())),
    "wp:action-assign-author": List<dynamic>.from(wpActionAssignAuthor.map((x) => x.toJson())),
    "wp:action-create-categories": List<dynamic>.from(wpActionCreateCategories.map((x) => x.toJson())),
    "wp:action-assign-categories": List<dynamic>.from(wpActionAssignCategories.map((x) => x.toJson())),
    "wp:action-create-tags": List<dynamic>.from(wpActionCreateTags.map((x) => x.toJson())),
    "wp:action-assign-tags": List<dynamic>.from(wpActionAssignTags.map((x) => x.toJson())),
    "curies": List<dynamic>.from(curies.map((x) => x.toJson())),
  };
}

class About {
  About({
    this.href,
  });

  String href;

  factory About.fromJson(Map<String, dynamic> json) => About(
    href: json["href"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

class Author {
  Author({
    this.embeddable,
    this.href,
  });

  bool embeddable;
  String href;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    embeddable: json["embeddable"] as bool,
    href: json["href"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "embeddable": embeddable,
    "href": href,
  };
}

class Cury {
  Cury({
    this.name,
    this.href,
    this.templated,
  });

  String name;
  String href;
  bool templated;

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
    name: json["name"].toString(),
    href: json["href"].toString(),
    templated: json["templated"] as bool,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "href": href,
    "templated": templated,
  };
}

class VersionHistory {
  VersionHistory({
    this.count,
    this.href,
  });

  int count;
  String href;

  factory VersionHistory.fromJson(Map<String, dynamic> json) => VersionHistory(
    count: int.parse(json["count"].toString()),
    href: json["href"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "href": href,
  };
}

class WpTerm {
  WpTerm({
    this.taxonomy,
    this.embeddable,
    this.href,
  });

  String taxonomy;
  bool embeddable;
  String href;

  factory WpTerm.fromJson(Map<String, dynamic> json) => WpTerm(
    taxonomy: json["taxonomy"].toString(),
    embeddable: json["embeddable"] as bool,
    href: json["href"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "taxonomy": taxonomy,
    "embeddable": embeddable,
    "href": href,
  };
}

class Meta {
  Meta({
    this.pmproDefaultLevel,
  });

  int pmproDefaultLevel;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    pmproDefaultLevel: int.parse(json["pmpro_default_level"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "pmpro_default_level": pmproDefaultLevel,
  };
}

class Album {
  Album({
    this.name,
    this.artist,
    this.tracks,
  });

  String name;
  Artist artist;
  List<Track> tracks;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    name: json["name"].toString(),
    artist: Artist.fromJson(json["artist"] as Map<String, dynamic>),
    tracks: List<Track>.from(json["tracks"].map((x) => Track.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "artist": artist.toJson(),
    "tracks": List<dynamic>.from(tracks.map((x) => x.toJson())),
  };
}

class Artist {
  Artist({
    this.name,
    this.founded,
    this.members,
  });

  String name;
  int founded;
  List<String> members;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
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

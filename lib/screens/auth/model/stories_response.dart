// To parse this JSON data, do
//
//     final storiesResponse = storiesResponseFromJson(jsonString);
//     final album = albumFromJson(jsonString);
//     final track = trackFromJson(jsonString);
// To parse this JSON data, do
//
//     final StoriesResponse = StoriesResponseFromJson(jsonString);

import 'dart:convert';

List<StoriesResponse> StoriesResponseFromJson(String str) =>
    List<StoriesResponse>.from(
        json.decode(str).map((x) => StoriesResponse.fromJson(x)));

String StoriesResponseToJson(List<StoriesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoriesResponse {
  StoriesResponse({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
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
    this.featuredMediaSrcUrl,
    this.links,
  });

  int id;
  DateTime date;
  DateTime dateGmt;
  Guid guid;
  DateTime modified;
  DateTime modifiedGmt;
  String slug;
  StatusEnum status;
  Type type;
  String link;
  Guid title;
  Content content;
  Content excerpt;
  int author;
  int featuredMedia;
  Status commentStatus;
  Status pingStatus;
  bool sticky;
  String template;
  Format format;
  Meta meta;
  List<int> categories;
  List<dynamic> tags;
  String featuredMediaSrcUrl;
  Links links;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      StoriesResponse(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        dateGmt: DateTime.parse(json["date_gmt"]),
        guid: Guid.fromJson(json["guid"]),
        modified: DateTime.parse(json["modified"]),
        modifiedGmt: DateTime.parse(json["modified_gmt"]),
        slug: json["slug"],
        status: statusEnumValues.map[json["status"]],
        type: typeValues.map[json["type"]],
        link: json["link"],
        title: Guid.fromJson(json["title"]),
        content: Content.fromJson(json["content"]),
        excerpt: Content.fromJson(json["excerpt"]),
        author: json["author"],
        featuredMedia: json["featured_media"],
        commentStatus: statusValues.map[json["comment_status"]],
        pingStatus: statusValues.map[json["ping_status"]],
        sticky: json["sticky"],
        template: json["template"],
        format: formatValues.map[json["format"]],
        meta: Meta.fromJson(json["meta"]),
        categories: List<int>.from(json["categories"].map((x) => x)),
        tags: List<dynamic>.from(json["tags"].map((x) => x)),
        featuredMediaSrcUrl: json["featured_media_src_url"] == null
            ? null
            : json["featured_media_src_url"],
        links: Links.fromJson(json["_links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date.toIso8601String(),
        "date_gmt": dateGmt.toIso8601String(),
        "guid": guid.toJson(),
        "modified": modified.toIso8601String(),
        "modified_gmt": modifiedGmt.toIso8601String(),
        "slug": slug,
        "status": statusEnumValues.reverse[status],
        "type": typeValues.reverse[type],
        "link": link,
        "title": title.toJson(),
        "content": content.toJson(),
        "excerpt": excerpt.toJson(),
        "author": author,
        "featured_media": featuredMedia,
        "comment_status": statusValues.reverse[commentStatus],
        "ping_status": statusValues.reverse[pingStatus],
        "sticky": sticky,
        "template": template,
        "format": formatValues.reverse[format],
        "meta": meta.toJson(),
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "featured_media_src_url":
            featuredMediaSrcUrl == null ? null : featuredMediaSrcUrl,
        "_links": links.toJson(),
      };
}

enum Status { OPEN }

final statusValues = EnumValues({"open": Status.OPEN});

class Content {
  Content({
    this.rendered,
    this.protected,
  });

  String rendered;
  bool protected;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
        "protected": protected,
      };
}

enum Format { STANDARD }

final formatValues = EnumValues({"standard": Format.STANDARD});

class Guid {
  Guid({
    this.rendered,
  });

  String rendered;

  factory Guid.fromJson(Map<String, dynamic> json) => Guid(
        rendered: json["rendered"],
      );

  Map<String, dynamic> toJson() => {
        "rendered": rendered,
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
    this.predecessorVersion,
    this.wpFeaturedmedia,
    this.wpAttachment,
    this.wpTerm,
    this.curies,
  });

  List<About> self;
  List<About> collection;
  List<About> about;
  List<Reply> author;
  List<Reply> replies;
  List<VersionHistory> versionHistory;
  List<PredecessorVersion> predecessorVersion;
  List<Reply> wpFeaturedmedia;
  List<About> wpAttachment;
  List<WpTerm> wpTerm;
  List<Cury> curies;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: List<About>.from(json["self"].map((x) => About.fromJson(x))),
        collection:
            List<About>.from(json["collection"].map((x) => About.fromJson(x))),
        about: List<About>.from(json["about"].map((x) => About.fromJson(x))),
        author: json["author"] == null
            ? null
            : List<Reply>.from(json["author"].map((x) => Reply.fromJson(x))),
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
        versionHistory: List<VersionHistory>.from(
            json["version-history"].map((x) => VersionHistory.fromJson(x))),
        predecessorVersion: json["predecessor-version"] == null
            ? null
            : List<PredecessorVersion>.from(json["predecessor-version"]
                .map((x) => PredecessorVersion.fromJson(x))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null
            ? null
            : List<Reply>.from(
                json["wp:featuredmedia"].map((x) => Reply.fromJson(x))),
        wpAttachment: List<About>.from(
            json["wp:attachment"].map((x) => About.fromJson(x))),
        wpTerm:
            List<WpTerm>.from(json["wp:term"].map((x) => WpTerm.fromJson(x))),
        curies: List<Cury>.from(json["curies"].map((x) => Cury.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": List<dynamic>.from(self.map((x) => x.toJson())),
        "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
        "about": List<dynamic>.from(about.map((x) => x.toJson())),
        "author": author == null
            ? null
            : List<dynamic>.from(author.map((x) => x.toJson())),
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
        "version-history":
            List<dynamic>.from(versionHistory.map((x) => x.toJson())),
        "predecessor-version": predecessorVersion == null
            ? null
            : List<dynamic>.from(predecessorVersion.map((x) => x.toJson())),
        "wp:featuredmedia": wpFeaturedmedia == null
            ? null
            : List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
        "wp:attachment":
            List<dynamic>.from(wpAttachment.map((x) => x.toJson())),
        "wp:term": List<dynamic>.from(wpTerm.map((x) => x.toJson())),
        "curies": List<dynamic>.from(curies.map((x) => x.toJson())),
      };
}

class About {
  About({
    this.href,
  });

  String href;

  factory About.fromJson(Map<String, dynamic> json) => About(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class Reply {
  Reply({
    this.embeddable,
    this.href,
  });

  bool embeddable;
  String href;

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        embeddable: json["embeddable"],
        href: json["href"],
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

  Name name;
  Href href;
  bool templated;

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
        name: nameValues.map[json["name"]],
        href: hrefValues.map[json["href"]],
        templated: json["templated"],
      );

  Map<String, dynamic> toJson() => {
        "name": nameValues.reverse[name],
        "href": hrefValues.reverse[href],
        "templated": templated,
      };
}

enum Href { HTTPS_API_W_ORG_REL }

final hrefValues =
    EnumValues({"https://api.w.org/{rel}": Href.HTTPS_API_W_ORG_REL});

enum Name { WP }

final nameValues = EnumValues({"wp": Name.WP});

class PredecessorVersion {
  PredecessorVersion({
    this.id,
    this.href,
  });

  int id;
  String href;

  factory PredecessorVersion.fromJson(Map<String, dynamic> json) =>
      PredecessorVersion(
        id: json["id"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "href": href,
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
        count: json["count"],
        href: json["href"],
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

  Taxonomy taxonomy;
  bool embeddable;
  String href;

  factory WpTerm.fromJson(Map<String, dynamic> json) => WpTerm(
        taxonomy: taxonomyValues.map[json["taxonomy"]],
        embeddable: json["embeddable"],
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "taxonomy": taxonomyValues.reverse[taxonomy],
        "embeddable": embeddable,
        "href": href,
      };
}

enum Taxonomy { CATEGORY, POST_TAG }

final taxonomyValues =
    EnumValues({"category": Taxonomy.CATEGORY, "post_tag": Taxonomy.POST_TAG});

class Meta {
  Meta({
    this.pmproDefaultLevel,
  });

  int pmproDefaultLevel;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pmproDefaultLevel: json["pmpro_default_level"],
      );

  Map<String, dynamic> toJson() => {
        "pmpro_default_level": pmproDefaultLevel,
      };
}

enum StatusEnum { PUBLISH }

final statusEnumValues = EnumValues({"publish": StatusEnum.PUBLISH});

enum Type { POST }

final typeValues = EnumValues({"post": Type.POST});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}



// class LocalStoriesResponse {
//   LocalStoriesResponse(
//       {this.id,
//       this.date,
//       this.dateGmt,
//       this.guid,
//       this.modified,
//       this.modifiedGmt,
//       this.slug,
//       this.status,
//       this.type,
//       this.link,
//       this.title,
//       this.content,
//       this.excerpt,
//       this.author,
//       this.featuredMedia,
//       this.commentStatus,
//       this.pingStatus,
//       this.sticky,
//       this.template,
//       this.format,
//       this.meta,
//       this.categories,
//       this.tags,
//       this.featuredMediaSrcUrl,
//       this.links,
//       this.continueReading,
//       this.totalReading});

//   int id;
//   DateTime date;
//   DateTime dateGmt;
//   Guid guid;
//   DateTime modified;
//   DateTime modifiedGmt;
//   String slug;
//   StatusEnum status;
//   Type type;
//   String link;
//   Guid title;
//   Content content;
//   Content excerpt;
//   int author;
//   int featuredMedia;
//   Status commentStatus;
//   Status pingStatus;
//   bool sticky;
//   String template;
//   Format format;
//   Meta meta;
//   List<int> categories;
//   List<dynamic> tags;
//   String featuredMediaSrcUrl;
//   Links links;
//   double continueReading;
//   double totalReading;

//   factory LocalStoriesResponse.fromJson(Map<String, dynamic> json) =>
//       LocalStoriesResponse(
//         id: json["id"],
//         date: DateTime.parse(json["date"]),
//         dateGmt: DateTime.parse(json["date_gmt"]),
//         guid: Guid.fromJson(json["guid"]),
//         modified: DateTime.parse(json["modified"]),
//         modifiedGmt: DateTime.parse(json["modified_gmt"]),
//         slug: json["slug"],
//         status: statusEnumValues.map[json["status"]],
//         type: typeValues.map[json["type"]],
//         link: json["link"],
//         title: Guid.fromJson(json["title"]),
//         content: Content.fromJson(json["content"]),
//         excerpt: Content.fromJson(json["excerpt"]),
//         author: json["author"],
//         featuredMedia: json["featured_media"],
//         commentStatus: statusValues.map[json["comment_status"]],
//         pingStatus: statusValues.map[json["ping_status"]],
//         sticky: json["sticky"],
//         template: json["template"],
//         format: formatValues.map[json["format"]],
//         meta: Meta.fromJson(json["meta"]),
//         categories: List<int>.from(json["categories"].map((x) => x)),
//         tags: List<dynamic>.from(json["tags"].map((x) => x)),
//         featuredMediaSrcUrl: json["featured_media_src_url"] == null
//             ? null
//             : json["featured_media_src_url"],
//         links: Links.fromJson(json["_links"]),
//         continueReading: json["continueReading"],
//         totalReading: json["totalReading"],
//       );

//   static Map<String, dynamic> toJson(LocalStoriesResponse story) => {
//         "id": story.id,
//         "date": story.date.toIso8601String(),
//         "date_gmt": story.dateGmt.toIso8601String(),
//         "guid": story.guid.toJson(),
//         "modified": story.modified.toIso8601String(),
//         "modified_gmt": story.modifiedGmt.toIso8601String(),
//         "slug": story.slug,
//         "status": statusEnumValues.reverse[story.status],
//         "type": typeValues.reverse[story.type],
//         "link": story.link,
//         "title": story.title.toJson(),
//         "content": story.content.toJson(),
//         "excerpt": story.excerpt.toJson(),
//         "author": story.author,
//         "featured_media": story.featuredMedia,
//         "comment_status": statusValues.reverse[story.commentStatus],
//         "ping_status": statusValues.reverse[story.pingStatus],
//         "sticky": story.sticky,
//         "template": story.template,
//         "format": formatValues.reverse[story.format],
//         "meta": story.meta.toJson(),
//         "categories": List<dynamic>.from(story.categories.map((x) => x)),
//         "tags": List<dynamic>.from(story.tags.map((x) => x)),
//         "featured_media_src_url": story.featuredMediaSrcUrl == null
//             ? null
//             : story.featuredMediaSrcUrl,
//         "_links": story.links.toJson(),
//         "continueReading": story.continueReading,
//         "totalReading": story.totalReading,
//       };

//   static String encode(List<LocalStoriesResponse> stories) => json.encode(
//         stories
//             .map<Map<String, dynamic>>(
//                 (story) => LocalStoriesResponse.toJson(story))
//             .toList(),
//       );

//   static List<LocalStoriesResponse> decode(String musics) => (json
//           .decode(musics) as List<dynamic>)
//       .map<LocalStoriesResponse>((item) => LocalStoriesResponse.fromJson(item))
//       .toList();
// }

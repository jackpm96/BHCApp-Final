// To parse this JSON data, do
//
//     final PostCommentResponse = PostCommentResponseFromJson(jsonString);

import 'dart:convert';

PostCommentResponse PostCommentResponseFromJson(String str) => PostCommentResponse.fromJson(json.decode(str));

String PostCommentResponseToJson(PostCommentResponse data) => json.encode(data.toJson());

class PostCommentResponse {
  PostCommentResponse({
    this.id,
    this.post,
    this.parent,
    this.author,
    this.authorName,
    this.authorEmail,
    this.authorUrl,
    this.authorIp,
    this.authorUserAgent,
    this.date,
    this.dateGmt,
    this.content,
    this.link,
    this.status,
    this.type,
    this.authorAvatarUrls,
    this.meta,
    this.links,
  });

  int id;
  int post;
  int parent;
  int author;
  String authorName;
  String authorEmail;
  String authorUrl;
  String authorIp;
  String authorUserAgent;
  DateTime date;
  DateTime dateGmt;
  Content content;
  String link;
  String status;
  String type;
  Map<String, String> authorAvatarUrls;
  List<dynamic> meta;
  Links links;

  factory PostCommentResponse.fromJson(Map<String, dynamic> json) => PostCommentResponse(
    id: json["id"],
    post: json["post"],
    parent: json["parent"],
    author: json["author"],
    authorName: json["author_name"],
    authorEmail: json["author_email"],
    authorUrl: json["author_url"],
    authorIp: json["author_ip"],
    authorUserAgent: json["author_user_agent"],
    date: DateTime.parse(json["date"]),
    dateGmt: DateTime.parse(json["date_gmt"]),
    content: Content.fromJson(json["content"]),
    link: json["link"],
    status: json["status"],
    type: json["type"],
    authorAvatarUrls: Map.from(json["author_avatar_urls"]).map((k, v) => MapEntry<String, String>(k, v)),
    meta: List<dynamic>.from(json["meta"].map((x) => x)),
    links: Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post": post,
    "parent": parent,
    "author": author,
    "author_name": authorName,
    "author_email": authorEmail,
    "author_url": authorUrl,
    "author_ip": authorIp,
    "author_user_agent": authorUserAgent,
    "date": date.toIso8601String(),
    "date_gmt": dateGmt.toIso8601String(),
    "content": content.toJson(),
    "link": link,
    "status": status,
    "type": type,
    "author_avatar_urls": Map.from(authorAvatarUrls).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "meta": List<dynamic>.from(meta.map((x) => x)),
    "_links": links.toJson(),
  };
}

class Content {
  Content({
    this.rendered,
    this.raw,
  });

  String rendered;
  String raw;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    rendered: json["rendered"],
    raw: json["raw"],
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
    this.author,
    this.up,
  });

  List<Collection> self;
  List<Collection> collection;
  List<Author> author;
  List<Up> up;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    collection: List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
    author: List<Author>.from(json["author"].map((x) => Author.fromJson(x))),
    up: List<Up>.from(json["up"].map((x) => Up.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": List<dynamic>.from(collection.map((x) => x.toJson())),
    "author": List<dynamic>.from(author.map((x) => x.toJson())),
    "up": List<dynamic>.from(up.map((x) => x.toJson())),
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
    embeddable: json["embeddable"],
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "embeddable": embeddable,
    "href": href,
  };
}

class Collection {
  Collection({
    this.href,
  });

  String href;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

class Up {
  Up({
    this.embeddable,
    this.postType,
    this.href,
  });

  bool embeddable;
  String postType;
  String href;

  factory Up.fromJson(Map<String, dynamic> json) => Up(
    embeddable: json["embeddable"],
    postType: json["post_type"],
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "embeddable": embeddable,
    "post_type": postType,
    "href": href,
  };
}

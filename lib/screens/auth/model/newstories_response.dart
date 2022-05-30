// To parse this JSON data, do
//
//     final topLevel = topLevelFromJson(jsonString);

import 'dart:convert';

TopLevel topLevelFromJson(String str) => TopLevel.fromJson(json.decode(str));

String topLevelToJson(TopLevel data) => json.encode(data.toJson());

class TopLevel {
  TopLevel({
    this.status,
    this.response,
    this.code,
    this.data,
  });

  String status;
  String response;
  int code;
  List<StoryData> data;

  factory TopLevel.fromJson(Map<String, dynamic> json) => TopLevel(
        status: json["status"],
        response: json["response"],
        code: json["code"],
        data: List<StoryData>.from(
            json["data"].map((x) => StoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response,
        "code": code,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class StoryData {
  StoryData({
    this.id,
    this.postAuthor,
    this.postTitle,
    this.postExcerpt,
    this.postContent,
    this.postDate,
    this.postStatus,
    this.commentCount,
    this.mediaId,
    this.featuredMediaSrcUrl,
    this.likes,
    this.isFavourite,
    this.shareUrl,
  });

  String id;
  String postAuthor;
  String postTitle;
  PostExcerpt postExcerpt;
  String postContent;
  DateTime postDate;
  PostStatus postStatus;
  String commentCount;
  String mediaId;
  String featuredMediaSrcUrl;
  String likes;
  String isFavourite;
  String shareUrl;

  factory StoryData.fromJson(Map<String, dynamic> json) => StoryData(
        id: json["ID"],
        postAuthor: json["post_author"],
        postTitle: json["post_title"],
        postExcerpt: postExcerptValues.map[json["post_excerpt"]],
        postContent: json["post_content"],
        postDate: DateTime.parse(json["post_date"]),
        postStatus: postStatusValues.map[json["post_status"]],
        commentCount: json["comment_count"],
        mediaId: json["media_id"],
        featuredMediaSrcUrl: json["featured_media_src_url"],
        likes: json["likes"],
        isFavourite: json["is_favourite"],
        shareUrl: json["share_url"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "post_author": postAuthor,
        "post_title": postTitle,
        "post_excerpt": postExcerptValues.reverse[postExcerpt],
        "post_content": postContent,
        "post_date": postDate.toIso8601String(),
        "post_status": postStatusValues.reverse[postStatus],
        "comment_count": commentCount,
        "media_id": mediaId,
        "featured_media_src_url": featuredMediaSrcUrl,
        "likes": likes,
        "is_favourite": isFavourite,
        "share_url": shareUrl,
      };
}

enum PostExcerpt { EMPTY, DUMMY_IMAGE_POST }

final postExcerptValues = EnumValues(
    {"dummyImage post ": PostExcerpt.DUMMY_IMAGE_POST, "": PostExcerpt.EMPTY});

enum PostStatus { PUBLISH }

final postStatusValues = EnumValues({"publish": PostStatus.PUBLISH});

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

class LocalStoriesResponse {
  LocalStoriesResponse(
      {this.id,
      this.postAuthor,
      this.postTitle,
      this.postExcerpt,
      this.postContent,
      this.postDate,
      this.postStatus,
      this.commentCount,
      this.mediaId,
      this.featuredMediaSrcUrl,
      this.likes,
      this.isFavourite,
      this.shareUrl,
      this.continueReading,
      this.totalReading,
      this.audio});

  String id;
  String postAuthor;
  String postTitle;
  PostExcerpt postExcerpt;
  String postContent;
  DateTime postDate;
  PostStatus postStatus;
  String commentCount;
  String mediaId;
  String featuredMediaSrcUrl;
  String likes;
  String isFavourite;
  String shareUrl;
  double continueReading;
  double totalReading;
  String audio;

  factory LocalStoriesResponse.fromJson(Map<String, dynamic> json) =>
      LocalStoriesResponse(
        id: json["ID"],
        postAuthor: json["post_author"],
        postTitle: json["post_title"],
        postExcerpt: postExcerptValues.map[json["post_excerpt"]],
        postContent: json["post_content"],
        postDate: DateTime.parse(json["post_date"]),
        postStatus: postStatusValues.map[json["post_status"]],
        commentCount: json["comment_count"],
        mediaId: json["media_id"],
        featuredMediaSrcUrl: json["featured_media_src_url"],
        likes: json["likes"],
        isFavourite: json["is_favourite"],
        continueReading: json["continueReading"],
        totalReading: json["totalReading"],
        shareUrl: json["share_url"],
        audio: json["audio"],
      );

  static Map<String, dynamic> toJson(LocalStoriesResponse story) => {
        "ID": story.id,
        "post_author": story.postAuthor,
        "post_title": story.postTitle,
        "post_excerpt": postExcerptValues.reverse[story.postExcerpt],
        "post_content": story.postContent,
        "post_date": story.postDate.toIso8601String(),
        "post_status": postStatusValues.reverse[story.postStatus],
        "comment_count": story.commentCount,
        "media_id": story.mediaId,
        "featured_media_src_url": story.featuredMediaSrcUrl,
        "likes": story.likes,
        "is_favourite": story.isFavourite,
        "continueReading": story.continueReading,
        "totalReading": story.totalReading,
        "share_url": story.shareUrl,
        "audio": story.audio,
      };

  static String encode(List<LocalStoriesResponse> stories) => json.encode(
        stories
            .map<Map<String, dynamic>>(
                (story) => LocalStoriesResponse.toJson(story))
            .toList(),
      );

  static List<LocalStoriesResponse> decode(String musics) => (json
          .decode(musics) as List<dynamic>)
      .map<LocalStoriesResponse>((item) => LocalStoriesResponse.fromJson(item))
      .toList();
}

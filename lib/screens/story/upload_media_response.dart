class UploadMediaResponse {
  int id;
  String date;
  String guid;

  UploadMediaResponse({
    this.id,
    this.date,
    this.guid,
  });

  UploadMediaResponse.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    date = json['date'].toString();
    guid = json['guid']['rendered'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['guid'] = this.guid;
    return data;
  }
}

class Guid {
  String rendered;
  String raw;

  Guid({this.rendered, this.raw});

  Guid.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'].toString();
    raw = json['raw'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    data['raw'] = this.raw;
    return data;
  }
}

class Meta {
  int pmproDefaultLevel;

  Meta({this.pmproDefaultLevel});

  Meta.fromJson(Map<String, dynamic> json) {
    pmproDefaultLevel =int.parse(json['pmpro_default_level'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pmpro_default_level'] = this.pmproDefaultLevel;
    return data;
  }
}

class MediaDetails {
  int width;
  int height;
  String file;
  Sizes sizes;
  ImageMeta imageMeta;
  String originalImage;

  MediaDetails(
      {this.width,
      this.height,
      this.file,
      this.sizes,
      this.imageMeta,
      this.originalImage});

  MediaDetails.fromJson(Map<String, dynamic> json) {
    width = int.parse(json['width'].toString());
    height = int.parse(json['height'].toString());
    file = json['file'].toString();
    sizes = json['sizes'] != null ? Sizes.fromJson(json['sizes'] as Map<String, dynamic>) : null;
    imageMeta = json['image_meta'] != null
        ? ImageMeta.fromJson(json['image_meta'] as Map<String, dynamic>)
        : null;
    originalImage = json['original_image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['width'] = this.width;
    data['height'] = this.height;
    data['file'] = this.file;
    if (this.sizes != null) {
      data['sizes'] = this.sizes.toJson();
    }
    if (this.imageMeta != null) {
      data['image_meta'] = this.imageMeta.toJson();
    }
    data['original_image'] = this.originalImage;
    return data;
  }
}

class Sizes {
  Medium medium;
  Medium large;
  Medium thumbnail;
  Medium mediumLarge;
  Medium m1536x1536;
  Medium m2048x2048;
  Medium postThumbnail;
  Medium kavaThumbS;
  Medium kavaThumbS2;
  Medium kavaThumbM;
  Medium kavaThumbMVertical;
  Medium kavaThumbM2;
  Medium kavaThumbL;
  Medium kavaThumbXl;
  Medium kavaThumbMasonry;
  Medium kavaThumbJustify;
  Medium kavaThumbJustify2;
  Medium full;

  Sizes(
      {this.medium,
      this.large,
      this.thumbnail,
      this.mediumLarge,
      this.m1536x1536,
      this.m2048x2048,
      this.postThumbnail,
      this.kavaThumbS,
      this.kavaThumbS2,
      this.kavaThumbM,
      this.kavaThumbMVertical,
      this.kavaThumbM2,
      this.kavaThumbL,
      this.kavaThumbXl,
      this.kavaThumbMasonry,
      this.kavaThumbJustify,
      this.kavaThumbJustify2,
      this.full});

  Sizes.fromJson(Map<String, dynamic> json) {
    medium =
        json['medium'] != null ? Medium.fromJson(json['medium'] as Map<String, dynamic>) : null;
    large = json['large'] != null ? Medium.fromJson(json['large'] as Map<String, dynamic>) : null;
    thumbnail = json['thumbnail'] != null
        ? Medium.fromJson(json['thumbnail'] as Map<String, dynamic>)
        : null;
    mediumLarge = json['medium_large'] != null
        ? Medium.fromJson(json['medium_large'] as Map<String, dynamic>)
        : null;
    m1536x1536 = json['1536x1536'] != null
        ? Medium.fromJson(json['1536x1536'] as Map<String, dynamic>)
        : null;
    m2048x2048 = json['2048x2048'] != null
        ? Medium.fromJson(json['2048x2048'] as Map<String, dynamic>)
        : null;
    postThumbnail = json['post-thumbnail'] != null
        ? Medium.fromJson(json['post-thumbnail'] as Map<String, dynamic>)
        : null;
    kavaThumbS = json['kava-thumb-s'] != null
        ? Medium.fromJson(json['kava-thumb-s'] as Map<String, dynamic>)
        : null;
    kavaThumbS2 = json['kava-thumb-s-2'] != null
        ? Medium.fromJson(json['kava-thumb-s-2'] as Map<String, dynamic>)
        : null;
    kavaThumbM = json['kava-thumb-m'] != null
        ? Medium.fromJson(json['kava-thumb-m'] as Map<String, dynamic>)
        : null;
    kavaThumbMVertical = json['kava-thumb-m-vertical'] != null
        ? Medium.fromJson(json['kava-thumb-m-vertical'] as Map<String, dynamic>)
        : null;
    kavaThumbM2 = json['kava-thumb-m-2'] != null
        ? Medium.fromJson(json['kava-thumb-m-2'] as Map<String, dynamic>)
        : null;
    kavaThumbL = json['kava-thumb-l'] != null
        ? Medium.fromJson(json['kava-thumb-l'] as Map<String, dynamic>)
        : null;
    kavaThumbXl = json['kava-thumb-xl'] != null
        ? Medium.fromJson(json['kava-thumb-xl'] as Map<String, dynamic>)
        : null;
    kavaThumbMasonry = json['kava-thumb-masonry'] != null
        ? Medium.fromJson(json['kava-thumb-masonry'] as Map<String, dynamic>)
        : null;
    kavaThumbJustify = json['kava-thumb-justify'] != null
        ? Medium.fromJson(json['kava-thumb-justify'] as Map<String, dynamic>)
        : null;
    kavaThumbJustify2 = json['kava-thumb-justify-2'] != null
        ? Medium.fromJson(json['kava-thumb-justify-2'] as Map<String, dynamic>)
        : null;
    full = json['full'] != null ? Medium.fromJson(json['full'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.medium != null) {
      data['medium'] = medium.toJson();
    }
    if (this.large != null) {
      data['large'] = large.toJson();
    }
    if (this.thumbnail != null) {
      data['thumbnail'] = thumbnail.toJson();
    }
    if (this.mediumLarge != null) {
      data['medium_large'] = mediumLarge.toJson();
    }
    if (this.m1536x1536 != null) {
      data['1536x1536'] = m1536x1536.toJson();
    }
    if (this.m2048x2048 != null) {
      data['2048x2048'] = m2048x2048.toJson();
    }
    if (this.postThumbnail != null) {
      data['post-thumbnail'] = postThumbnail.toJson();
    }
    if (this.kavaThumbS != null) {
      data['kava-thumb-s'] = kavaThumbS.toJson();
    }
    if (this.kavaThumbS2 != null) {
      data['kava-thumb-s-2'] = kavaThumbS2.toJson();
    }
    if (this.kavaThumbM != null) {
      data['kava-thumb-m'] = kavaThumbM.toJson();
    }
    if (this.kavaThumbMVertical != null) {
      data['kava-thumb-m-vertical'] = kavaThumbMVertical.toJson();
    }
    if (this.kavaThumbM2 != null) {
      data['kava-thumb-m-2'] = kavaThumbM2.toJson();
    }
    if (this.kavaThumbL != null) {
      data['kava-thumb-l'] = this.kavaThumbL.toJson();
    }
    if (this.kavaThumbXl != null) {
      data['kava-thumb-xl'] = this.kavaThumbXl.toJson();
    }
    if (this.kavaThumbMasonry != null) {
      data['kava-thumb-masonry'] = this.kavaThumbMasonry.toJson();
    }
    if (this.kavaThumbJustify != null) {
      data['kava-thumb-justify'] = this.kavaThumbJustify.toJson();
    }
    if (this.kavaThumbJustify2 != null) {
      data['kava-thumb-justify-2'] = this.kavaThumbJustify2.toJson();
    }
    if (this.full != null) {
      data['full'] = this.full.toJson();
    }
    return data;
  }
}

class Medium {
  String file;
  int width;
  int height;
  String mimeType;
  String sourceUrl;

  Medium({this.file, this.width, this.height, this.mimeType, this.sourceUrl});

  Medium.fromJson(Map<String, dynamic> json) {
    file = json['file'].toString();
    width = int.parse(json['width'].toString());
    height =int.parse(json['height'].toString());
    mimeType = json['mime_type'].toString();
    sourceUrl = json['source_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['width'] = this.width;
    data['height'] = this.height;
    data['mime_type'] = this.mimeType;
    data['source_url'] = this.sourceUrl;
    return data;
  }
}

class ImageMeta {
  String aperture;
  String credit;
  String camera;
  String caption;
  String createdTimestamp;
  String copyright;
  String focalLength;
  String iso;
  String shutterSpeed;
  String title;
  String orientation;
  List<Null> keywords;

  ImageMeta(
      {this.aperture,
      this.credit,
      this.camera,
      this.caption,
      this.createdTimestamp,
      this.copyright,
      this.focalLength,
      this.iso,
      this.shutterSpeed,
      this.title,
      this.orientation,
      this.keywords});

  ImageMeta.fromJson(Map<String, dynamic> json) {
    aperture = json['aperture'].toString();
    credit = json['credit'].toString();
    camera = json['camera'].toString();
    caption = json['caption'].toString();
    createdTimestamp = json['created_timestamp'].toString();
    copyright = json['copyright'].toString();
    focalLength = json['focal_length'].toString();
    iso = json['iso'].toString();
    shutterSpeed = json['shutter_speed'].toString();
    title = json['title'].toString();
    orientation = json['orientation'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aperture'] = this.aperture;
    data['credit'] = this.credit;
    data['camera'] = this.camera;
    data['caption'] = this.caption;
    data['created_timestamp'] = this.createdTimestamp;
    data['copyright'] = this.copyright;
    data['focal_length'] = this.focalLength;
    data['iso'] = this.iso;
    data['shutter_speed'] = this.shutterSpeed;
    data['title'] = this.title;
    data['orientation'] = this.orientation;
    return data;
  }
}

class Links {
  List<Self> self;
  List<Author> author;
  List<Curies> curies;

  Links({this.self, this.author, this.curies});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = new List<Self>();
      json['self'].forEach((v) {
        self.add( Self.fromJson(v as Map<String, dynamic>));
      });
    }

    if (json['author'] != null) {
      // ignore: deprecated_member_use
      author =  List<Author>();
      json['author'].forEach((v) {
        author.add( Author.fromJson(v as Map<String, dynamic>));
      });
    }

    if (json['curies'] != null) {
      curies = new List<Curies>();
      json['curies'].forEach((v) {
        curies.add( Curies.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.self != null) {
      data['self'] = this.self.map((v) => v.toJson()).toList();
    }
    if (this.author != null) {
      data['author'] = this.author.map((v) => v.toJson()).toList();
    }
    if (this.curies != null) {
      data['curies'] = this.curies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Self {
  String href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = href;
    return data;
  }
}

class Author {
  bool embeddable;
  String href;

  Author({this.embeddable, this.href});

  Author.fromJson(Map<String, dynamic> json) {
    embeddable = json['embeddable'] as bool;
    href = json['href'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embeddable'] = this.embeddable;
    data['href'] = this.href;
    return data;
  }
}

class Curies {
  String name;
  String href;
  bool templated;

  Curies({this.name, this.href, this.templated});

  Curies.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    href = json['href'].toString();
    templated = json['templated'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['href'] = this.href;
    data['templated'] = this.templated;
    return data;
  }
}

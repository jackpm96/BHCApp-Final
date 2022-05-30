import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/pages/comments_page.dart';
import 'package:black_history_calender/screens/auth/model/getlike_response.dart';
//import 'package:black_history_calender/screens/auth/model/stories_response.dart';
import 'package:black_history_calender/screens/auth/model/newstories_response.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/services/page_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

AudioPlayer _audioPlayer;

class DetailScreen extends StatefulWidget {
  final dynamic user;
  final bool fromSearch;
  final expand;
  final String audio;
  DetailScreen(this.user, this.expand, this.audio,this.fromSearch);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<LocalStoriesResponse> locallySavedStories;
  ScrollController _controller = ScrollController();

  LocalStoriesResponse _localStoriesResponse;
  PageManager _pageManager;

  @override
  void initState() {
    initData();
    super.initState();

    _pageManager = PageManager(widget.audio);
  }

  @override
  void dispose() {
    _pageManager.pause();
    _pageManager.dispose();
    super.dispose();
  }

  initData() async {
    // _audioPlayer = AudioPlayer();
    // // Set a sequence of audio sources that will be played by the audio player.
    // await _audioPlayer.setUrl(widget.audio);

    await Prefs.readingStories.then((value) {
      if (value != null && value.isNotEmpty) {
        setState(() {
          //print("hello");
          //print(value);
          List<LocalStoriesResponse> res = LocalStoriesResponse.decode(value);
          locallySavedStories = res;
        });
      } else {
        locallySavedStories = [];
      }
    });

    if (locallySavedStories.length > 0) {
      _localStoriesResponse = locallySavedStories
          .firstWhere((element) => element.id == widget.user.id);
      _controller.animateTo(_localStoriesResponse.continueReading,
          duration: Duration(microseconds: 100), curve: Curves.easeOut);
      //  = ScrollController(
      //     initialScrollOffset: _localStoriesResponse.continueReading);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Provider.of<AuthProvider>(context, listen: false)
          .getLikes(widget.user.id),
    );
    return WillPopScope(
      onWillPop: () async {
        // Do something here
        if (widget.fromSearch==false) {
          _localStoriesResponse = LocalStoriesResponse(
            id: widget.user.id.toString(),
            postAuthor: widget.user.postAuthor.toString(),
            postTitle: widget.user.postTitle.toString(),
            postExcerpt: widget.user.postExcerpt as PostExcerpt,
            postContent: widget.user.postContent.toString(),
            postDate: widget.user.postDate as DateTime,
            postStatus: widget.user.postStatus as PostStatus,
            commentCount: widget.user.commentCount.toString(),
            mediaId: widget.user.mediaId.toString(),
            featuredMediaSrcUrl: widget.user.featuredMediaSrcUrl.toString(),
            likes: widget.user.likes.toString(),
            isFavourite: widget.user.isFavourite.toString(),
            continueReading: _controller.offset,
            totalReading: _controller.position.maxScrollExtent,
            audio: widget.audio,
          );

          if (locallySavedStories
              .where((element) => element.id == _localStoriesResponse.id)
              .isEmpty) {
            locallySavedStories.add(_localStoriesResponse);
          } else {
            var index = locallySavedStories.indexWhere(
                    (element) => element.id == _localStoriesResponse.id);

            locallySavedStories[index] = _localStoriesResponse;
          }
          if (_controller.offset == _controller.position.maxScrollExtent) {
            if (locallySavedStories.isNotEmpty) {
              locallySavedStories.removeWhere(
                      (element) => element.id == _localStoriesResponse.id);
            }
          }
          await Prefs.setReadingStories(
              LocalStoriesResponse.encode([...locallySavedStories]));
          print("After clicking the Android Back Button");
          Navigator.of(context).pop();
          return false;
        }
        else
        print("After clicking the Android Back Button");
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: GestureDetector(
              onTap: ()
              async
              {
                if (widget.fromSearch==false) {
                  _localStoriesResponse = LocalStoriesResponse(
                      id: widget.user.id.toString(),
                      postAuthor: widget.user.postAuthor.toString(),
                      postTitle: widget.user.postTitle.toString(),
                      postExcerpt: widget.user.postExcerpt as PostExcerpt,
                      postContent: widget.user.postContent.toString(),
                      postDate: widget.user.postDate as DateTime,
                      postStatus: widget.user.postStatus as PostStatus,
                      commentCount: widget.user.commentCount.toString(),
                      mediaId: widget.user.mediaId.toString(),
                  featuredMediaSrcUrl: widget.user.featuredMediaSrcUrl.toString(),
                  likes: widget.user.likes.toString(),
                  isFavourite: widget.user.isFavourite.toString(),
                  continueReading: _controller.offset,
                  totalReading: _controller.position.maxScrollExtent,
                  audio: widget.audio,
                  );

                  if (locallySavedStories
                      .where((element) => element.id == _localStoriesResponse.id)
                      .isEmpty) {
                    locallySavedStories.add(_localStoriesResponse);
                  } else {
                    var index = locallySavedStories.indexWhere(
                            (element) => element.id == _localStoriesResponse.id);

                    locallySavedStories[index] = _localStoriesResponse;
                  }
                  if (_controller.offset == _controller.position.maxScrollExtent) {
                    if (locallySavedStories.isNotEmpty) {
                      locallySavedStories.removeWhere(
                              (element) => element.id == _localStoriesResponse.id);
                    }
                  }
                  await Prefs.setReadingStories(
                      LocalStoriesResponse.encode([...locallySavedStories]));
                  Navigator.of(context).pop();
                }
                else
                  Navigator.of(context).pop();
              },
              child: Image.asset(
                "assets/images/back.png",
                height: 25,
                width: 25,
              )
            // Icon(
            //   Icons.arrow_back_ios,
            //   size: 25,
            // ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Share.share('check out this article ${widget.user.shareUrl}');
              },
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    "assets/images/share.png",
                    height: 25,
                    width: 25,
                  )

                // Icon(
                //   Icons.share,
                //   size: 25,
                // ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height*1.3,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.height,
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //       fit: BoxFit.cover,
                      //       image: widget.user.featuredMediaSrcUrl != null
                      //           ? NetworkImage(widget.user.featuredMediaSrcUrl)
                      //           : AssetImage("assets/images/null.jpg")),
                      // ),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.user.featuredMediaSrcUrl.toString(),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Container(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Expanded(child: Container())
                  ],
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: 290,
                    child: Container(
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Padding(
                        padding:
                         EdgeInsets.only(top: 22.0, left: 18, right: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        widget.user.postTitle.toString(),
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25),
                                      ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     RatingBar.builder(
                                      //       initialRating: 3,
                                      //       itemSize: 20,
                                      //       minRating: 1,
                                      //       direction: Axis.horizontal,
                                      //       allowHalfRating: true,
                                      //       itemCount: 5,
                                      //       itemPadding: EdgeInsets.symmetric(
                                      //           horizontal: 1.0),
                                      //       itemBuilder: (context, _) => Icon(
                                      //         Icons.star,
                                      //         color: Colors.amber,
                                      //       ),
                                      //       onRatingUpdate: (rating) {
                                      //         print(rating);
                                      //       },
                                      //     ),
                                      //   ],
                                      // ),

                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  color: Color(0xff999999),
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                 widget.user.postDate.toString(),
                                                  style: GoogleFonts.montserrat(
                                                      color: Color(0xff999999),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Consumer<AuthProvider>(builder:
                                              (BuildContext context,
                                              AuthProvider provider,
                                              Widget child) {
                                            if (provider.likesdata == null) {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                    strokeWidth: 0.5),
                                              );
                                            }

                                            return Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  provider.likesdata.data,
                                                  style: GoogleFonts.montserrat(
                                                      color: Color(0xff999999),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // AuthProvider()
                                                    //     .postlike(
                                                    //         widget.user.id,
                                                    //         int.parse(provider
                                                    //                 .likesdata
                                                    //                 .data) +
                                                    //             1)
                                                    //     .then((value) =>
                                                    //         setState(() {}));
                                                    provider.postlike(
                                                        widget.user.id,
                                                        int.parse(provider
                                                            .likesdata.data) +
                                                            1);
                                                  },
                                                  child: Image.asset(
                                                    "assets/images/like_thumb.png",
                                                    height: 25,
                                                    width: 25,
                                                    color: Color(0xff999999),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                          // FutureBuilder<LikesData>(
                                          //     future: AuthProvider()
                                          //         .getLikes(widget.user.id),
                                          //     builder: (context, snapshot) {
                                          //       if (!snapshot.hasData) {
                                          //         return Center(
                                          //           child:
                                          //               CircularProgressIndicator(
                                          //                   strokeWidth: 0.5),
                                          //         );
                                          //       }
                                          //       final response = snapshot.data;
                                          //       return Row(
                                          //         crossAxisAlignment:
                                          //             CrossAxisAlignment.center,
                                          //         children: [
                                          //           Text(
                                          //             response.data,
                                          //             style: GoogleFonts
                                          //                 .montserrat(
                                          //                     color: Color(
                                          //                         0xff999999),
                                          //                     fontWeight:
                                          //                         FontWeight
                                          //                             .w600,
                                          //                     fontSize: 13),
                                          //           ),
                                          //           SizedBox(
                                          //             width: 5,
                                          //           ),
                                          //           GestureDetector(
                                          //             onTap: () {
                                          //               AuthProvider()
                                          //                   .postlike(
                                          //                       widget.user.id,
                                          //                       int.parse(response
                                          //                               .data) +
                                          //                           1)
                                          //                   .then((value) =>
                                          //                       setState(
                                          //                           () {}));
                                          //             },
                                          //             child: Image.asset(
                                          //               "assets/images/like_thumb.png",
                                          //               height: 25,
                                          //               width: 25,
                                          //               color:
                                          //                   Color(0xff999999),
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       );
                                          //     }),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // _audioPlayer.pause();
                                              _pageManager.pause();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentScreen(
                                                              widget.user.id)));
                                            },
                                            child: Image.asset(
                                              "assets/images/comment.png",
                                              height: 25,
                                              width: 25,
                                              color: Color(0xff999999),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      padding:
                                       EdgeInsets.symmetric(vertical: 3.0),
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 10,
                                              offset: Offset(0, 0), // Shadow position
                                            ),
                                          ]),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              // onTap: () {
                                              //   // _audioPlayer.playing
                                              //   //     ? _audioPlayer.pause()
                                              //   //     : _audioPlayer.play();

                                              //   // setState(() {});
                                              //   _pageManager.play
                                              // },
                                              onTap: _pageManager.play,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: lightBlue),
                                                child:
                                                ValueListenableBuilder<ButtonState>(
                                                  valueListenable:
                                                  _pageManager.buttonNotifier,
                                                  builder: (_, value, __) {
                                                    switch (value) {
                                                      case ButtonState.loading:
                                                        return Container(
                                                          margin:
                                                           EdgeInsets.all(8.0),
                                                          width: 32.0,
                                                          height: 32.0,
                                                          child:
                                                           CircularProgressIndicator(),
                                                        );
                                                      case ButtonState.paused:
                                                        return IconButton(
                                                          icon:  Icon(
                                                            Icons.play_arrow,
                                                            color: white,
                                                          ),
                                                          iconSize: 32.0,
                                                          onPressed: _pageManager.play,
                                                        );
                                                      case ButtonState.playing:
                                                        return IconButton(
                                                          icon:  Icon(
                                                            Icons.pause,
                                                            color: white,
                                                          ),
                                                          iconSize: 32.0,
                                                          onPressed: _pageManager.pause,
                                                        );
                                                      default:
                                                        return Container(
                                                          margin:
                                                           EdgeInsets.all(8.0),
                                                          width: 32.0,
                                                          height: 32.0,
                                                          child:
                                                           CircularProgressIndicator(),
                                                        );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: ValueListenableBuilder<
                                                  ProgressBarState>(
                                                valueListenable:
                                                _pageManager.progressNotifier,
                                                builder: (_, value, __) {
                                                  return ProgressBar(
                                                    progress: value.current,
                                                    buffered: value.buffered,
                                                    total: value.total,
                                                    onSeek: _pageManager.seek,
                                                    barHeight: 8,
                                                  );
                                                },
                                              ),

                                              //     LinearProgressIndicator(
                                              //   value: 0.7,
                                              //   valueColor: AlwaysStoppedAnimation<Color>(
                                              //     lightBlue,
                                              //   ),
                                              //   backgroundColor: lightBlue.shade50,
                                              // )
                                              // Slider.adaptive(
                                              //
                                              //   value: 0.5,
                                              //   onChanged: (value) {},
                                              // ),
                                            ),
                                            // SizedBox(
                                            //   width: 15,
                                            // ),
                                            // Icon(
                                            //   Icons.volume_up,
                                            //   size: 18,
                                            //   color: lightBlue,
                                            // ),
                                            // Icon(
                                            //   Icons.more_vert,
                                            //   size: 18,
                                            //   color: lightBlue,
                                            // )
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: ClampingScrollPhysics(),
                                controller: _controller,
                                child: Padding(
                                  padding:  EdgeInsets.only(bottom: 30),
                                  child: ExpandableText(
                                    widget.user.postContent.toString(),
                                    trimLines: 10,
                                    expand: widget.expand as bool,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      )
    );
  }
}

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    this.trimLines = 2,
    this.expand,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;
  final bool expand;

  @override
  ExpandableTextState createState() => ExpandableTextState(this.expand);
}

class ExpandableTextState extends State<ExpandableText> {
  ExpandableTextState(this.expand);
  bool expand;
  // bool _readMore = false;

  void _onTapLink() {
    setState(() => expand = !expand);
  }

  @override
  Widget build(BuildContext context) {
    final colorClickableText = Colors.blue;
    final widgetColor = Color(0xff2D2D2D);
    TextSpan link = TextSpan(
        text: expand ? "... READ MORE" : "READ LESS",
        style: GoogleFonts.montserrat(
          color: colorClickableText,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,
          //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        return Html(
          data: widget.text,
          customRender: {
            "audio": (RenderContext context, Widget child) {
              print("${context.tree.element.attributes['src']}");

              // print('Audio URL => ${context.tree.element.attributes['src']}');
              return TextSpan(
                text: '',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              );
            }
          },
          onLinkTap: (url, _, __, ___) {
            launch(url);
          },
          onImageTap: (src, _, __, ___) {
            launch(src);
          },
        );
      },
    );
    return result;
  }
}

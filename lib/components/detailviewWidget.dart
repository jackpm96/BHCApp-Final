import 'package:black_history_calender/components/mydialog.dart';
import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/pages/detail_screen.dart';
import 'package:black_history_calender/screens/auth/model/search_response.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailWidget extends StatelessWidget {
  final SearchResponse list;

  const DetailWidget({
    Key key,
    @required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.data.length,
          itemBuilder: (context, index) {
            final user = list.data;
            print("list.data.length ${list.data.length}");
            // provider.favStories
            //     .data.data.data[index];

            final htmldata = parse(user[index].postContent);
            final myList = htmldata.getElementsByTagName('p');
            String parsedData;
            if (myList.isNotEmpty) {
              parsedData = myList[2].innerHtml;
            } else {
              parsedData = user[index].postContent;
            }
            final audioHtml = htmldata.getElementsByTagName('audio');

            final audio = audioHtml.isNotEmpty ? audioHtml[0].attributes['src'] : '';

            print("Hamza test");
            return ListContent(user: user[index], audio: audio, parsedData: parsedData);
          },
        ),
      ],
    );
  }
}

class ListContent extends StatelessWidget {
  const ListContent({
    Key key,
    @required this.user,
    @required this.audio,
    @required this.parsedData,
  }) : super(key: key);

  final Data user;
  final String audio;
  final String parsedData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 4,
      ),
      child: GestureDetector(
        onTap: () async {
          var mem = await Prefs.membership;
          if (mem == '1' || mem == '2' || mem == '3' || mem == '4') {
            CommonWidgets.buildSnackbar(context, "subscribed");
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(user, false, audio, true)));
          } else {
            print("unsubscribed");
            showAlert(context);
          }
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: CachedNetworkImage(
                    color: Colors.black45,
                    fit: BoxFit.cover,
                    imageUrl: user.featuredMediaSrcUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.photo_library,
                      size: 50,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.postTitle,
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                EasyLoading.show();
                              },
                              child: Icon(
                                user.isFavourite == "1" ? Icons.favorite : Icons.favorite_border_outlined,
                                color: user.isFavourite == "1" ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Expanded(
                          child: Html(
                            data: parsedData,
                            onLinkTap: (url, _, __, ___) {
                              launch(url);
                            },
                            onImageTap: (src, _, __, ___) {
                              launch(src);
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: lightBlue,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    DateFormat.yMMMd().format(DateTime.parse(user.postDate)),
                                    style: GoogleFonts.montserrat(color: lightBlue, fontWeight: FontWeight.w300, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4.0,
                                  ),
                                  child: Text(
                                    user.likes,
                                    style: GoogleFonts.montserrat(
                                      color: const Color(0xff999999),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  "assets/images/like_thumb.png",
                                  height: 15,
                                  width: 15,
                                  // fit: BoxFit.contain,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4.0,
                                  ),
                                  child: Text(
                                    user.commentCount,
                                    style: GoogleFonts.montserrat(
                                      color: const Color(0xff999999),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Image.asset(
                                    "assets/images/comment.png",
                                    height: 17,
                                    width: 17,
                                    color: Colors.blue,
                                    // fit: BoxFit.contain,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: avoid_dynamic_calls

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentScreen extends StatefulWidget {
  var postid;

  CommentScreen(this.postid);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  Widget commentChild() {
    return FutureBuilder(
      future: AuthProvider().getcomments(widget.postid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final List response = snapshot.data as List;

        return ListView.builder(
          itemCount: response.length,
          itemBuilder: (ctx, i) {
            return Column(
              children: [
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: lightBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  // ignore: avoid_dynamic_calls
                                  image: NetworkImage(
                                    response[i]
                                        .authorAvatarUrls["24"]
                                        .toString(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    response[i].authorName.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMMMd().format(
                                      response[i].date as DateTime,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Html(
                                  data: response[i].content.rendered.toString(),
                                  onLinkTap: (url, _, __, ___) {
                                    launch(url);
                                  },
                                  onImageTap: (src, _, __, ___) {
                                    launch(src);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                // ListTile(
                //   tileColor: Colors.grey.shade100,
                //     leading: Container(
                //       width: 60.0,
                //       decoration: new BoxDecoration(
                //         image: DecorationImage(fit: BoxFit.cover,
                //           image:NetworkImage(
                //               response[i].authorAvatarUrls["24"])
                //         ),
                //           color: Colors.blue,
                //           shape: BoxShape.circle,
                //         border: Border.all(color: lightBlue,width: 3)
                //         ),
                //       // child: CircleAvatar(
                //       //     radius: 50,
                //       //     backgroundImage: NetworkImage(
                //       //         response[i].authorAvatarUrls["24"])),
                //     ),
                //     title: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           response[i].authorName,
                //           style: TextStyle(fontWeight: FontWeight.bold),
                //         ),
                //         Text(
                //           DateFormat.yMMMd().format(response[i].date),
                //           style: TextStyle(color: Colors.grey, fontSize: 12),
                //         ),
                //
                //       ],
                //     ),
                //     subtitle: Html(
                //       data: response[i].content.rendered,
                //       onLinkTap: (url, _, __, ___) {
                //         launch(url);
                //       },
                //       onImageTap: (src, _, __, ___) {
                //         launch(src);
                //       },
                //     )
                //     // Text(response[i].content.rendered),
                //     ),
              ],
            );
          },
        );

        // return ListView(
        //   children: [
        //     for (var i = 0; i < response.length; i++)
        //       Padding(
        //         padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
        //         child: ListTile(
        //           leading: GestureDetector(
        //             onTap: () async {
        //               print("Comment Clicked");
        //             },
        //             child: Container(
        //               height: 60.0,
        //               width: 50.0,
        //               decoration: new BoxDecoration(
        //                   color: Colors.blue,
        //                   borderRadius:
        //                       new BorderRadius.all(Radius.circular(50))),
        //               child: CircleAvatar(
        //                   radius: 50,
        //                   backgroundImage: NetworkImage(
        //                       response[i].authorAvatarUrls["24"])),
        //             ),
        //           ),
        //           title: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 response[i].authorName,
        //                 style: TextStyle(fontWeight: FontWeight.bold),
        //               ),
        //               Text(
        //                 DateFormat.yMMMd().format(response[i].date),
        //                 style: TextStyle(color: Colors.grey, fontSize: 12),
        //               ),
        //               SizedBox(
        //                 height: 5,
        //               )
        //             ],
        //           ),
        //           subtitle: Text(response[i].content.rendered),
        //         ),
        //       )
        //   ],
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: lightBlue,
      ),
      body: CommentBox(
        userImage:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7csvPWMdfAHEAnhIRTdJKCK5SPK4cHfskow&usqp=CAU",
        labelText: 'Write a comment...',
        withBorder: false,
        errorText: 'Comment cannot be blank',
        sendButtonMethod: () async {
          if (commentController.text.trim().isNotEmpty) {
            EasyLoading.show();
            await AuthProvider()
                .postcomments(widget.postid, commentController.text)
                .then(
              (value) {
                EasyLoading.dismiss();
                setState(() {});
              },
            );
            commentController.clear();
            // ignore: use_build_context_synchronously
            FocusScope.of(context).unfocus();
          } else {
            CommonWidgets.buildSnackbar(context, 'Comment cannot be empty');
          }
        },
        formKey: formKey,
        commentController: commentController,
        backgroundColor: lightBlue,
        textColor: white,
        sendWidget: Icon(Icons.send_sharp, size: 30, color: white),
        child: commentChild(),
      ),
    );
  }
}

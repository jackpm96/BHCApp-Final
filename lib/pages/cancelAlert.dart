import 'package:black_history_calender/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

cancelAlert(BuildContext context, Function confirm) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: lightBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          clipBehavior: Clip.hardEdge,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  //  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: lightBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Confirmation Required!",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Are you sure to unsubscribe from BHC subscription plan? Kindly Confirm!",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black45, fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: lightBlue,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: lightBlue,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await confirm();
                                      },
                                      child: Text(
                                        'Confirm',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

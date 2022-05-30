import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Paypal extends StatefulWidget {
  // Paypal({Key key}) : super(key: key);
  @override
  State<Paypal> createState() => _PaypalState();
}

class _PaypalState extends State<Paypal> {
  // WebViewXController webviewController;
  WebViewPlusController _controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebViewX Example App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
            this._controller = controller;
          controller.loadString(
              r"""
          <div id="paypal-button-container-P-0RW70753K95319931MKCSNCI"></div>
<script src="https://www.paypal.com/sdk/js?client-id=AXr-USTxg0GKSYnq3-UJxRTuA5Inx2dZBVei8U2-KaRC7fB-rwuWPwoyrkgqjk6DPs6SCU9HYmx2rTEo&vault=true&intent=subscription" data-sdk-integration-source="button-factory"></script>
<script>
  paypal.Buttons({
      style: {
          shape: 'pill',
          color: 'blue',
          layout: 'vertical',
          label: 'paypal'
      },
       createSubscription: function(data, actions) {
         return actions.subscription.create({
           /* Creates the subscription */
           plan_id: 'P-0RW70753K95319931MKCSNCI'
         });
       },
       onApprove: function(data, actions) {
         alert(data.subscriptionID); // You can add optional success message for the subscriber here
       }
   }).render('#paypal-button-container-P-0RW70753K95319931MKCSNCI'); // Renders the PayPal button
 </script>
      """);
        },
      )
//       WebViewX(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         initialContent:
//         r'''<div id="paypal-button-container-P-0RW70753K95319931MKCSNCI"></div>
// <script src="https://www.paypal.com/sdk/js?client-id=AXr-USTxg0GKSYnq3-UJxRTuA5Inx2dZBVei8U2-KaRC7fB-rwuWPwoyrkgqjk6DPs6SCU9HYmx2rTEo&vault=true&intent=subscription" data-sdk-integration-source="button-factory"></script>
// <script>
//   paypal.Buttons({
//       style: {
//           shape: 'pill',
//           color: 'blue',
//           layout: 'vertical',
//           label: 'paypal'
//       },
//       createSubscription: function(data, actions) {
//         return actions.subscription.create({
//           /* Creates the subscription */
//           plan_id: 'P-0RW70753K95319931MKCSNCI'
//         });
//       },
//       onApprove: function(data, actions) {
//         alert(data.subscriptionID); // You can add optional success message for the subscriber here
//       }
//   }).render('#paypal-button-container-P-0RW70753K95319931MKCSNCI'); // Renders the PayPal button
// </script>
// ''',
//             initialSourceType: SourceType.html,
//         onWebViewCreated: (controller) => webviewController = controller,
//       ),
    );
  }
}

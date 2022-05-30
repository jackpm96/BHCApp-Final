import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    //Auth
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
               let firebaseAuth = Auth.auth()
               firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
     }
     override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
               let firebaseAuth = Auth.auth()
               if (firebaseAuth.canHandleNotification(userInfo)){
                   print(userInfo)
                   return
               }
    }
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
      // UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
          // For iOS 10 display notification (sent via APNS)
         /*  UNUserNotificationCenter.current().delegate = self
           let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
           UNUserNotificationCenter.current().requestAuthorization(
             options: authOptions,
             completionHandler: { _, _ in })*/
      }
      /*else{
          let settings: UIUserNotificationSettings =
              UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
      } */
     // application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

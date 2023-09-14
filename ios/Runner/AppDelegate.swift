import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller = window.rootViewController as! FlutterViewController

      let binaryMessenger = controller.binaryMessenger

      methodChannel = MethodChannelCoordinator(binaryMessenger: binaryMessenger)

      methodChannel?.setUpMethodCallHandler()

      let viewFactory = FlutterVideoTileFactory(messenger: binaryMessenger)

      registrar(forPlugin: "AmazonChimeSDKFlutterDemo")?.register(viewFactory, withId: "videoTile")

      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

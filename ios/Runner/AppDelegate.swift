import AmazonChimeSDK
import AmazonChimeSDKMedia
import AVFoundation
import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var methodChannel: MethodChannelCoordinator?

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
      FirebaseApp.configure() //add this before the code below

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

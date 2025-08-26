import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let googleMapsApiKey = Bundle.main.infoDictionary?["Google Maps API Key"] as? String {
        GMSServices.provideAPIKey(googleMapsApiKey)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  private var securityEventSink: FlutterEventSink?
  private var isProtectionEnabled = true
  private var blurView: UIVisualEffectView?
  private var secureField: UITextField?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
 
    setupSecurityPlugin()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setupSecurityPlugin() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }
    
 
    let methodChannel = FlutterMethodChannel(
      name: "com.tamfinans/security",
      binaryMessenger: controller.binaryMessenger
    )
    
    methodChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      
      switch call.method {
      case "isScreenRecording":
        if #available(iOS 11.0, *) {
          result(UIScreen.main.isCaptured)
        } else {
          result(false)
        }
        
      case "enableProtection":
        self.isProtectionEnabled = true
        self.makeSecure()
        result(nil)
        
      case "disableProtection":
        self.isProtectionEnabled = false
        self.removeSecure()
        result(nil)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
  
    let eventChannel = FlutterEventChannel(
      name: "com.tamfinans/security/events",
      binaryMessenger: controller.binaryMessenger
    )
    eventChannel.setStreamHandler(self)
    
 
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleScreenshot),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )
    
   
    if #available(iOS 11.0, *) {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleScreenRecordingChange),
        name: UIScreen.capturedDidChangeNotification,
        object: nil
      )
    }
    
   
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appWillResignActive),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appDidBecomeActive),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
  }
  
 
  
  @objc private func appWillResignActive() {
    guard isProtectionEnabled else { return }
    addBlurOverlay()
  }
  
  @objc private func appDidBecomeActive() {
    removeBlurOverlay()
  }
  
  private func addBlurOverlay() {
    guard let window = self.window, blurView == nil else { return }
    
    let blurEffect = UIBlurEffect(style: .dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = window.bounds
    blurView.tag = 999
    
    // Add app icon or logo in center
    let iconLabel = UILabel()
    iconLabel.text = "₺"
    iconLabel.font = UIFont.boldSystemFont(ofSize: 60)
    iconLabel.textColor = .white
    iconLabel.textAlignment = .center
    iconLabel.translatesAutoresizingMaskIntoConstraints = false
    blurView.contentView.addSubview(iconLabel)
    
    NSLayoutConstraint.activate([
      iconLabel.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
      iconLabel.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor)
    ])
    
    window.addSubview(blurView)
    self.blurView = blurView
  }
  
  private func removeBlurOverlay() {
    blurView?.removeFromSuperview()
    blurView = nil
  }
  
 
  
  private func makeSecure() {
    DispatchQueue.main.async {
      guard self.secureField == nil else { return }
      guard let window = self.window else { return }
      
      let field = UITextField()
      field.isSecureTextEntry = true
     
      field.isUserInteractionEnabled = false
      
     
      field.frame = window.bounds
      
  
      guard let superlayer = window.layer.superlayer else { return }
      
      superlayer.addSublayer(field.layer)
      field.layer.sublayers?.last?.addSublayer(window.layer)
      
      self.secureField = field
    }
  }
  
  private func removeSecure() {
    DispatchQueue.main.async {
      guard let field = self.secureField else { return }
      guard let window = self.window else { return }
      
    
      field.layer.superlayer?.addSublayer(window.layer)
      field.layer.removeFromSuperlayer()
      
      self.secureField = nil
    }
  }

 
  @objc private func handleScreenshot() {
    guard isProtectionEnabled else { return }
    
    DispatchQueue.main.async { [weak self] in
      self?.securityEventSink?("screenshot")
    }
    
     let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.warning)
  }
  
  
  @objc private func handleScreenRecordingChange() {
    guard isProtectionEnabled else { return }
    
    if #available(iOS 11.0, *) {
      DispatchQueue.main.async { [weak self] in
        if UIScreen.main.isCaptured {
          self?.securityEventSink?("recording_started")
        } else {
          self?.securityEventSink?("recording_stopped")
        }
      }
    }
  }
}

 
extension AppDelegate: FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.securityEventSink = events
    
   
    if #available(iOS 11.0, *) {
      if UIScreen.main.isCaptured {
        events("recording_started")
      }
    }
    
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.securityEventSink = nil
    return nil
  }
}

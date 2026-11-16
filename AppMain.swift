import UIKit
import WebKit

// 青龙面板 iOS 壳：全屏 WKWebView 加载云端面板
let PANEL_URL = "https://wbapp-1stfwaf87xxlhh513ikkmo.app.workbuddy.host/?sharecode=HRFH4CD2IJ"

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.059, green: 0.071, blue: 0.094, alpha: 1) // #0f1218

        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let web = WKWebView(frame: view.bounds, configuration: config)
        web.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        web.backgroundColor = .clear
        web.scrollView.contentInsetAdjustmentBehavior = .never // 全屏铺到刘海区域
        web.scrollView.keyboardDismissMode = .onDrag
        view.addSubview(web)

        if let url = URL(string: PANEL_URL) {
            web.load(URLRequest(url: url))
        }
    }

    // 支持竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))

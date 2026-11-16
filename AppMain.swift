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
        web.scrollView.contentInsetAdjustmentBehavior = .never
        web.scrollView.keyboardDismissMode = .onDrag
        view.addSubview(web)

        // 关键：网页固定在安全区内，避免内容被状态栏（时间/电量）和底部小白条遮挡
        web.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            web.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            web.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            web.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            web.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        if let url = URL(string: PANEL_URL) {
            web.load(URLRequest(url: url))
        }
    }

    // 深色背景下状态栏文字用白色，清晰可见
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // 支持竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))

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

class ViewController: UIViewController, WKUIDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.059, green: 0.071, blue: 0.094, alpha: 1) // #0f1218

        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true

        let web = WKWebView(frame: view.bounds, configuration: config)
        web.uiDelegate = self // 没有它 JS 的 confirm()/alert() 会静默失效
        web.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 消除加载期间的白屏：WebView 透明露出深色底层，页面底层色也设为深色
        web.isOpaque = false
        web.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            web.underPageBackgroundColor = UIColor(red: 0.059, green: 0.071, blue: 0.094, alpha: 1)
        }
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

    // JS alert() —— 顶部横幅式提示
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "确定", style: .default) { _ in completionHandler() })
        present(ac, animated: true)
    }

    // JS confirm() —— 确认对话框（清空日志/删除任务等）
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "确定", style: .default) { _ in completionHandler(true) })
        ac.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in completionHandler(false) })
        present(ac, animated: true)
    }

    // JS prompt() —— 输入对话框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let ac = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        ac.addTextField { $0.text = defaultText }
        ac.addAction(UIAlertAction(title: "确定", style: .default) { _ in completionHandler(ac.textFields?.first?.text) })
        ac.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in completionHandler(nil) })
        present(ac, animated: true)
    }

    // 支持竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))

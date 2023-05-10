//  WebViewController.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 22/02/2021.

import WebKit

class AttWebViewController: UIViewController {
    lazy var webView: WKWebView = WKWebView(frame: .zero, configuration: loadConfig())
    lazy var progressBar: UIProgressView = UIProgressView()
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.webView)
        
        self.webView.frame = self.view.frame
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 16),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        self.webView.addSubview(self.progressBar)
        self.setProgressBarPosition()

        webView.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        self.progressBar.progress = 0.1
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAttNavigationBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideAttNavigationBar()
    }
    
    func setProgressBarPosition() {
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.webView.removeConstraints(self.webView.constraints)
        self.webView.addConstraints([
            self.progressBar.topAnchor.constraint(equalTo: self.webView.topAnchor, constant: self.webView.scrollView.contentOffset.y * -1),
            self.progressBar.leadingAnchor.constraint(equalTo: self.webView.leadingAnchor),
            self.progressBar.trailingAnchor.constraint(equalTo: self.webView.trailingAnchor),
        ])
    }
    
    func loadConfig() -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        if #available(iOS 14, *) {
            let prefrences = WKWebpagePreferences()
            prefrences.allowsContentJavaScript = true
            config.defaultWebpagePreferences = prefrences
        } else {
            let prefrences = WKPreferences()
            prefrences.javaScriptEnabled = true
            config.preferences = prefrences
        }
        return config
    }
    
    // MARK: - Web view progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: { () in
                    self.progressBar.alpha = 0.0
                }, completion: { finished in
                    self.progressBar.setProgress(0.0, animated: false)
                })
            } else {
                self.progressBar.isHidden = false
                self.progressBar.alpha = 1.0
                progressBar.setProgress(Float(self.webView.estimatedProgress), animated: true)
            }
            
        case "contentOffset":
            self.setProgressBarPosition()
            
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

//  SwiftUIWebView.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 12/02/2021.

import SwiftUI
import WebKit

struct AttSwiftUIWebView: UIViewControllerRepresentable {
    
    // - Props
    let url: URL?
    var delegate: WKNavigationDelegate?
    
    typealias UIViewControllerType = AttWebViewController
    
    func makeUIViewController(context: Context) -> AttWebViewController {
        let wbController = AttWebViewController()
        
        wbController.webView.navigationDelegate = delegate
        wbController.view.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
        wbController.webView.backgroundColor = AttAppTheme.attSDKBackgroundColor.uiColor()
        
        if let url = url {
            let request = URLRequest(url: url)
            wbController.webView.load(request)
        }
        
        return wbController
    }
    
    func updateUIViewController(_ webviewController: AttWebViewController, context: Context) {
        //
    }
}

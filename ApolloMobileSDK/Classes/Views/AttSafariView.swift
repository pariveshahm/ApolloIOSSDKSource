//  SafariView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 21/01/2021.

import SwiftUI
import SafariServices

struct AttSafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = AttCustomSafariViewController

    var url: URL?

    func makeUIViewController(context: UIViewControllerRepresentableContext<AttSafariView>) -> AttCustomSafariViewController {
        let sfc = AttCustomSafariViewController()
        return sfc
    }

    func updateUIViewController(_ safariViewController: AttCustomSafariViewController, context: UIViewControllerRepresentableContext<AttSafariView>) {
        safariViewController.url = url
    }
}

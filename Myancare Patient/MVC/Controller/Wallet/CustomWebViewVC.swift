//
//  CustomWebViewVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 5/6/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import WebKit

class CustomWebViewVC: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "\(urlString)")!
        webView.load(URLRequest(url: url))
        
//        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
//        toolbarItems = [refresh]
//        navigationController?.isToolbarHidden = false
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let webUrlString = webView.url!.absoluteString
        
        if webUrlString.contains("myancare"){
            let layout = UICollectionViewFlowLayout()
            let homeVC = HomeViewController(collectionViewLayout:layout)
            let navController = UINavigationController(rootViewController: homeVC)
            homeVC.pushToVC(vc: WalletVC())
            UtilityClass.changeRootViewController(with: navController)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

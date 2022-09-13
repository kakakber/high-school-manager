//
//  webViewVC.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 03/02/18.
//  Copyright © 2018 Enrico Alberti. All rights reserved.
//

import UIKit

class webViewVC: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var topLink: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var lefT: UIButton!
    @IBOutlet weak var righT: UIButton!
    @IBOutlet weak var safariOutlet: UIButton!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topLink.text! = urlSel
        self.navigationController?.navigationBar.isHidden = true
        let url = URL (string: urlSel);
        let requestObj = URLRequest(url: url!);
        webView.scalesPageToFit = true
        webView.loadRequest(requestObj);
        lefT.isHidden = true
        righT.isHidden = true
        webView.delegate=self
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    var count = 0
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        count += 1
        self.progressView.isHidden = false
        
        self.progressView.setProgress(0.1, animated: false)
        if count > 1{
            topLink.text! = (webView.request?.url?.absoluteString)!}
        
    }
    
   
    @IBAction func backBtn(_ sender: Any) {
        if(webView.canGoBack) {
            //Go back in webview history
            webView.goBack()
        } else {
            //Pop view controller to preview view controller
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func safari(_ sender: Any) {
        if let text = webView.request?.url?.absoluteString{
            UIApplication.shared.openURL(URL(string: text)!)
        }
    }
    
    @IBAction func rightArrow(_ sender: Any) {
        if(webView.canGoForward) {
            //Go back in webview history
            webView.goForward()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.progressView.setProgress(1.0, animated: true)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (Timer) in
            self.progressView.isHidden = true
        }
        if count > 1{
            toolBar.isHidden = false
            lefT.isHidden = false
            righT.isHidden = false
            safariOutlet.isHidden = false}
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.progressView.setProgress(1.0, animated: true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

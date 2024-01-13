//
//  ProjectWebViewVC.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 13/01/2024.
//

import UIKit
import WebKit
import ReSwift
import SwiftSoup

class ProjectWebViewVC: UIViewController, Storyboarded {

    var project: Project?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadWebView() {
        guard let document = project?.document else { return }
        do {
            let htmlCode = try document.outerHtml()
            print("loadWebView:", htmlCode)
            webView.loadHTMLString( htmlCode, baseURL: nil)
        } catch Exception.Error(let type, let message) {
            print(type, message)
        } catch {
            print("error")
        }
    }

}

extension ProjectWebViewVC: StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
        ReduxStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ReduxStore.unsubscribe(self)
    }
    
    func newState(state: ReduxState) {
        if project == nil {
            project = state.openedProject
            loadWebView()
        }
    }
}

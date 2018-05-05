//
//  PreviewViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 5/4/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Down

class PreviewViewController: GhostBaseDetailViewController {
  @IBOutlet weak var webView: WKWebView!
  
  var markdown: String = "" {
    didSet {
      renderPreview()
    }
  }
  
  func renderPreview() {
    let down = Down(markdownString: markdown)
    let html = try? down.toHTML()
    webView.loadHTMLString(html!, baseURL: URL(string: "http://foo"))
  }
}

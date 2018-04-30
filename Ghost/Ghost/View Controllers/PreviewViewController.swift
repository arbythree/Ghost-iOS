//
//  PreviewViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class PreviewViewController: UIViewController {
  private var post: Post = Post();
//  @IBOutlet webview
  
  @IBAction func done() {
    self.dismiss(animated: true, completion: nil);
  }
  
  func setPost(value: Post) {
    post = value;
//    var markdown = Markdown();
//    let html = markdown.transform(post.markdown);
  }
}

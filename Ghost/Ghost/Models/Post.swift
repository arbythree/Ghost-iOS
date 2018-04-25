//
//  Post.swift
//  Ghost
//
//  Created by Ray Bradley on 4/24/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import Alamofire

class Post {
  var title = "";
  
  class func all() -> [Post] {
    let headers: HTTPHeaders = [
      "Authorization": "Bearer pJXILEv2O3E0zglIBF0j1eIAXoHye2SFPBwG8Tx3ZFaxEbNVvTTEjPCj3RbJooeyjmjr81REABQcXBeJmJZ7shFzi35xdRHV2SPjHfa79VN9mn7Kw2TeTt0bR67Rbw2TX3Qswr2fspwhrZTESKMEEAeyTnQiHa6B0pORKzUSch5fo1oVtpZRYx0bzziFgFD"
    ]
    Alamofire.request("https://theojisan.com/ghost/api/v0.1/posts", headers: headers).responseJSON { response in
      
    }
    
    return [];
  }
}

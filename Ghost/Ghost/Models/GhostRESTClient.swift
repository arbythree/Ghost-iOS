//
//  GhostRESTClient.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import Alamofire

class GhostRESTClient {
    func getJSON(url: String, completionHandler: @escaping (_ : NSDictionary) -> ()) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer pJXILEv2O3E0zglIBF0j1eIAXoHye2SFPBwG8Tx3ZFaxEbNVvTTEjPCj3RbJooeyjmjr81REABQcXBeJmJZ7shFzi35xdRHV2SPjHfa79VN9mn7Kw2TeTt0bR67Rbw2TX3Qswr2fspwhrZTESKMEEAeyTnQiHa6B0pORKzUSch5fo1oVtpZRYx0bzziFgFD"
        ]
        
        let fullURL = "https://theojisan.com/ghost/api/v0.1\(url)"
        
        Alamofire.request(fullURL, headers: headers).responseJSON { response in
            let status = response.response?.statusCode;
            if (status == 200) {
                let json = response.result.value as! NSDictionary;
                completionHandler(json);
            }
        }
    }
}

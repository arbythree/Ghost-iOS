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
  func fullURL(path: String) -> String {
    return "https://theojisan.com/ghost/api/v0.1\(path)";
  }
  
  func authorizationHeader() -> HTTPHeaders {
    let mgr = AuthenticationManager.sharedManager;
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(mgr.token!)"
    ]
    return headers
  }
  
  func getJSON(path: String, parameters: [String: Any], completionHandler: @escaping (_ : NSDictionary) -> Void) {
    Alamofire.request(fullURL(path: path), parameters: parameters, headers: authorizationHeader()).responseJSON { response in
      let status = response.response?.statusCode;
      if (status == 200) {
        let json = response.result.value as! NSDictionary;
        completionHandler(json);
      }
    }
  }
  
  func post(path: String, parameters: [String: Any], success: @escaping (String) -> Void, failure:() -> Void) -> Void {
    Alamofire.request(fullURL(path: path), method: .post, parameters: parameters, headers: authorizationHeader()).responseJSON { response in
      let status = response.response?.statusCode;
      if (status == 200) {
//        let json = response.result.value as! NSDictionary;
        success("")
      }
    }
  }
  
  func put(path: String, parameters: [String: Any], success: @escaping (NSDictionary) -> Void, failure: @escaping () -> Void) -> Void {
    Alamofire.request(fullURL(path: path), method: .put, parameters: parameters, headers: authorizationHeader()).responseJSON { response in
      let status = response.response?.statusCode;
      if (status == 200) {
        let json = response.result.value as! NSDictionary;
        success(json)
      } else {
        failure()
      }
    }
  }
  
  func fetchAuthToken(username: String, password: String, success: @escaping (String) -> Void, failure:() -> Void) -> Void {
    let params = [
      "grant_type":    "password",
      "client_id":     "ghost-admin",
      "client_secret": "5952d5f67658",
      "username":      username,
      "password":      password
    ];
    
    Alamofire.request(fullURL(path: "/authentication/token"), method: .post, parameters: params).responseJSON { response in
      let status = response.response?.statusCode;
      if (status == 200) {
        let json = response.result.value as! NSDictionary;
        success(json["access_token"] as! String);
      }
    }
  }
}

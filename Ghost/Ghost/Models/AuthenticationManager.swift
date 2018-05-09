//
//  AuthenticationManager.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import KeychainSwift

class AuthenticationManager {
  var token: String?
  var baseURL: String?
  static let sharedManager = AuthenticationManager()
  
  init() {
    let keychain = KeychainSwift();
    token = keychain.get("token")
    baseURL = keychain.get("baseURL")
  }
  
  func requiresAuthentication() -> Bool {
    return token == nil || baseURL == nil
  }
  
  func setToken(value: String) {
    token = value
    let keychain = KeychainSwift()
    keychain.set(value, forKey: "token")
  }
  
  func attemptLogin(baseURL: String, username: String, password: String, success: @escaping (String) -> Void, failure:() -> Void) {
    let client = GhostRESTClient();
    
    client.baseURL = baseURL
    
    // make the call
    client.fetchAuthToken(username: username, password: password, success: { token in
      self.setToken(value: token)
      success(token)
    }, failure: {
      failure()
    });
  }
  
  func logOut() {
    let keychain = KeychainSwift();
    keychain.delete("token")
  }
}

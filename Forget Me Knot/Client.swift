//
//  Client.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/18/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class Client {
  
  let sharedInstance = Client()
  
  private init(){}
  
  func fetchItems(completionHandler: @escaping (_ result: Any?, _ error: Error?)->Void) {
    
    guard let url = URL(string: "https://forget-me-knot-api.herokuapp.com/api/v1/items.json") else { return }
    var request = URLRequest(url: url)
    request.addValue("haroutunian_1989", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      
      guard error == nil else {
        completionHandler(nil, error)
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
        print("Non 2xx status code from server")
        return
      }
      
      guard let data = data else {
        print("Couldn't retrieve data from server")
        return
      }
      
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        completionHandler(json, nil)
      } catch {
        completionHandler(nil, error)
      }
    }
    task.resume()
  }
  
}

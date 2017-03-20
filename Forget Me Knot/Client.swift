//
//  Client.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/18/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class Client {
  
  static let sharedInstance = Client()
  
  private init(){}
  
  func fetchItems(completionHandler: @escaping (_ result: Any?, _ errorMessage: String?)->Void) {
    guard let url = URL(string: "https://forget-me-knot-api.herokuapp.com/api/v1/items.json") else { return }
    var request = URLRequest(url: url)
    request.addValue("haroutunian_1989", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      guard error == nil else {
        if let error = error {
          completionHandler(nil, error.localizedDescription)
        }
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
        completionHandler(nil, "Currently experiencing issues with server.")
        return
      }
      
      guard let data = data else {
        completionHandler(nil, "Failed to retrieve data from server.")
        return
      }
      
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        completionHandler(json, nil)
      } catch {
        completionHandler(nil, error.localizedDescription)
      }
    }
    task.resume()
  }
  
  func fetchGroceryLists(completionHandler: @escaping (_ result: Any?, _ errorMessage: String?)->Void) {
    guard let url = URL(string: "https://forget-me-knot-api.herokuapp.com/api/v1/grocery_lists.json") else { return }
    var request = URLRequest(url: url)
    request.addValue("haroutunian_1989", forHTTPHeaderField: "Authorization")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      guard error == nil else {
        if let error = error {
          completionHandler(nil, error.localizedDescription)
        }
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode < 300 else {
        completionHandler(nil, "Currently experiencing issues with server.")
        return
      }
      
      guard let data = data else {
        completionHandler(nil, "Failed to retrieve data from server.")
        return
      }
      
      do {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        completionHandler(json, nil)
      } catch {
        completionHandler(nil, error.localizedDescription)
      }
    }
    task.resume()
  }

  
  func upload(groceryList: GroceryList, completionHandler: @escaping (_ success: Bool, _ result: Any?)->Void) {
    guard let url = URL(string: "https://forget-me-knot-api.herokuapp.com/api/v1/grocery_lists.json") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("haroutunian_1989", forHTTPHeaderField: "Authorization")
    
    let items = groceryList.items
    var itemsJSONArray = ""
    if !items.isEmpty {
      for item in items {
        let itemJSONString = "{\"item_id\": \(item.id)},"
        itemsJSONArray.append(itemJSONString)
      }
      itemsJSONArray.remove(at: itemsJSONArray.index(before: itemsJSONArray.endIndex))
    }
    
    let itemsJSON = "[\(itemsJSONArray)]"
    
    let body = "{\"grocery_list\": {\"name\": \"\(groceryList.name)\",\"description\": \"\(groceryList.description)\",\"list_items_attributes\": \(itemsJSON)}}"
    request.httpBody = body.data(using: .utf8)
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      
      guard error == nil else {
        completionHandler(false, nil)
        return
      }
      
      guard let data = data else { return }
      
      do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          completionHandler(false, nil)
          return
        }
        
        if json["errors"] != nil {
          completionHandler(false, json)
        } else {
          completionHandler(true, json)
        }
      } catch {
      }
    }
    task.resume()
  }
  
}

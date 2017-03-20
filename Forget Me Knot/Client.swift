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
    guard let url = URL(string: "\(Constants.Http.BaseUrl)\(Constants.Http.FetchItemsEndPath)") else { return }
    
    initiateGETRequest(with: url, completionHandler: completionHandler)
  }
  
  func fetchGroceryLists(completionHandler: @escaping (_ result: Any?, _ errorMessage: String?)->Void) {
    guard let url = URL(string: "\(Constants.Http.BaseUrl)\(Constants.Http.GroceryListEndPath)") else { return }
    
    initiateGETRequest(with: url, completionHandler: completionHandler)
  }
  
  private func initiateGETRequest(with url: URL, completionHandler: @escaping (_ result: Any?, _ errorMessage: String?)->Void){
    var request = URLRequest(url: url)
    request.addValue("\(Constants.Http.AuthHeaderValue)", forHTTPHeaderField: "\(Constants.Http.AuthHeaderField)")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      guard error == nil else {
        completionHandler(nil, error!.localizedDescription)
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
  
  
  func upload(groceryList: GroceryList, completionHandler: @escaping (_ result: Any?, _ errorMessage: String?)->Void) {
    guard let url = URL(string: "\(Constants.Http.BaseUrl)\(Constants.Http.GroceryListEndPath)") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
        request.addValue("\(Constants.Http.ContentHeaderValue)", forHTTPHeaderField: "\(Constants.Http.ContentHeaderField)")
        request.addValue("\(Constants.Http.AuthHeaderValue)", forHTTPHeaderField: "\(Constants.Http.AuthHeaderField)")
    
    let items = groceryList.items
    var itemsJSONArray = ""
    if !items.isEmpty {
      for item in items {
        let itemJSONString = "{\"\(Constants.JSONBodyKeys.ItemId)\": \(item.id)},"
        itemsJSONArray.append(itemJSONString)
      }
      itemsJSONArray.remove(at: itemsJSONArray.index(before: itemsJSONArray.endIndex))
    }
    
    let itemsJSON = "[\(itemsJSONArray)]"
    
    let body = "{\"\(Constants.JSONBodyKeys.GroceryList)\": {\"\(Constants.JSONBodyKeys.Name)\": \"\(groceryList.name)\",\"\(Constants.JSONBodyKeys.Description)\": \"\(groceryList.description)\",\"\(Constants.JSONBodyKeys.ListItemAttributes)\": \(itemsJSON)}}"
    request.httpBody = body.data(using: .utf8)
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
      
      guard error == nil else {
        completionHandler(nil, error!.localizedDescription)
        return
      }
      
      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
        completionHandler(nil, "Issues communicating with server")
        return
      }
      
      guard let data = data else {
        completionHandler(nil, "Failed to retrieve data from server.")
        return
      }
      
      do {
        guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
          completionHandler(nil, "Failed to retrieve Lists")
          return
        }
        
        if json["\(Constants.ResponseKeys.Errors)"] != nil {
          if let message = json["\(Constants.ResponseKeys.Message)"] as? String {
            completionHandler(nil, message)
          }
        }
        
        guard statusCode >= 200 && statusCode < 300 else {
          completionHandler(nil, "Currently experiencing issues with server.")
          return
        }
        
        completionHandler(json, nil)
      } catch {
        completionHandler(nil, error.localizedDescription)
      }
    }
    task.resume()
  }
  
}

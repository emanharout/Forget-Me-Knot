//
//  Constants.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/19/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

struct Constants {
  
  struct Http {
    static let BaseUrl = "https://forget-me-knot-api.herokuapp.com"
    static let FetchItemsEndPath = "/api/v1/items.json"
    static let GroceryListEndPath = "/api/v1/grocery_lists.json"
    
    static let AuthHeaderField = "Authorization"
    static let AuthHeaderValue = "haroutunian_1989"
    static let ContentHeaderField = "Content-Type"
    static let ContentHeaderValue = "application/json"
  }
  
  struct JSONBodyKeys {
    static let GroceryList = "grocery_list"
    static let Name = "name"
    static let Description = "description"
    static let ListItemAttributes = "list_items_attributes"
  }
  
  struct ResponseKeys {
    static let Name = "name"
    static let Id = "id"
    static let Description = "description"
    static let Items = "items"
    static let Message = "message"
    static let Errors = "errors"
  }
  
}

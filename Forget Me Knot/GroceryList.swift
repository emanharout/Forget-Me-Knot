//
//  GroceryList.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/18/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class GroceryList {
  
  let name: String
  let description: String
  let items: [Item]
  var isActive: Bool?
  
  init(name: String, description: String, items: [Item], isActive: Bool? = nil) {
    self.name = name
    self.description = description
    self.items = items
  }

}

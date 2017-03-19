//
//  Item.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/18/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import Foundation

class Item {
  
  let name: String
  let id: Int
  var isSelected: Bool
  
  init(name: String, id: Int, isSelected: Bool = false) {
    self.name = name
    self.id = id
    self.isSelected = isSelected
  }
  
}

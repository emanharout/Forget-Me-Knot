//
//  ItemCell.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/18/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
  
  var item: Item? {
    didSet {
      if let item = item {
        textLabel?.text = item.name
      }
    }
  }
  
}

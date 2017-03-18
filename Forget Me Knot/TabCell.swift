//
//  TabCell.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/17/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class TabCell: UICollectionViewCell {
  
  @IBOutlet weak var listLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.white.cgColor
  }
  
  
}

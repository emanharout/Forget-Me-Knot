//
//  ViewController.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/17/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class GroceryListsViewController: UIViewController {

  @IBOutlet weak var noListsStackView: UIStackView!
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

}

extension GroceryListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
}

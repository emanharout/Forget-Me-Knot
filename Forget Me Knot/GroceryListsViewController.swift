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
  @IBOutlet weak var listNameLabel: UILabel!
  @IBOutlet weak var listDescriptionLabel: UILabel!
  @IBOutlet weak var newListBarButtonItem: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  func setupViews() {
    setupFlowLayout()
    setupNavigationBar()
  }
  
  func setupFlowLayout() {
    flowLayout.scrollDirection = .horizontal
    flowLayout.estimatedItemSize = CGSize(width: 100, height: 50)
    flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
  }
  
  func setupNavigationBar() {
    if let logoImage = UIImage(named: "Logo") {
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 34))
      imageView.image = logoImage
      imageView.contentMode = .scaleAspectFit
      navigationItem.titleView = imageView
    }
    
    let font = UIFont(name: "Avenir-Light", size: 22)
    let attributes = [NSFontAttributeName: font!,
                      NSKernAttributeName : CGFloat(10.0)] as [String : Any]
    newListBarButtonItem.setTitleTextAttributes(attributes, for: .normal)
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

extension GroceryListsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
}

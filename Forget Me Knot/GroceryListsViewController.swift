//
//  ViewController.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/17/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class GroceryListsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  @IBOutlet weak var noListsStackView: UIStackView!
  @IBOutlet weak var listNameLabel: UILabel!
  @IBOutlet weak var listDescriptionLabel: UILabel!
  @IBOutlet weak var newListBarButtonItem: UIBarButtonItem!
  
  var client: Client!
  var groceryLists = [GroceryList]()
  var items = [Item]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showAddListViewController" {
      guard let destinationViewController = segue.destination as? AddListViewController else { return }
      destinationViewController.client = client
      destinationViewController.delegate = self
    }
  }
  
  func setupViews() {
    setupFlowLayout()
    setupNavigationBar()
    
    client.fetchGroceryLists { (result, error) in
      guard let result = result as? [[String: Any]] else {
        // TODO: Handle Error
        return
      }
      
      var groceryLists = [GroceryList]()
      
      for groceryListDictionary in result {
        var items = [Item]()
        
        if let itemsDictionary = groceryListDictionary["items"] as? [[String: Any]] {
          for itemDictionary in itemsDictionary {
            if let name = itemDictionary["name"] as? String, let id = itemDictionary["id"] as? Int {
              let item = Item(name: name, id: id)
              items.append(item)
            }
          }
        }
        
        if let name = groceryListDictionary["name"] as? String, let description = groceryListDictionary["description"] as? String {
          let groceryList = GroceryList(name: name, description: description, items: items)
          groceryLists.append(groceryList)
        }
      }
      
      self.groceryLists = groceryLists
      
      DispatchQueue.main.async {
        self.hideEmptyListStackViewIfNeeded()
        self.collectionView.reloadData()
        // invalidateLayout() called due to bug where collectionView won't scroll and display all items
        self.collectionView.collectionViewLayout.invalidateLayout()
      }
    }
    
    hideEmptyListStackViewIfNeeded()
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
  
  func hideEmptyListStackViewIfNeeded() {
    if groceryLists.isEmpty {
      for view in view.subviews {
        view.isHidden = true
      }
      noListsStackView.isHidden = false
    } else {
      for view in view.subviews {
        view.isHidden = false
      }
      noListsStackView.isHidden = true
    }
  }
  
}

extension GroceryListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as! TabCell
    
    let groceryList = groceryLists[indexPath.item]
    cell.groceryList = groceryList
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return groceryLists.count
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

extension GroceryListsViewController: AddListViewControllerDelegate {
  
  func update(items: [Item]) {
    self.items = items
  }
  
  func userDidCreateGroceryList() {
    client.fetchGroceryLists { (result, error) in
      guard let result = result as? [[String: Any]] else {
        // TODO: Handle Error
        return
      }
      
      var groceryLists = [GroceryList]()
      
      for groceryListDictionary in result {
        var items = [Item]()
        
        if let itemsDictionary = groceryListDictionary["items"] as? [[String: Any]] {
          for itemDictionary in itemsDictionary {
            if let name = itemDictionary["name"] as? String, let id = itemDictionary["id"] as? Int {
              let item = Item(name: name, id: id)
              items.append(item)
            }
          }
        }
        
        if let name = groceryListDictionary["name"] as? String, let description = groceryListDictionary["description"] as? String {
          let groceryList = GroceryList(name: name, description: description, items: items)
          groceryLists.append(groceryList)
        }
      }
      
      self.groceryLists = groceryLists
      
      DispatchQueue.main.async {
        self.hideEmptyListStackViewIfNeeded()
        self.collectionView.reloadData()
        // invalidateLayout() called due to bug where collectionView won't scroll and display all items
        self.collectionView.collectionViewLayout.invalidateLayout()
      }
    }
  }
}

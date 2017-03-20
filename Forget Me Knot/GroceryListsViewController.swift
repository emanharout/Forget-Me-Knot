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
  
  @IBOutlet weak var contentContainerView: UIView!
  @IBOutlet weak var noListsStackView: UIStackView!
  
  @IBOutlet weak var listNameLabel: UILabel!
  @IBOutlet weak var listDescriptionLabel: UILabel!
  @IBOutlet weak var newListBarButtonItem: UIBarButtonItem!
  
  var client: Client!
  var groceryLists = [GroceryList]()
  var items = [Item]()
  var displayedItems = [Item]()
  var selectedTab: (list: GroceryList, index: Int, cell: TabCell)? {
    didSet {
      if let oldValue = oldValue {
        oldValue.list.isActive = false
        
        oldValue.cell.layer.backgroundColor = UIColor.clear.cgColor
        oldValue.cell.listLabel.textColor = UIColor.white
        oldValue.cell.isSelected = false
      }
      
      if let selectedTab = selectedTab {
        selectedTab.cell.layer.backgroundColor = UIColor.white.cgColor
        selectedTab.cell.listLabel.textColor = UIColor(colorLiteralRed: 214/255, green: 124/255, blue: 221/255, alpha: 1.0)
      }
    }
  }
  
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
    contentContainerView.isHidden = true
    noListsStackView.isHidden = true
    
    setupFlowLayout()
    setupNavigationBar()
    displayGroceryLists() {
      self.hideEmptyListStackViewIfNeeded()
    }
  }
  
  func setupFlowLayout() {
    flowLayout.scrollDirection = .horizontal
    flowLayout.estimatedItemSize = CGSize(width: 100, height: 50)
    flowLayout.sectionInset = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    flowLayout.minimumLineSpacing = 24.0
  }
  
  func setupNavigationBar() {
    if let logoImage = UIImage(named: "Logo") {
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 34))
      imageView.image = logoImage
      imageView.contentMode = .scaleAspectFit
      navigationItem.titleView = imageView
    }
    
    let font = UIFont(name: "Avenir-Light", size: 15)
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
  
  func displayGroceryLists(completionHandler: (()->Void)?) {
    client.fetchGroceryLists { (result, errorMessage) in
      defer {
        if let completionHandler = completionHandler {
          DispatchQueue.main.async {
            completionHandler()
          }
        }
      }
      
      if let errorMessage = errorMessage {
        DispatchQueue.main.async {
          self.displayAlert(with: "Networking Issues", and: "\(errorMessage)", completionHandler: nil)
        }
        return
      }
      
      guard let result = result as? [[String: Any]] else { return }
      var groceryLists = [GroceryList]()
      
      for groceryListDictionary in result {
        var items = [Item]()
        
        if let itemsDictionary = groceryListDictionary["\(Constants.ResponseKeys.Items)"] as? [[String: Any]] {
          for itemDictionary in itemsDictionary {
            if let name = itemDictionary["\(Constants.ResponseKeys.Name)"] as? String, let id = itemDictionary["\(Constants.ResponseKeys.Id)"] as? Int {
              let item = Item(name: name, id: id)
              items.append(item)
            }
          }
        }
        
        if let name = groceryListDictionary["\(Constants.ResponseKeys.Name)"] as? String, let description = groceryListDictionary["\(Constants.ResponseKeys.Description)"] as? String {
          let groceryList = GroceryList(name: name, description: description, items: items)
          groceryLists.append(groceryList)
        }
      }
      
      let lastIndexOfCurrentList = self.groceryLists.endIndex
      let lastIndexOfNewList = groceryLists.endIndex
      
      if lastIndexOfCurrentList > 0 {
        for index in lastIndexOfCurrentList...lastIndexOfNewList - 1 {
          let list = groceryLists[index]
          self.groceryLists.append(list)
        }
      } else {
        self.groceryLists = groceryLists
      }
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
        // invalidateLayout() called due to collectionView not scrolling and displaying all items
        self.collectionView.collectionViewLayout.invalidateLayout()
      }
    }
  }
  
  func displayAlert(with title: String, and message: String, completionHandler: ((_ alertController: UIAlertController)->Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}

extension GroceryListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as! TabCell
    if let groceryListActive = groceryLists[indexPath.item].isActive, groceryListActive == true {
      cell.layer.backgroundColor = UIColor.white.cgColor
      cell.listLabel.textColor = UIColor(red: 214/255, green: 124/255, blue: 221/255, alpha: 1.0)
    } else {
      cell.layer.backgroundColor = UIColor.clear.cgColor
      cell.listLabel.textColor = UIColor.white
    }

    let groceryList = groceryLists[indexPath.item]
    cell.groceryList = groceryList
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? TabCell {
      let groceryList = groceryLists[indexPath.item]
      groceryList.isActive = true
      selectedTab = (list: groceryList, index: indexPath.item, cell: cell)
      
      listNameLabel.text = selectedTab?.cell.groceryList?.name
      listDescriptionLabel.text = selectedTab?.cell.groceryList?.name
      displayedItems = cell.groceryList?.items ?? []
      tableView.reloadData()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return groceryLists.count
  }
  
}

extension GroceryListsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
    
    let item = displayedItems[indexPath.row]
    cell.item = item
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayedItems.count
  }
  
}

extension GroceryListsViewController: AddListViewControllerDelegate {
  
  func update(items: [Item]) {
    self.items = items
  }
  
  func userDidCreateGroceryList() {
    displayGroceryLists(completionHandler: nil)
  }
}

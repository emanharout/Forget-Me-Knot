//
//  AddListViewController.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/18/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class AddListViewController: UIViewController {
  
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var doneButton: UIButton!
  
  var client: Client!
  var items = [Item]()
  // TODO: See if we can replace with Set
  var selectedItems = [Item]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    client.fetchItems { (result, error) in
      if let result = result {
        
        guard let itemsArray = result as? [[String: Any]] else { return }
        
        for item in itemsArray {
          if let name = item["name"] as? String, let id = item["id"] as? Int {
            let item = Item(name: name, id: id)
            self.items.append(item)
          }
        }
        
        let mainQueue = DispatchQueue.main
        mainQueue.async {
          self.tableView.reloadData()
        }
      } else if let error = error {
        print(error)
      }
    }
  }
  
  func setupNavigationBar() {
    if let logoImage = UIImage(named: "Logo") {
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 34))
      imageView.image = logoImage
      imageView.contentMode = .scaleAspectFit
      navigationItem.titleView = imageView
    }
  }
  
  @IBAction func createList(_ sender: UIButton) {
    guard let name = nameTextField.text, let description = descriptionTextField.text else { return }
    
    let groceryList = GroceryList(name: name, description: description, items: selectedItems)
    client.upload(groceryList: groceryList) { (result, error) in
      print(error)
      print(result)
    }
  }
}

extension AddListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
    
    let item = items[indexPath.row]
    cell.item = item
    
    if item.isSelected {
      cell.accessoryType = .checkmark
    } else if !item.isSelected {
      cell.accessoryType = .none
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let cell = tableView.cellForRow(at: indexPath)
    let item = items[indexPath.row]
    
    item.isSelected = !item.isSelected
    
    if item.isSelected {
      cell?.accessoryType = .checkmark
      selectedItems.append(item)
    } else if !item.isSelected {
      cell?.accessoryType = .none
      
      for (index, selectedItem) in selectedItems.enumerated() {
        if item === selectedItem {
          selectedItems.remove(at: index)
        }
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
}

extension AddListViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}

//
//  AddListViewController.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/18/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

protocol AddListViewControllerDelegate: class {
  func update(items: [Item])
  func userDidCreateGroceryList()
}

class AddListViewController: UIViewController {
  
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var doneButton: UIButton!
  
  var client: Client!
  var items = [Item]()
  var selectedItems = [Item]()
  weak var delegate: AddListViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    client.fetchItems { (result, error) in
      if let error = error {
        self.displayAlert(with: "Failed to Retrieve Items", and: error, completionHandler: nil)
        return
      }
      
      guard let result = result, let itemsArray = result as? [[String : Any]] else { return }
      
      for item in itemsArray {
        if let name = item["name"] as? String, let id = item["id"] as? Int {
          let item = Item(name: name, id: id)
          self.items.append(item)
        }
      }
      
      self.delegate?.update(items: self.items)
      let mainQueue = DispatchQueue.main
      mainQueue.async {
        self.tableView.reloadData()
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
  
  func displayAlert(with title: String, and message: String, completionHandler: ((_ alertController: UIAlertController)->Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func createList(_ sender: UIButton) {
    guard let name = nameTextField.text, let description = descriptionTextField.text else { return }
    let groceryList = GroceryList(name: name, description: description, items: selectedItems)
    
    client.upload(groceryList: groceryList) { (success, result) in
      DispatchQueue.main.async {
        guard success == true else {
          if let result = result as? [String: Any], let message = result["message"] as? String {
            self.displayAlert(with: "Upload Failed", and: message) { (alertController) in
              self.dismiss(animated: true, completion: nil)
            }
          } else {
            self.displayAlert(with: "Upload Failed", and: "Experiencing networking issues") { (alertController) in
              self.dismiss(animated: true, completion: nil)
            }
          }
          return
        }
        
        self.delegate?.userDidCreateGroceryList()
        _ = self.navigationController?.popViewController(animated: true)
      }
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

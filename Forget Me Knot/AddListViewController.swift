//
//  AddListViewController.swift
//  Forget Me Knot
//
//  Created by Emmanuoel Haroutunian on 3/18/17.
//  Copyright © 2017 Emmanuoel Haroutunian. All rights reserved.
//

import UIKit

class AddListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var client: Client!
  var items = [Item]()
  
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
  
}

extension AddListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    
    let item = items[indexPath.row]
    cell.textLabel?.text = item.name
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
}

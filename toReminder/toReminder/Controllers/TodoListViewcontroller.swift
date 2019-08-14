//
//  ViewController.swift
//  toReminder
//
//  Created by Gaurav Gaikwad on 8/12/19.
//  Copyright © 2019 anuja. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewcontroller: SwipeTableViewController {
var  todoItems: Results<Item>?
let realm = try! Realm()

    @IBOutlet weak var BarButton: UISearchBar!
    var selectedCategory : Category?{
            didSet{
        loadItems()
            }
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            loadItems()
            
            tableView.separatorStyle = .none
        }
   override func viewWillAppear(_ animated: Bool) {
    
        if let colourHex = selectedCategory?.color {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar
                else {
                    fatalError("error")}
            if let navBarColor = UIColor(hexString: colourHex){
                navBar.barTintColor = navBarColor
            BarButton.barTintColor = navBarColor
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
    }
    }
    }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            if let item = todoItems?[indexPath.row]
            {
            cell.textLabel?.text = item.title

                if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                    cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
//                cell.accessoryType = item.done ? .checkmark : .none

            }else{
                cell.textLabel?.text = "No Items Added"
            }
            return cell
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if let item = todoItems?[indexPath.row]{
                do{
                    try realm.write {
                        item.done = !item.done
                    }
                }catch{
                    print("error")
                }
            }
            
            
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
        

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Items to List", message:"", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item ", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textfield.text!
                        newItem.dateCreated = Date()
                        currentCategory.item.append(newItem)
                    }
          
            }
                catch{
                    print("error")
                }
      }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadItems(){
        todoItems = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)
tableView.reloadData()

    }
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }}
                catch{
                    print("error")
                }
            }
        }
    }



extension TodoListViewcontroller: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "datecreated", ascending: true)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()
            }
        }
    }
}




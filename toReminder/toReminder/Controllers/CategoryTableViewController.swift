//
//  CategoryTableViewController.swift
//  toReminder
//
//  Created by Gaurav Gaikwad on 8/12/19.
//  Copyright © 2019 anuja. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController  {
    
     let realm = try! Realm()
    var categories: Results<Category>!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
        
        
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added yet"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
        
        return cell
        
    }
    
    // tableview delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dstinationVC = segue.destination as! TodoListViewcontroller
        if let indexpath = tableView.indexPathForSelectedRow {
            dstinationVC.selectedCategory = categories?[indexpath.row]
        }
        
    }
    
    
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
            
        }
        catch{
            print("error")
            
            
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
       
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
   override func updateModel(at indexPath: IndexPath) {
    super.updateModel(at: indexPath)
    if let categoryForDeletion = self.categories?[indexPath.row]{
        do{
            try self.realm.write {
                self.realm.delete(categoryForDeletion)
            }
            
        }
        catch{
            print("error")
        }
    }
    }
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        

            var textspace = UITextField()
            let alert = UIAlertController(title: "Add Categories ", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                let newCategory = Category()
                newCategory.name = textspace.text!
                newCategory.color = UIColor.randomFlat.hexValue()
        
                self.save(category: newCategory)
                
            }
            alert.addAction(action)
            alert.addTextField { (field) in
                textspace = field
                textspace.placeholder = "Add a new category"
            }
            present(alert, animated: true, completion: nil)
            
            
        }
        
        
        
        
    }
    

  

    
    


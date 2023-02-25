//
//  CategoryViewController.swift
//  Todoie
//
//  Created by Vinny Lazzara on 2/22/23.
//


/* FONTS:
 
 font: CourierNewPSMT
 font: CourierNewPS-ItalicMT
 font: CourierNewPS-BoldMT
 font: CourierNewPS-BoldItalicMT
 font: ELEGANTTYPEWRITER
 font: ELEGANTTYPEWRITER-Light
 font: ELEGANTTYPEWRITER-Bold
 */
import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    
    //MARK: Properties
    
    let realm = try! Realm()
    
    var categories: Results<ItemCategory>?
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadSavedData()
  
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //User clicks add item button
            let newCategory = ItemCategory()
            newCategory.name = textField.text ?? ""
            self.updateSavedData(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "School"
            textField = alertTextField
        }
                           
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: Data Manipulation
    
    func updateSavedData(category: ItemCategory){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadSavedData(){
        //Uses all ItemCategories as default for request
       
        categories = realm.objects(ItemCategory.self)
        tableView.reloadData()
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
             do{
                 try self.realm.write {self.realm.delete(categoryForDeletion)}
             } catch {
                 print(error.localizedDescription)
             }
             
         }
    }
   

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Tap the + to add categories"
    
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        let backItem = UIBarButtonItem()
        backItem.title = ""
        
        if traitCollection.userInterfaceStyle == .dark{
            backItem.tintColor = .white
        } else {
            backItem.tintColor = .black
        }

        navigationItem.backBarButtonItem = backItem
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            destinationVC.title = categories?[indexPath.row].name
        }
        
    }


    
}



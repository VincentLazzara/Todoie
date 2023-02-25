//
//  ViewController.swift
//  Todoie
//
//  Created by Vinny Lazzara on 2/20/23.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController{
    
    //MARK: Properties
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?{
        didSet{
            tableView.reloadData()
        }
    }
    
    var selectedCategory : ItemCategory? {
        didSet{
            loadSavedData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedData()
        
    }
    
    //MARK: Tableview Datasource Methods

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.tintColor = .darkGray
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        
        } else {
            cell.textLabel?.text = "No Items Added"
        }
    
        return cell
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    
    
    //MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.isDone.toggle()
                }
            } catch{
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: Add new items
    
    
    func updateSavedData(item: Item){
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
        
    }
    

    func loadSavedData(){
        //Uses all Items as default for request
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
             do{
                 try self.realm.write {self.realm.delete(itemForDeletion)}
             } catch {
                 print(error.localizedDescription)
             }
             
         }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //User clicks add item button
         
            if let currentCategory = self.selectedCategory{
                do{ try self.realm.write{
                    let newItem = Item()
                    newItem.title = textField.text ?? ""
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                } } catch {
                    print(error)
                }
                 
            }
            self.tableView.reloadData()
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "What's on your list?"
            textField = alertTextField
        }
                           
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}


//MARK: UISearchBarDelegate


extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            loadSavedData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                searchBar.endEditing(true)
            }
        } else {
            todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadSavedData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                searchBar.endEditing(true)
            }
        } else {
            todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
    
    
}


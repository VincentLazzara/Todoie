//
//  SwipeTableViewController.swift
//  Todoie
//
//  Created by Vinny Lazzara on 2/24/23.
//

import UIKit
import SwipeCellKit

//Superclass for swiping functinality & front-end UI for tableviewcontrollers

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
          
                self.updateModel(at: indexPath)
            }
         
            
            // customize the action appearance
            deleteAction.font = UIFont(name: "ELEGANTTYPEWRITER-Bold", size: 16)
            let image = UIImage(named: "delete-icon-handdrawn")?.withTintColor(.white, renderingMode: .alwaysTemplate)
            
            deleteAction.image = image
            deleteAction.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.59, alpha: 1.00)
            return [deleteAction]
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }
    
    //MARK: TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

        cell.textLabel?.font = UIFont(name: "ELEGANTTYPEWRITER-Light", size: 18)
        cell.delegate = self
        
        return cell
        
    }
    
    func updateModel(at indexPath: IndexPath){
        //Update data model used for override
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
        
        
        
        
    


   

}

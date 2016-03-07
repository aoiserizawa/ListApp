//
//  ViewController.swift
//  ListApp
//
//  Created by Luisito Yumang on 3/7/16.
//  Copyright © 2016 Alvin Joseph Valdez. All rights reserved.
//

import UIKit
import CoreData


class TableViewController: UITableViewController {

    var listItems = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addItem"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell")! as UITableViewCell
        
        let item = listItems[indexPath.row]
        
        cell.textLabel?.text = item.valueForKey("item") as! String
        
        return cell
    }
    
    func addItem(){
        let alertController = UIAlertController(title: "Type Something", message: "Type...", preferredStyle: UIAlertControllerStyle.Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            
                if let field = alertController.textFields![0] as? UITextField {
                    self.saveItem(field.text!)
                    self.tableView.reloadData()
                }
        
            })
        )
        
        let cancelAction = UIAlertAction (title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addTextFieldWithConfigurationHandler({
            (textField) in
            
            textField.placeholder = "Type Something!!"
        })
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
   
    
    func saveItem(itemToSave: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let manageContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("ListEntity", inManagedObjectContext: manageContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: manageContext)
        
        
        item.setValue(itemToSave, forKey: "item")
        do{
            try manageContext.save()
            listItems.append(item)
        }catch{
            print("error")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let manageContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ListEntity")
        
        do{
            let results = try manageContext.executeFetchRequest(fetchRequest)
            listItems = results as! [NSManagedObject]
        }catch{
            print("Error")
        }
    }
    


}


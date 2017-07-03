//
//  ViewController.swift
//  Checklists
//
//  Created by Mitesh Malaviya on 7/2/17.
//  Copyright © 2017 Mitesh Malaviya. All rights reserved.
//

import UIKit

class CheckListViewCorntroller: UITableViewController, ItemDetailViewControllerDelegate{
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    
//    required init?(coder aDecoder: NSCoder) {
//        items = [ChecklistItem]()
//        let row0item = ChecklistItem()
//        row0item.text = "Walk the dog"
//        row0item.checked = false
//        items.append(row0item)
//        let row1item = ChecklistItem()
//        row1item.text = "Brush my teeth"
//        row1item.checked = true
//        items.append(row1item)
//        let row2item = ChecklistItem()
//        row2item.text = "Learn iOS development"
//        row2item.checked = true
//        items.append(row2item)
//        let row3item = ChecklistItem()
//        row3item.text = "Soccer practice"
//        row3item.checked = false
//        items.append(row3item)
//        let row4item = ChecklistItem()
//        row4item.text = "Eat ice cream"
//        row4item.checked = true
//        items.append(row4item)
//        super.init(coder: aDecoder)
//    }
//    
    
    
//    func loadChecklistItems() {
//        let path = dataFilePath()
//        // 2
//        if let data = try? Data(contentsOf: path) {
//            // 3
//            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
//            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
//            unarchiver.finishDecoding()
//        }
//    }
//
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }


    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
//        saveChecklistItems()
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            //            let item = items[indexPath.row]
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }

    
//    @IBAction func addItem() {
//
//        let newRowIndex = items.count
//        let item = ChecklistItem()
//        item.text = "I am a new row"
//        item.checked = false
//        items.append(item)
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
//        
//        
//    }
    
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    
//    func saveChecklistItems() {
//        let data = NSMutableData()
//        let archiver = NSKeyedArchiver(forWritingWith: data)
//        archiver.encode(items, forKey: "ChecklistItems")
//        archiver.finishEncoding()
//        data.write(to: dataFilePath(), atomically: true)
//    }
    
    

    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        // 2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                                  didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
//        saveChecklistItems()
    }

    

    func itemDetailViewController(_ controller: ItemDetailViewController,
                                  didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
//        saveChecklistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            
            let controller = navigationController.topViewController                 as! ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    
    


}


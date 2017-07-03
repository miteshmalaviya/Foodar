//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Mitesh Malaviya on 7/2/17.
//  Copyright © 2017 Mitesh Malaviya. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
//    var lists: [Checklist]

    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
//    required init?(coder aDecoder: NSCoder) {
//        lists = [Checklist]()
//        super.init(coder: aDecoder)
//        var list = Checklist()
//        list.name = "Birthdays"
//        lists.append(list)
//        list = Checklist()
//        list.name = "Groceries"
//        lists.append(list)
//        list = Checklist()
//        list.name = "Cool Apps"
//        lists.append(list)
//        list = Checklist()
//        list.name = "To Do"
//        lists.append(list)
//    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    
//    func makeCell(for tableView: UITableView) -> UITableViewCell {
//        let cellIdentifier = "Cell"
//        if let cell =
//            tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
//            return cell
//        } else {
//            return UITableViewCell(style: .default,
//                                   reuseIdentifier: cellIdentifier)
//            
//        }
//    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        
        cell.imageView!.image = UIImage(named: "Appintments@2x")
        
        return cell
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell =
            tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle,
                                   reuseIdentifier: cellIdentifier)
        }
    }

    
    //    func documentsDirectory() -> URL {
    //        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //        return paths[0]
    //    }
    //
    //    func dataFilePath() -> URL {
    //        return documentsDirectory().appendingPathComponent("Checklists.plist")
    //    }
    

    
    //    func saveChecklists() {
    //        let data = NSMutableData()
    //        let archiver = NSKeyedArchiver(forWritingWith: data)
    //        archiver.encode(lists, forKey: "Checklists")
    //        archiver.finishEncoding()
    //        data.write(to: dataFilePath(), atomically: true)
    //    }
    //
    //    func loadChecklists() {
    //        let path = dataFilePath()
    //        if let data = try? Data(contentsOf: path) {
    //            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
    //            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
    //            unarchiver.finishDecoding()
    //            sortChecklists()
    //        }
    //    }
    //    



    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
//        let checklist = lists[indexPath.row]
//        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        
        
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)

    }
    
//    func itemDetailViewController(_ controller: ItemDetailViewController,
//                                  didFinishAdding item: ChecklistItem) {
//        let newRowIndex = checklist.items.count
//        checklist.items.append(item)
//        
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
//        
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func itemDetailViewController(_ controller: ItemDetailViewController,
//                                  didFinishEditing item: ChecklistItem) {
//        if let index = checklist.items.index(of: item) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                configureText(for: cell, with: item)
//            }
//        }
//        dismiss(animated: true, completion: nil)
//    }
    

    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }



    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let navigationController = storyboard!.instantiateViewController(
            withIdentifier: "ListDetailNavigationController")
            as! UINavigationController
        
        let controller = navigationController.topViewController
            as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! CheckListViewCorntroller
            controller.checklist = sender as! Checklist
            
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
//        tableView.reloadData()

    }
    
    
   

}

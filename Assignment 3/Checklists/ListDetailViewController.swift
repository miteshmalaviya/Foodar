//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Mitesh Malaviya on 7/2/17.
//  Copyright © 2017 Mitesh Malaviya. All rights reserved.
//

import Foundation

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist)
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
        
  

        iconImageView.image = UIImage(named: iconName)
    }
    
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?

    var iconName = "Folder"
    
    //text field
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    

    
    
    //tab bar buttons, cancel and done
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self,
                                               didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self,
                                               didFinishAdding: checklist)
        }
    }

    
    
    //icon & tableview
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    
    
    }

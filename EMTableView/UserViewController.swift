//
//  UserViewController.swift
//  EMTableView
//
//  Created by Edgard Matos on 08/01/18.
//  Copyright © 2018 Edgard Matos. All rights reserved.
//

import UIKit
import RealmSwift

class UserViewController: UIViewController {
    
    //MARK: Properties    

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        updateSaveButtonState()
        
        if let user = user {
            navigationItem.title = user.name
            nameTextField.text = user.name
            emailTextField.text = user.email
        } else {
            let leftNavBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(back))
            navigationItem.leftBarButtonItem = leftNavBarButton
        }
    }
    
    
    //MARK: Navigation
    @objc func back() {
        let isPresentingInAdd = presentingViewController is UINavigationController
        
        if isPresentingInAdd {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
    }

    
    //MARK: Private Methods
    @IBAction func save(_ sender: UIBarButtonItem) {
        let userToSave = User()
        if let user = user {
            userToSave.id = user.id
        } else {
            userToSave.id = incrementID()
        }
        
        userToSave.name = nameTextField.text!
        userToSave.email = emailTextField.text!
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(userToSave, update: true)
            back()
        }
    }

    private func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !email.isEmpty
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(User.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

extension UserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = (nameTextField.text?.isEmpty)! ? "New User" : nameTextField.text
        updateSaveButtonState()
    }
}


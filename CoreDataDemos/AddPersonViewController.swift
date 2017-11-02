//
//  ViewController.swift
//  UserDefaultsDemo
//
//  Created by Tomer Buzaglo on 26/10/2017.
//  Copyright © 2017 Tomer Buzaglo. All rights reserved.
//

import UIKit
import CoreData
class AddPersonViewController: UIViewController {
    
    @IBAction func save(_ sender: UIButton) {
        guard let email = email.text else{ return} //Must have an error for textFields!!!!!!!!!!!
        
        let img = photo.image
        var data: Data?
        
        if let img = img {
            data = UIImageJPEGRepresentation(img, 1)
        }
        
        let person = Person(email: email, image: data)
        DBManager.shared.addPerson(p: person)
        
        NotificationCenter.default.post(name: .newPerson, object: nil)
        dismiss(animated: true)
    }
    
    
    
    @IBOutlet weak var photo: UIImageView!{
        didSet{
            let gesture =
                UITapGestureRecognizer(target: self, action: #selector(pickPhoto))
            photo.addGestureRecognizer(gesture)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(personAdded(notification:)), name: .newPerson, object: nil)
    }
    
    @objc func personAdded(notification:Notification){
        print("person added")
    }
    
    @objc func pickPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    @IBOutlet weak var email: UITextField!

}
extension AddPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        picker.dismiss(animated: true, completion: nil)
        photo.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
    }
}



extension Notification.Name{
    static let newPerson = Notification.Name(rawValue: "DidResetStatistics")
}

//global variables are Thread safe & lazy-loaded in swift.
//fileprivate is a file private access modifier.
fileprivate let instance = UserPrefs()
class UserPrefs {
    //class is simillar to static but can also be overriden
    class var shared: UserPrefs{
        return instance
    }
}


extension UserPrefs{
    var darn:String{
        return ""
    }
    
    static let Boobs = "👚"
}


let boop = UserPrefs.Boobs

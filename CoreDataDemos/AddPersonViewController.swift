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
    
    var person: Person?{
        didSet{
         updateUI()
        }
    }
    
    func updateUI(){
        self.email?.text = person?.email
        if let data = person?.imageData{
            self.photo?.image = UIImage(data: data as Data)
        }
    }
    @IBAction func save(_ sender: UIButton) {
        guard let email = email.text else{ return} //Must have an error for textFields!!!!!!!!!!!
        
        let img = photo.image
        var data: Data?
        
        if let img = img {
            data = UIImageJPEGRepresentation(img, 1)
        }
        
        if person != nil{
            person?.email = email
            person?.imageData = data as NSData?
            DBManager.shared.updatePerson(p: person!)
            NotificationCenter.default.post(name: .editPerson, object: nil, userInfo: ["Person": person!])
        }else{
            person = Person(email: email, image: data)
            DBManager.shared.addPerson(p: person!)
            NotificationCenter.default.post(name: .newPerson, object: nil)
        }
        
        
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
        updateUI()
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
    static let newPerson = Notification.Name(rawValue: "newPerson")
    static let editPerson = Notification.Name(rawValue: "editPerson")
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


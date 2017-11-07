//
//  PersonCollectionViewCell.swift
//  UserDefaultsDemo
//
//  Created by Tomer Buzaglo on 31/10/2017.
//  Copyright © 2017 Tomer Buzaglo. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkedImage: UIImageView!{
        didSet{
            checkedImage.image = #imageLiteral(resourceName: "icons8-unChecked")
            checkedImage.isHidden = true
        }
    }
    var data: Person!
    
    var isEditing = false {
        didSet{
            self.checkedImage.isHidden = !isEditing
        }
    }
    override var isSelected: Bool{
        didSet{
            checkedImage.image = isSelected ? #imageLiteral(resourceName: "icons8-Checked") : #imageLiteral(resourceName: "icons8-unChecked")
        }
    }
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
        /*
        {
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
            image.isUserInteractionEnabled  = true
            
            image.addGestureRecognizer(tap)
            
            //DBManager.shared.context.delete(NSManagedObject())
            //8DBManager.shared.saveContext()
        }
    }
    */
//    @objc func tapped(){
//        let dict = ["Person": self.data]
//       // NotificationCenter.default.post(name: .editTapped, object: nil, userInfo: dict)
//    }
    
    
}
//extension Notification.Name{
//    static let editTapped = Notification.Name.init("editTapped")
//}


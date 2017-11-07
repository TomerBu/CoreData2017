//
//  PeopleCollectionViewController.swift
//  UserDefaultsDemo
//
//  Created by Tomer Buzaglo on 31/10/2017.
//  Copyright © 2017 Tomer Buzaglo. All rights reserved.
//

import UIKit


class PeopleCollectionViewController: UICollectionViewController {
    let reuseIdentifier = "personItem"
    
    
    lazy var people = DBManager.shared.getPepoleOrCrash()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var items = [UIBarButtonItem]()
    
        //self.collectionView.footer
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped(sender:))))
        
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        
        self.setToolbarItems(items, animated: true)
        
       // self.navigationController?.setToolbarHidden(!isEditing, animated: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(personAdded(notification:)), name: .newPerson, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(editPersonTapped(notification:)), name: .editTapped, object: nil)
        //
        
        NotificationCenter.default.addObserver(self, selector: #selector(personEdited(notification:)), name: .editPerson, object: nil)
    }
    
    @objc func trashTapped(sender: UIBarButtonItem){
        print("Trash tapped")
        
        let paths = collectionView?.indexPathsForSelectedItems ?? []
        //enumarate all the selected items and delete them! (DB And collectionView)
        collectionView?.indexPathsForSelectedItems?.map{people[$0.item]}.forEach{
            DBManager.shared.context.delete($0)
            if let idx = people.index(of: $0){people.remove(at: idx)} //Sad :-( no remove object in swift
        }
        DBManager.shared.saveContext()
        
        collectionView?.deleteItems(at: paths)
        
        setEditing(false, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView?.allowsMultipleSelection = isEditing
        
        self.collectionView?.visibleCells.forEach({ (cell) in
            guard let cell = cell as? PersonCollectionViewCell else {return}
            
            cell.isEditing = isEditing
        })
    
        //moved to didSelect - didDeselect
       // self.navigationController?.setToolbarHidden(!isEditing, animated: true)
        if !editing{
            self.navigationController?.setToolbarHidden(true, animated: true)
            collectionView?.indexPathsForSelectedItems?.forEach{collectionView?.deselectItem(at: $0, animated: false)}
            
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PersonCollectionViewCell
        cell.isEditing = isEditing
        
        
        if isEditing{
           //show the trash button
            self.navigationController?.setToolbarHidden(!hasSelectedItems,  animated: true)
        }else{
            let p = people[indexPath.item]
            editPersonTapped(person: p)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.navigationController?.setToolbarHidden(!hasSelectedItems,  animated: true)
    }
    
    var hasSelectedItems:Bool {
        return (collectionView?.indexPathsForSelectedItems?.count ?? 0) > 0
    }
    
    @objc func editPersonTapped(person: Person){
        self.setEditing(false, animated: false)
        guard let target = storyboard?.instantiateViewController(withIdentifier: "AddPersonViewController") as? AddPersonViewController else{return}
        
        target.person = person
        
        present(target, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0 /*bottom*/, 10)
        //layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 10
        //self.view.layoutMargins = UIEdgeInsetsMake(20, 20, 20, 20)
        layout.itemSize.width = self.view.frame.size.width / 2  - 15
        //   self.collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: -100)
    }
    @objc func personAdded(notification:Notification){
        people = DBManager.shared.getPepoleOrCrash()
        let path = IndexPath(item: people.count - 1, section: 0)
        collectionView?.insertItems(at: [path])
        collectionView?.scrollToItem(at: path, at: .centeredVertically, animated: true)
    }
    @objc func personEdited(notification:Notification){
        guard let person = notification.userInfo?["Person"] as? Person else{return}
        people = DBManager.shared.getPepoleOrCrash()
        
        guard let idx = people.index(of: person) else{return}
        
        
        let path = IndexPath(item: idx, section: 0)
        self.collectionView?.reloadItems(at: [path])
    }
    
    @objc func addPerson(){
        self.setEditing(false, animated: false)
        let strID  = String(describing: AddPersonViewController.self)
        
        guard let pvc = storyboard?.instantiateViewController(withIdentifier: strID) else{ return}
        present(pvc, animated: true)
    }
    /*
     
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PersonCollectionViewCell else{fatalError("No Cell")}
        
        let person = people[indexPath.item]
        cell.emailLabel.text = person.email
        
        cell.data = person
        if let data = person.imageData, let img = UIImage(data: data as Data){
            cell.image.image = img
        }
        
        cell.isEditing = isEditing
        // Configure the cell
        cell.backgroundColor = UIColor.green
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
typealias JSON = [String: Any]

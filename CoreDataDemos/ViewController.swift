//
//  ViewController.swift
//  CoreDataDemos
//
//  Created by Tomer Buzaglo on 02/11/2017.
//  Copyright © 2017 Tomer Buzaglo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DBManager.shared.getPepoleOrCrash().forEach { (p) in
            print("Another one!")
        }
        
        let p = Person(entity: Person.entity(), insertInto: DBManager.shared.context)
        p.email = "mdmsdm@gmail.com"
        p.imageData  = nil
        DBManager.shared.addPerson(p: p)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  NoStressParking
//
//  Created by Bhavesh Shah on 11/10/18.
//  Copyright © 2018 Bhavesh Shah. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onTapStart(_ sender: Any) {
        performSegue(withIdentifier: "startSegue", sender: nil)
    }
    
    @IBAction func onTapInstructions(_ sender: Any) {
        performSegue(withIdentifier: "instructionsSegue", sender: nil)

    }
    
}


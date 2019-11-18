//
//  ViewController.swift
//  Unique Identifier Demo
//
//  Created by Pawan kumar on 18/11/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var uniqueIdentifierLabel: UILabel!
    @IBOutlet weak var normalIdentifierLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       let deviceIdUniqueIdentifier = DeviceManager.sharedInstance.deviceUUID()
       print("deviceId Unique Identifier :- \(deviceIdUniqueIdentifier)")
        
        let deviceNormalIdentifier = DeviceManager.sharedInstance.deviceNormalIdentifier()
        print("device Normal Identifier :- \(deviceNormalIdentifier)")
        
        uniqueIdentifierLabel.text = deviceIdUniqueIdentifier
        
        normalIdentifierLabel.text = deviceNormalIdentifier

        /*
         
         First Time Innstall App in Device
         
         deviceId Unique Identifier :- CF4B3053-E0D1-4216-9164-6BC763D6D592  [Same]
         device Normal Identifier :- CF4B3053-E0D1-4216-9164-6BC763D6D592
         
         Delete App In Device And Install Again
         
         deviceId Unique Identifier :- CF4B3053-E0D1-4216-9164-6BC763D6D592 [Same]
         device Normal Identifier :- A20F0632-FA6D-4DD0-AB96-01C47197F153

         
         */
    }
}


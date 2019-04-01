//
//  LaunchViewController.swift
//  ChatBot_IOS
//
//  Created by Darya Isakova on 01/04/2019.
//  Copyright © 2019 Дарья Исакова. All rights reserved.
//

import UIKit
import Kommunicate

class LaunchViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func OnLaunchChat(_ sender: Any) {
        Kommunicate.createAndShowConversation(from: self, completion: {
            error in
            if error != nil {
                print("Error while launching")
            }
        })
    }
    
    @IBAction func OnExit(_ sender: Any) {
        Kommunicate.logoutUser()
        self.dismiss(animated: false, completion: nil)
    }
}

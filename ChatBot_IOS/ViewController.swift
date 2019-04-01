//
//  ViewController.swift
//  ChatBot_IOS
//
//  Created by Darya Isakova on 01/04/2019.
//  Copyright © 2019 Дарья Исакова. All rights reserved.
//

import UIKit
import Kommunicate

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func OnGetStarted(_ sender: Any) {
        let applicationId = AppDelegate.appId
        setupApplicationKey(applicationId)
        
        let kmUser = userWithUserId(Kommunicate.randomId(), andApplicationId: applicationId)
        registerUser(kmUser)
        //launchConversation()
    }
    
    private func setupApplicationKey(_ applicationId: String) {
        guard !applicationId.isEmpty else {
            fatalError("Please pass your AppId in the AppDelegate file.")
        }
        Kommunicate.setup(applicationId: applicationId)
    }
    
    private func userWithUserId(
        _ userId: String,
        andApplicationId applicationId: String) -> KMUser {
        let kmUser = KMUser()
        kmUser.userId = userId
        kmUser.applicationId = applicationId
        return kmUser
    }
    
    private func registerUser(_ kmUser: KMUser) {
        activityIndicator.startAnimating()
        Kommunicate.registerUser(kmUser, completion: {
            response, error in
            self.activityIndicator.stopAnimating()
            guard error == nil else {
                print("[REGISTRATION] Kommunicate user registration error: %@", error.debugDescription)
                return
            }
            print("User registration was successful: %@ \(String(describing: response?.isRegisteredSuccessfully()))")
            if let viewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "NavViewController") as? UINavigationController {
                self.present(viewController, animated:true, completion: nil)
            }
        })
    }
    
    private func launchConversation() {
        Kommunicate.createAndShowConversation(from: self, completion: {
            error in
            if error != nil {
                print("Error while launching")
            }
        })
    }
    
}


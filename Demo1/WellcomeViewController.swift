//
//  WellcomeViewController.swift
//  Demo1
//
//  Created by PhatNguyen on 11/15/17.
//  Copyright © 2017 Nguyen tan phat. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SVProgressHUD
import Firebase

class WellcomeViewController: UIViewController {
// object
    
    @IBOutlet weak var noteLanbel: UILabel!
    var dict : [String: AnyObject]!
    
    // view
    override func viewDidLoad() {
        super.viewDidLoad()
        if let accessToken = FBSDKAccessToken.current(){
            
        }
    }
    // auto log in
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            
        }
    }
    
// button
   
    @IBAction func loginButton(_ sender: Any) {
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
    }
    // login facebook
    
    @IBAction func btnLoginFaceBook(_ sender: Any){
        loginFacebook()
    }
    let fbloginmanager = FBSDKLoginManager ()
    
// function
    
    // function login facebook
    
    func loginFacebook(){
        fbloginmanager.logIn(withReadPermissions: ["email"], from: self){
            (result, error) in
            if error !=  nil {
                print("dang nhap khong thanh cong")
                SVProgressHUD.showError(withStatus: (error!.localizedDescription) )
                
            } else {
                
                print("dang nhap thanh cong")
                SVProgressHUD.showSuccess(withStatus: "SuccessFull")
                self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            }
        }
    }
    func getFBUserData() {
        if ((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,picture.type(large), email"]).start(completionHandler: { (connection, result, error) in
                
                if(error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    
                }
            })
            
        }
    }
// the end
}

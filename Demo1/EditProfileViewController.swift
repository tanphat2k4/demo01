//
//  EditProfileViewController.swift
//  Demo1
//
//  Created by PhatNguyen on 11/12/17.
//  Copyright © 2017 Nguyen tan phat. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SDWebImage

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
// object
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
// view
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        loadProfileData()
    }
    // tat keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
// button
    @IBAction func getPhotoFromLibrary(_ sender: Any) {
     let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        if passwordTextField.text != repasswordTextField.text! {
             SVProgressHUD.showError(withStatus: "Password not match" )
            
        }else{
            updateUserProfile()
            
        }
        
        
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
        
    }
    // function
    
    func updateUserProfile() {
        //check to see if the user is logged in
        if let userID = Auth.auth().currentUser?.uid{
            //create an access point for the Firebase storage
            let storageItem = storageRef.child("profile_images").child(userID)
            //get the image uploaded from photo library
            guard let image = profileImageView.image else {return}
            if let newImage = UIImagePNGRepresentation(image){
                //upload to firebase storage
                storageItem.putData(newImage, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        if let profilePhotoURL = url?.absoluteString{
                            guard let newUserName  = self.usernameTextField.text else {return}
                            guard let newEmail = self.emailTextField.text else {return}
                            guard let newPassword = self.passwordTextField.text else {return}
                            guard let newName = self.nameTextField.text else {return}
                            
                            let newValuesForProfile =
                                ["photo": profilePhotoURL,
                                 "username": newUserName,
                                 "name": newName,
                                 "password": newPassword]
                            
                            //update the firebase database for that user
                            self.databaseRef.child("profile").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                                print("Profile Successfully Update")
                            })
                            
                        }
                    })
                })
                
            }
        }
        
    }
    
    func loadProfileData() {
        if let userID = Auth.auth().currentUser?.uid{
            databaseRef.child("profile").child(userID).observe(.value, with: { (snapshot) in
                let values = snapshot.value as? NSDictionary
                if let profileImageURL = values?["Photo"] as? String{
                    self.profileImageView.sd_setImage(with: URL(string: profileImageURL), placeholderImage:UIImage(named:""))
                }
                self.usernameTextField.text = values? ["username"] as? String
                self.nameTextField.text = values? ["name"] as? String
                self.emailTextField.text = values? ["email"] as? String
                self.passwordTextField.text = values? ["password"] as? String
                
                
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }


// the End
}

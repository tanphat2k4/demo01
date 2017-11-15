//
//  FeedVC.swift
//  socialapp
//
//  Created by Kasey Schlaudt on 3/7/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class HomeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postBtn: UIButton!
    
    var posts = [Post]()
    
    var post: Post!
    
    var imagePicker: UIImagePickerController!
    
    var imageSelected = false
    
    var selectedImage: UIImage!
    
    var userImage: String!
    
    var userName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        
        imagePicker.delegate = self
        
        Database.database().reference().child("posts").observe(.value, with: {(snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                self.posts.removeAll()
                
                for data in snapshot {
                    
                    print(data)
                    
                    if let postDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let post = Post(postKey: key, postData: postDict)
                        
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            cell.configCell(post: post)
            
            return cell
            
        } else {
            
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            selectedImage = image
            
            imageSelected = true
            
        } else {
            
            print("A valid image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        guard imageSelected == true else {
            
            print("An image must be selected")
            
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(selectedImage, 0.2) {
            
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jpeg"
            
            Storage.storage().reference().child("post-pics").child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    
                    print("image did not save to firebase storage")
                    
                } else {
                    
                    print("uploded to firebase storage")
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    
                    if let url = downloadURL {
                        
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            let username = data["username"]
            
            let userImg = data["userImg"]
            
            let post: Dictionary<String, AnyObject> = [
                "username": username as AnyObject,
                "userImg": userImg as AnyObject,
                "imageUrl": imgUrl as AnyObject,
                "likes": 0 as AnyObject
            ]
            
            let firebasePost = Database.database().reference().child("posts").childByAutoId()
            
            firebasePost.setValue(post)
            
            self.imageSelected = false
            
            self.tableView.reloadData()
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
    }
    
  
    @IBAction func signOut(_ sender: Any) {
        
        // tu dong dang nhap va log out
        do{
            try Auth.auth().signOut()
            
        } catch let logoutError {
            print(logoutError)
        }
        
        // back to login
        let stotyboard = UIStoryboard(name:"Start", bundle: nil)
        
        let signInVC = stotyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
        
    }
    
   
    
  
 
// the end
    
}

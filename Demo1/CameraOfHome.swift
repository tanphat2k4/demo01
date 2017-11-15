//
//  CameraOfHome.swift
//  Demo1
//
//  Created by PhatNguyen on 11/14/17.
//  Copyright © 2017 Nguyen tan phat. All rights reserved.
//

import UIKit
import Firebase

class CameraOfHome: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
// object
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var captionTexview: UILabel!
    let picker = UIImagePickerController()
    
// View
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
// button
    
    @IBAction func sharePhoto(_ sender: Any) {
        
    }
    @IBAction func cacelUpload(_ sender: Any) {

    }
    
    
    @IBAction func pickPhotoGallrey(_ sender: Any) {
        getPhotofromLibary()
        
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        takeNewPhoto()
        
    }
    
// function
    func getPhotofromLibary() {
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
        
        
    }
    // camera for new photo
    func takeNewPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
        }else{
            noCameraAvailable()
        }
    }
    func noCameraAvailable() {
        let alertVC = UIAlertController(title: "No camera Available", message: "Can not find a camera on this device", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(ok)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        postImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
// the end
   
}

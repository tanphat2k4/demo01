
import UIKit
import FirebaseStorage
import Firebase

import SVProgressHUD

class CameraViewController: UIViewController {

    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var removeButton: UIBarButtonItem!
    @IBOutlet weak var cationTextView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    
    var selectedImage: UIImage?
// view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // gan Imageview thanh UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
    }
    // tat keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // config share button
    override func viewWillAppear(_ animated: Bool) {
        handelPost()
    }
// button clicked
   
    @IBAction func shareButton_Touchupinside(_ sender: Any) {
        view.endEditing(true)
        SVProgressHUD.showProgress(0.1, status: "Loading...")
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1){
            let photoIdString = NSUUID().uuidString
            print(photoIdString)
            let storageRef = Storage.storage().reference(forURL: "gs://home-e3369.appspot.com").child("posts").child(photoIdString)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: (error!.localizedDescription))
                    return
                }
                let photoUrl = metadata?.downloadURLs
                self.sendDataToDatabase(photoUrl:photoIdString)
                
                
            })
        }else{
            SVProgressHUD.showError(withStatus:"Profile Image can not be Empty")
        }
    }
    
    @IBAction func remove_Touchupinside(_ sender: Any) {
        clean()
        handelPost()
    }
    
// Function
    func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController,animated: true, completion: nil)
        
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        
        let newPostsReference = postsReference.child(newPostId)
        newPostsReference.setValue(["photoUrl": photoUrl, "caption": cationTextView.text!], withCompletionBlock: {
            (error,ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
            }
            SVProgressHUD.showSuccess(withStatus: "Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
            
        })
    }
    func handelPost() {
        if selectedImage != nil{
            self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
            
        }else{
            self.shareButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
    }
    func clean() {
        self.cationTextView.text = ""
        self.photo.image = UIImage(named:"placeholder_image")
        self.selectedImage = nil    }
// The End
    
}
extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            photo.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

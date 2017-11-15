
import UIKit
import Firebase

class ProfileViewController: UIViewController {
// object
    @IBOutlet weak var userNameText: UILabel!
    
    @IBOutlet weak var diplayNameText: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var databaseRef: DatabaseReference!
    
    // view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid{
            databaseRef.child("profile").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let dictionary = snapshot.value as? NSDictionary
                let username = dictionary? ["username"] as? String ?? "username"
                if let profileImageURL = dictionary?["photo"] as? String{
                    let url = URL(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            self.profileImageView.image = UIImage(data:data!)
                        }
                    }).resume()
                }
                self.userNameText.text = username
                self.diplayNameText.text = username
            }){(error) in
                print(error.localizedDescription)
                return
                
            }
        }
        
    }
// button
    
// funtion

   
// the end
}

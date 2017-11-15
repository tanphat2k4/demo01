
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SVProgressHUD
import Firebase

class SignInViewController: UIViewController {
   
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tao khung ghach duoi
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.textColor = UIColor.black
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!)
        //bien email
        let bottomLayeremail = CALayer()
        
        
        bottomLayeremail.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayeremail)
        
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.textColor = UIColor.black
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!)
        passwordTextField.isSecureTextEntry = true
        
        
        //bien password
        
        let bottomLayerPassword = CALayer()
        //bottomLayerPassword .frame = CGRect(x:0,y:29,width:900,height:0.5)
        bottomLayerPassword .backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
       
        // auto sigin
//        if Auth.auth().currentUser != nil {
//            // hen gio log out
//            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
//               self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
//
//            })
//
//        }
    }
    // tat keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
    }
    // auto log in
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            
        }
    }
    
  
    
    // login
    
    @IBAction func loginBtn(_ sender: Any) {
        view.endEditing(true)
        
        SVProgressHUD.showProgress(0.2, status: "Loading...")
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
         
                SVProgressHUD.showError(withStatus: (error!.localizedDescription) )
               
                return
            }else{
                 //  ve trang Home
                self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
                print("succesful")
                SVProgressHUD.showSuccess(withStatus: "Login succesful")
               
                }
        }
    }
    
  // the end
}






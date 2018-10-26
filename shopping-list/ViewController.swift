//
//  ViewController.swift
//  shopping-list
//
//  Created by mp001 on 10/27/18.
//  Copyright © 2018 mp001. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class ViewController: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var bdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        loginButton.readPermissions = ["email", "user_gender", "user_birthday"]
        loginButton.delegate = self as! FBSDKLoginButtonDelegate
        self.view.addSubview(loginButton)
        
        hideElements(hide: true)
        
        if FBSDKAccessToken.current() != nil {
            getUserInfo()
        }
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error == nil {
            getUserInfo()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        hideElements(hide: true)
    }
    
    func getUserInfo() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,email,gender,birthday"]).start(completionHandler: { (conn, result, err) in
            
            if err == nil {
                let user = result as! [String: Any]
                self.nameLabel.text = user["name"] as? String
                self.emailLabel.text = user["email"] as? String
                self.bdLabel.text = user["birthday"] as? String
                self.genderLabel.text = user["gender"] as? String
                
                let id = user["id"] as? String
                
                let data = try? Data.init(contentsOf: URL(string: "https://graph.facebook.com/\(id!)/picture?type=large")!)
                self.profileImageView.image = UIImage(data: data!)
                self.hideElements(hide: false)
            }
        })
    }
    
    func hideElements(hide: Bool) {
        nameLabel.isHidden = hide
        emailLabel.isHidden = hide
        bdLabel.isHidden = hide
        genderLabel.isHidden = hide
        profileImageView.isHidden = hide
    }
    


}


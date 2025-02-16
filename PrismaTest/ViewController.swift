//
//  ViewController.swift
//  PrismaTest
//
//  Created by saeed shaikh on 06/01/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Clear the text fields when the view is about to appear
        username.text = ""
        password.text = ""
    
    }
    
    @objc func dismissKeyboard() {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard validateInputs() else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let countryList = storyboard.instantiateViewController(withIdentifier: "CountryList") as? CountryList {
            navigationController?.pushViewController(countryList, animated: true)
        }
    }
    
    private func validateInputs() -> Bool {
        guard let usernameText = username.text, !usernameText.isEmpty,
              let passwordText = password.text, !passwordText.isEmpty else {
            showAlert(title: "Error", message: "Please enter both username and password")
            return false
        }
        
        if usernameText.trimmingCharacters(in: .whitespaces).isEmpty {
            showAlert(title: "Error", message: "Username cannot be just white space")
            return false
        }
        
        if passwordText.trimmingCharacters(in: .whitespaces).isEmpty {
            showAlert(title: "Error", message: "Password cannot be just white space")
            return false
        }
        
        if passwordText.count <= 4 {
            showAlert(title: "Error", message: "Password must be longer than 4 characters")
            return false
        }
        
        return true
    }
    

}

// MARK: - Show Alert Utility for Global Access
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

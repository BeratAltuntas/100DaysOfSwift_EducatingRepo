    //
    //  ViewController.swift
    //  Project28
    //
    //  Created by BERAT ALTUNTAŞ on 2.04.2022.
    //
import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem?.isEnabled = false
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    
    @IBAction func authenticate_TUI(_ sender: Any) {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success{
                        self?.navigationItem.rightBarButtonItem?.isEnabled = true
                        self?.unlockSecretMessage()
                    }else{
                            //error
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac,animated: true)
                    }
                }
            }
        }else{
            
            
                // no biometry
            let ac = UIAlertController(title: "Write your password", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default,handler: {[weak ac,weak self] _ in
                guard let text = ac?.textFields?[0].text else{return}
                self?.checkPassword(text)
            }))
            present(ac, animated: true)
        }
        
    }
    
    func checkPassword(_ text: String){
        
        let password = KeychainWrapper.standard.string(forKey: "LoginPassword") ?? ""
        if password == text{
            unlockSecretMessage()
        }else if password == "" {
            
            let ac = UIAlertController(title: "Create Password", message: "You need to create a password", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default,handler: { [weak ac] _ in
                guard let createPasswordText = ac?.textFields?[0].text else{return}
                KeychainWrapper.standard.set(createPasswordText, forKey: "LoginPassword")
            }))
            present(ac, animated: true)
        }else{
            
            let ac = UIAlertController(title: "Password Wrong!!", message: "Your password is wrong try again!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            secret.contentInset = .zero
        }else{
            
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height  - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage(){
        secret.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = true
        title = "Secret Stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage(){
        guard secret.isHidden == false else{return}
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        title = "Nothing to see here"
    }
}


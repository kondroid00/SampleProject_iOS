//
//  SignUpViewController.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/10.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    fileprivate var editingTextField:UITextField?
    
    private var name: String = ""
    
    private let vm = SignUpViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.rx.text.subscribe(onNext: {[weak self](value) in
            guard let weakSelf = self, let value = value else {
                return
            }
            
            weakSelf.name = value.trimmingCharacters(in: .whitespacesAndNewlines)
        }).addDisposableTo(disposeBag)

        signUpButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.signUp()
        }).addDisposableTo(disposeBag)
        
        nameTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SignUpViewController.handleKeyboardWillShowNotification(_:)),
                                       name: NSNotification.Name.UIKeyboardWillShow,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(SignUpViewController.handleKeyboardWillHideNotification(_:)),
                                       name: NSNotification.Name.UIKeyboardWillHide,
                                       object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func signUp() {
        if 0 < name.characters.count && name.characters.count <= 12 {
            vm.signUp(
                name: name,
                onSuccess: {[weak self] in
                
                },
                onFailed: {[weak self](error) in
                    
                }
            )
            
        } else {
            showErrorAlert(message: "1文字以上12文字以下で入力してください")
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if editingTextField != nil {
            return false
        }
        editingTextField = textField
        return true
    }
    
    func handleKeyboardWillShowNotification(_ notification: Notification) {

    }
    
    func handleKeyboardWillHideNotification(_ notification: Notification) {
        self.editingTextField = nil
    }

}

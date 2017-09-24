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

class SignUpViewController: BaseTFViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    private let vm = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.rx.text
            .subscribe(onNext: {[weak self](value) in
                guard let weakSelf = self, let value = value else {
                    return
                }
                weakSelf.vm.name = value.trimmingCharacters(in: .whitespacesAndNewlines)
            }).addDisposableTo(disposeBag)

        signUpButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.signUp()
        }).addDisposableTo(disposeBag)
        
        //Validation
        let nameValid: Observable<String?> = nameTextField.rx.text.orEmpty
            .map { text -> String? in Validation.textLength(text: text, min: 1, max: 20)}
            .shareReplay(1)
        nameValid
            .bind(to: nameValidationLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        let signUpButtonValid = nameValid.map { name in
            return name == nil
        }.shareReplay(1)
        signUpButtonValid.subscribe(onNext: {[weak self](value) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.signUpButton.isEnabled = value
        })
        
        nameTextField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func signUp() {
        if let name = vm.name, 0 < name.characters.count && name.characters.count <= 12 {
            showProgress(true)
            vm.signUp(
                onSuccess: {[weak self] in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.goToHome()
                    weakSelf.showProgress(false)
                },
                onFailed: {[weak self](error) in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.showAlert(message: "サインアップに失敗しました。",
                                            title: "失敗")
                    weakSelf.showProgress(false)
                }
            )
            
        } else {
            showAlert(message: "1文字以上12文字以下で入力してください")
        }
    }
    
}

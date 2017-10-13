//
//  AddRoomViewController.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/20.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddRoomViewController: BaseTFViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var themeTextField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var themeValidationLabel: UILabel!
    
    @IBOutlet weak var createButton: UIButton!
    
    fileprivate let vm = AddRoomViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.rx.text.subscribe(onNext: {[weak self](value) in
            guard let weakSelf = self, let value = value else {
                return
            }
            weakSelf.vm.name.onNext(value.trimmingCharacters(in: .whitespacesAndNewlines))
        }).disposed(by: disposeBag)
        
        themeTextField.rx.text.subscribe(onNext: {[weak self](value) in
            guard let weakSelf = self, let value = value else {
                return
            }
            weakSelf.vm.theme.onNext(value.trimmingCharacters(in: .whitespacesAndNewlines))
        }).disposed(by: disposeBag)
        
        createButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.createRoom()
        }).disposed(by: disposeBag)

        //Validation
        let nameValid: Observable<String?> = nameTextField.rx.text.orEmpty
            .map { text -> String? in Validation.textLength(text: text, min: 1, max: 20)}
            .shareReplay(1)
        nameValid
            .bind(to: nameValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let themeValid: Observable<String?> = themeTextField.rx.text.orEmpty
            .map { text -> String? in Validation.textLength(text: text, min: 1, max: 20)}
            .shareReplay(1)
        themeValid
            .bind(to: themeValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let createButtonValid = Observable<Bool>.combineLatest(nameValid, themeValid) { name, theme in
            return name == nil && theme == nil
        }.shareReplay(1)
        createButtonValid.subscribe(onNext: {[weak self](value) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.createButton.isEnabled = value
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createRoom() {
        showProgress(true)
        vm.createRoom(
            onSuccess: {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.showAlert(message: "ルーム作成に成功しました。",
                                   title: "ルーム作成")
                weakSelf.showProgress(false)
            },
            onFailed: {[weak self](error) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.showAlert(message: "ルーム作成に失敗しました。",
                                        title: "失敗")
                weakSelf.showProgress(false)
            }
        )
    }
    
}

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
    
    @IBOutlet weak var createButton: UIButton!
    
    fileprivate let vm = AddRoomViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.rx.text.subscribe(onNext: {[weak self](value) in
            guard let weakSelf = self, let value = value else {
                return
            }
            weakSelf.vm.name.onNext(value.trimmingCharacters(in: .whitespacesAndNewlines))
        }).addDisposableTo(disposeBag)
        
        themeTextField.rx.text.subscribe(onNext: {[weak self](value) in
            guard let weakSelf = self, let value = value else {
                return
            }
            weakSelf.vm.theme.onNext(value.trimmingCharacters(in: .whitespacesAndNewlines))
        }).addDisposableTo(disposeBag)
        
        createButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.createRoom()
        }).addDisposableTo(disposeBag)

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
            },
            onFailed: {[weak self](error) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.showAlert(message: "ルーム作成に失敗しました。",
                                        title: "失敗")
            },
            onCompleted: {[weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.showProgress(false)
        })
    }
    
}

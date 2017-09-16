//
//  TopViewController.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/03.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopViewController: BaseViewController {
    
    @IBOutlet weak var buttonStart: UIButton!
    
    
    let vm = TopViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if AccountManager.instance.hasUserId() {
            buttonStart.isHidden = true
            login()
        }
        
        buttonStart.rx.tap.subscribe(onNext: {[weak self] in
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.signUp()
            
        }).addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func signUp() {
        guard let nc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpNavigationController") as? UINavigationController else{
            return
        }
        self.show(nc, sender: nil)
    }
    
    private func login() {
        showProgress(true)
        vm.login(
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
                weakSelf.showErrorAlert(message: "ログインに失敗しました。",
                                        title: "ログイン失敗",
                                        button1Title: "リトライ",
                                        handler1: {[weak self](action) in
                                            guard let weakSelf = self else {
                                                return
                                            }
                                            weakSelf.login()
                })
                weakSelf.showProgress(false)
            }
        )
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

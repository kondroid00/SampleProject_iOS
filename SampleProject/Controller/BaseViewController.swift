//
//  BaseViewController.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/03.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class BaseViewController: UIViewController {

    let progressHUD = MBProgressHUD.init()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressHUD.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        self.view.addSubview(progressHUD)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.showProgress(false)
    }

    func showAlert(message: String = "通信に失敗しました。",
                   title: String = "エラー",
                   button1Title: String = "OK",
                   handler1: ((UIAlertAction) -> Swift.Void)? = nil,
                   button2Title: String = "キャンセル",
                   handler2: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let button1 = UIAlertAction(title: button1Title, style: UIAlertActionStyle.default, handler: handler1)
        alert.addAction(button1)
        if handler2 != nil {
            let button2 = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler2)
            alert.addAction(button2)
        }
        
        present(alert, animated: true)
    }

    func goToHome() {
        guard let nc = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController else{
            return
        }
        self.show(nc, sender: nil)
    }
    
    func showProgress(_ show: Bool) {
        if(show) {
            progressHUD.show(animated: true)
        }else{
            progressHUD.hide(animated: false)
        }
    }
}

class BaseTFViewController: BaseViewController, UITextFieldDelegate {

    private var editingTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
}

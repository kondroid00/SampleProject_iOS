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
            let button2 = UIAlertAction(title: button2Title, style: UIAlertActionStyle.default, handler: handler2)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
        })
    }
    
    func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            self.view.transform = CGAffineTransform.identity
        })
    }
}

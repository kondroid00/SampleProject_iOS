//
//  BaseViewController.swift
//  SampleProject
//
//  Created by 近藤浩市郎 on 2017/09/03.
//  Copyright © 2017 Koichiro Kondo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showErrorAlert(message: String = "通信に失敗しました。", title: String = "Error") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let acceptButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(acceptButton)
        present(alert, animated: true)
    }

}

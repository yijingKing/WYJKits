//
//  MyViewController.swift
//  WYJKitsDemo
//
//  Created by 祎 on 2020/8/28.
//  Copyright © 2020 祎. All rights reserved.
//

import UIKit

class MyViewController: WYJBaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WYJLocation.shared.startPositioning() { (pl) in
            WYJLog(pl)
        } error: { (err) in
            
        }
    }
    
    @objc func injected() {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barStyle = .lightContent
        // Do any additional setup after loading the view.
//        addTableView()
//        mainTableView?.cellForRowAtIndexPath({ (tab, inde) -> UITableViewCell in
//            return UITableViewCell()
//            }).numberRows(100)
//        mainTableView?.heightRows(50)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        WYJHUD.loading("oooolplpl")
        var para = [String: Any]()
        para["username"] = "18250808695"
        para["password"] = "123456"
        para["rememberMe"] = "false"
        WYJRequest().post(HomeAPI.login, para) { (model: MyInfo_Data) in

            WYJLog(model.id)
            
        } error: { (err) in
            WYJLog(err)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

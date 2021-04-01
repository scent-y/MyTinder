//
//  ListViewController.swift
//  Tinder
//
//  Created by scent-y on 2019/01/09.
//  Copyright © 2019 scent-y. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource {
    
    var likedName = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(likedName)
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = likedName[indexPath.row] + " にlikeしました♡" // indexPath.row : 描画しているセルの順番
        return cell
    }

}

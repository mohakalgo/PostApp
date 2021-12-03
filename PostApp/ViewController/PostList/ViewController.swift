//
//  ViewController.swift
//  PostApp
//
//  Created by Aglowid IT Solutions on 03/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var arrForPosts : [PostListModelElement] = []
    var arrForPostMain : [PostListModelElement] = []
    @IBOutlet weak var txtSearch: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.registerNib("PostTCell")
        self.getPosts()
        // Do any additional setup after loading the view.
    }
    
    func getPosts() {
        ApiCalls.getPosts { isSucces, objModel in
            self.arrForPosts = objModel ?? []
            self.arrForPostMain = objModel ?? []
            self.tblView.reloadData()
        }
    }

    @IBAction func textChanged(_ sender: Any) {
        if txtSearch.text != "" {
            self.arrForPosts = self.arrForPostMain.filter({ $0.title.contains(txtSearch.text ?? "")})
        } else {
            self.arrForPosts = self.arrForPostMain
        }
        self.tblView.reloadData()
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "PostTCell") as! PostTCell
        cell.obj = arrForPosts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForPosts.count
    }
}



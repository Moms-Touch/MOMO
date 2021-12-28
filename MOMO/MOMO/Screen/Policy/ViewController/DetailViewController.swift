//
//  DetailViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/22.
//

import UIKit

class DetailViewController: UIViewController {
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hostAssocitationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var policyImageView: UIImageView!
    @IBOutlet weak var policyContentView: UIView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    
    var content: Any?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

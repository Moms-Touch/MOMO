//
//  PolicyMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit

class PolicyMainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchFieldBackView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet var filterButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpSearchFieldBackView()
        setUpFilterButtons()
    }
    
    private func setUpTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(PolicyTableViewCell.nib, forCellReuseIdentifier: PolicyTableViewCell.identifier)
    }
    
    private func setUpSearchFieldBackView() {
        searchFieldBackView.layer.cornerRadius = searchFieldBackView.frame.height / 2
    }
    
    private func setUpFilterButtons() {
        
        filterButtons.forEach {
            $0.layer.borderColor = ThemeColor.pink5.color.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.setTitleColor(.white, for: .selected)
            $0.tintColor = ThemeColor.pink3.color
        }
    }
    @IBAction func showBookmark(_ sender: UIButton) {
        
        print(#function)
    }
    
    @IBAction func filterResults(_ sender: UIButton) {
        
        deselectAllFilterButton()
        
        sender.isSelected = true
        
        sender.backgroundColor = ThemeColor.pink2.color
        //그에 맞는 정책 필터를 표현
    }
    
    private func deselectAllFilterButton() {
        filterButtons.forEach {
            $0.isSelected = false
            $0.backgroundColor = .white
        }
    }
}
extension PolicyMainViewController: StoryboardInstantiable {}

extension PolicyMainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PolicyTableViewCell.identifier, for: indexPath) as? PolicyTableViewCell else { return UITableViewCell() }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
}

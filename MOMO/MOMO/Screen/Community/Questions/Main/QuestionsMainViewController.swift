//
//  QuestionMainViewController.swift
//  MOMO
//
//  Created by Woochan Park on 2021/11/28.
//

import UIKit

class QuestionsMainViewController: UIViewController, StoryboardInstantiable {
  
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
    
    tableView.register(QuestionTableViewCell.nib, forCellReuseIdentifier: QuestionTableViewCell.identifier)
  }
  
  private func setUpSearchFieldBackView() {
    searchFieldBackView.layer.cornerRadius = searchFieldBackView.frame.height / 2
  }
  
  private func setUpFilterButtons() {
    
    filterButtons.forEach {
      
      $0.layer.borderColor = Asset.Colors.pink5.color.cgColor
      $0.layer.borderWidth = 1
      $0.layer.cornerRadius = $0.frame.height / 2
      
      $0.setTitleColor(.white, for: .selected)
      $0.tintColor = Asset.Colors.pink3.color
    }
  }
  
  @IBAction func showBookmark(_ sender: UIButton) {
    
    print(#function)
  }
  
  @IBAction func filterResults(_ sender: UIButton) {
    
    deselectAllFilterButton()
    
    sender.isSelected = true
    sender.backgroundColor = Asset.Colors.pink2.color
  }
  
  /// 모든 필터 버튼의 선택을 해제한다.
  private func deselectAllFilterButton() {

    filterButtons.forEach {
      $0.isSelected = false
      $0.backgroundColor = .white
    }
  }
}

extension QuestionsMainViewController: UITextFieldDelegate {
  
}

extension QuestionsMainViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 30
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as? QuestionTableViewCell else { return UITableViewCell() }
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 100
  }
  
}


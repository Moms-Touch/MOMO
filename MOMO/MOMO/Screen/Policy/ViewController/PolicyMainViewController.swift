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
  @IBOutlet weak var locationTextField: UITextField!
  
  var datasource: [PolicyData] = []
  lazy var networkManager = NetworkManager()
  
  private var gapBWTCell:CGFloat = 10;
  lazy var customNavigationDelegate = CustomNavigationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTableView()
    setUpSearchFieldBackView()
    setUpFilterButtons()
    getPolicyData(page: 1)
  }
  
  private func getPolicyData(page: Int) {
    guard let token = UserManager.shared.token else {return}
    networkManager.request(apiModel: GetApi.policyGet(token: token, keyword: searchField.text, location: nil, category: nil, page: page)) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: [PolicyData].self) { [weak self] (body) in
          guard let self = self else {return}
          DispatchQueue.main.async {
            self.datasource = body
            self.tableView.reloadData()
          }
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  
  private func getPolicyData(category: String, page: Int) {
    guard let token = UserManager.shared.token else {return}
    networkManager.request(apiModel: GetApi.policyGet(token: token, keyword: searchField.text, location: locationTextField.text, category: Filter.getCase(korean: category), page: page)) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: [PolicyData].self) { [weak self] (body) in
          guard let self = self else {return}
          DispatchQueue.main.async {
            self.datasource = body
            self.tableView.reloadData()
          }
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func setUpTableView() {
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(ListTableViewCell.self)
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
    // 1차스프린트
    guard let bookmarkVC = BookmarkListViewController.loadFromStoryboard() as? BookmarkListViewController else {return}
    bookmarkVC.segmentedControl.selectedSegmentIndex = 1
    customNavigationDelegate.direction = .right
    bookmarkVC.transitioningDelegate = customNavigationDelegate
    bookmarkVC.modalPresentationStyle = .custom
    present(bookmarkVC, animated: true, completion: nil)
  }
  
  @IBAction func filterResults(_ sender: UIButton) {
    
    deselectAllFilterButton()
    sender.isSelected = true
    
    sender.backgroundColor = ThemeColor.pink2.color
    getPolicyData(category: sender.currentTitle!, page: 1)
  }
  
  private func deselectAllFilterButton() {
    filterButtons.forEach {
      $0.isSelected = false
      $0.backgroundColor = .white
    }
  }
}
extension PolicyMainViewController: StoryboardInstantiable {}

extension PolicyMainViewController: TableViewGappable {
  var headerHeight: CGFloat {
      return gapBWTCell
  }
  
  var footerHeight: CGFloat {
      return gapBWTCell
  }
}

extension PolicyMainViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return datasource.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else { return ListTableViewCell() }
    
    cell.getSimpleData(data: datasource[indexPath.section])
    
    return cell
  }
}

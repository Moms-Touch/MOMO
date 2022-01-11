//
//  PolicyMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import Toast

class PolicyMainViewController: ViewController, UITextFieldDelegate {
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.allowsSelection = true
    }
  }
  @IBOutlet weak var searchFieldBackView: UIView!
  @IBOutlet weak var searchField: UITextField! {
    didSet {
      searchField.delegate = self
      searchField.setUpFontStyle()
    }
  }
  @IBOutlet var filterButtons: [UIButton]!
  @IBOutlet weak var locationTextField: UITextField! {
    didSet {
      locationTextField.text = "전국"
      locationTextField.inputView = locationPickerView
      locationTextField.tintColor = UIColor.clear
      locationTextField.setUpFontStyle()
      locationTextField.delegate = self
    }
  }
  
  private var datasource: [PolicyData] = []
  private let cityName = ["전국", "서울", "대전", "대구", "부산", "광주", "울산", "인천"]
  lazy var networkManager = NetworkManager()
  private var locationPickerView = UIPickerView() {
    didSet {
      locationPickerView.selectRow(0, inComponent: 0, animated: true)
    }
  }
  
  private var gapBWTCell:CGFloat = 10;
  lazy var customNavigationDelegate = CustomNavigationManager()
  private var fetchMore = true
  private var page = 1 // page 1번이 시작
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTableView()
    setUpSearchFieldBackView()
    setUpFilterButtons()
    locationTextField.addSubview(downButton)
    locationPickerView.delegate = self
    locationPickerView.dataSource = self
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    hideKeyboard()
    addToolbar()
    getPolicyData(page: 1)
  }
  
  private func setUpTableView() {
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.register(ListTableViewCell.self)
  }
  
  private lazy var downButton: UIButton = {
    let button = UIButton(type: .custom)
    let spacing: CGFloat = 0
    button.setImage(UIImage(named: "Polygon 3"), for: .normal)
    button.setImage(UIImage(named: "Polygon 3"), for: .selected)
    button.setImage(UIImage(named: "Polygon 3"), for: .focused)
    button.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
    button.contentEdgeInsets = UIEdgeInsets(top: 5, left: spacing, bottom: 5, right: spacing)
    button.isAccessibilityElement = true
    button.accessibilityLabel = ""
    button.accessibilityValue = "지역선택 버튼"
    button.addTarget(self, action: #selector(dipTapDownButton(_:)), for: .touchUpInside)
    locationTextField.rightView = button
    locationTextField.rightViewMode = .always
    return button
  }()
  
  @objc private func setUpSearchFieldBackView() {
    searchFieldBackView.layer.cornerRadius = searchFieldBackView.frame.height / 2
  }
  
  private func setUpFilterButtons() {
    
    filterButtons.forEach {
      $0.layer.borderColor = ThemeColor.pink5.color.cgColor
      $0.layer.borderWidth = 1
      $0.layer.cornerRadius = $0.frame.height / 2
      $0.setTitleColor(.white, for: .selected)
      $0.tintColor = ThemeColor.pink3.color
      $0.titleLabel?.font = UIFont.customFont(forTextStyle: .caption2)
    }
  }
  
  @objc private func dipTapDownButton(_ sender: UIButton){
    locationTextField.becomeFirstResponder()
  }
  
  @IBAction func showBookmark(_ sender: UIButton) {
    // 1차스프린트
    guard let bookmarkVC = BookmarkListViewController.loadFromStoryboard() as? BookmarkListViewController else {return}
    customNavigationDelegate.direction = .right
    bookmarkVC.transitioningDelegate = customNavigationDelegate
    bookmarkVC.modalPresentationStyle = .custom
    present(bookmarkVC, animated: true, completion: nil)
  }
  
  @IBAction func filterResults(_ sender: UIButton) {
    
    deselectAllFilterButton()
    sender.isSelected = true
    
    sender.backgroundColor = ThemeColor.pink2.color
    
    clearSearch()
    getPolicyData(category: sender.currentTitle!, page: page)
  }
  
  private func deselectAllFilterButton() {
    filterButtons.forEach {
      $0.isSelected = false
      $0.backgroundColor = .white
    }
  }
}

//MARK: - tableview gap

extension PolicyMainViewController: StoryboardInstantiable {}

extension PolicyMainViewController: TableViewGappable {
  var headerHeight: CGFloat {
    return gapBWTCell
  }
  
  var footerHeight: CGFloat {
    return gapBWTCell
  }
}

//MARK: - tableview datasource delegate

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
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let token = UserManager.shared.token else {return}
    networkManager.request(apiModel: GetApi.policyDetailGet(token: token, id: datasource[indexPath.section].id)) { result in
      switch result {
      case .success(let data):
        let parsingmanager = ParsingManager()
        parsingmanager.judgeGenericResponse(data: data, model: PolicyData.self) { [weak self] (body) in
          guard let self = self else { return }
          DispatchQueue.main.async {
            guard let vc = DetailViewController.loadFromStoryboard() as? DetailViewController else {return}
            vc.configure(policyData: body)
            self.navigationController?.pushViewController(vc, animated: true)
          }
        }
      case .failure(let error):
        print("communitybookmarkVC", error)
        DispatchQueue.main.async { [weak self] in
          self?.view.makeToast("오류가 발생했습니다. 다시 시도해주세요😂")
        }
      }
    }
  }
}

//MARK: - 무한스크롤

extension PolicyMainViewController {
  
  
  private func fetchData() {
    fetchMore = false
    page += 1
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
      guard let self = self else {return}
      self.getPolicy(page: self.page)
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollView.bounces = scrollView.contentOffset.y > 0
    if tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.height {
      print("끝에 도착했다!!!")
      if fetchMore {
        fetchData()
      }
    }
  }
}

//MARK: - 네트워킹

extension PolicyMainViewController {
  
  private func clearSearch(){
    fetchMore = true
    self.page = 1
    self.datasource.removeAll()
  }
  
  private func getPolicy(page: Int) {
    if let category = self.filterButtons.filter { $0.isSelected }.first?.currentTitle {
      self.getPolicyData(category: category, page: self.page)
    } else {
      self.getPolicyData(page: self.page)
    }
  }
  
  private func getPolicyData(page: Int) {
    guard let token = UserManager.shared.token else {return}
    var location: String? = locationTextField.text
    if locationTextField.text == "전국" { // 전국이면 전체를 다 빼준다.
        location = nil
    }
    networkManager.request(apiModel: GetApi.policyGet(token: token, keyword: searchField.text, location: location, category: nil, page: page)) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: [PolicyData].self) { [weak self] (body) in
          guard let self = self else {return}
          DispatchQueue.main.async {
            if body.count == 0 {
              print("데이터 없음")
              self.fetchMore = false
              return
            }
            self.datasource += body
            self.tableView.reloadData()
            self.fetchMore = true
          }
        }
      case .failure(let error):
        DispatchQueue.main.async { [weak self] in
          if error as! NetworkError == NetworkError.failResponse {
            self?.view.makeToast("결과가 없습니다.🥲")
          } else {
            self?.view.makeToast("인터넷을 확인해주세요!🥲")
          }
          self?.clearSearch()
          self?.tableView.reloadData()
        }
      }
    }
  }
  
  private func getPolicyData(category: String, page: Int) {
    let category = category.components(separatedBy: " ").last!
    guard let token = UserManager.shared.token else {return}
    var location: String? = locationTextField.text
    if locationTextField.text == "전국" { // 전국이면 전체를 다 빼준다.
        location = nil
    }
    networkManager.request(apiModel: GetApi.policyGet(token: token, keyword: searchField.text, location: location, category: Filter.getCase(korean: category), page: page)) { (result) in
      switch result {
      case .success(let data):
        let parsingManager = ParsingManager()
        parsingManager.judgeGenericResponse(data: data, model: [PolicyData].self) { [weak self] (body) in
          guard let self = self else {return}
          DispatchQueue.main.async {
            if body.count == 0 {
              print("데이터 없음")
              self.fetchMore = false
              return
            }
            self.datasource += body
            self.tableView.reloadData()
            self.fetchMore = true
          }
        }
      case .failure(let error):
        DispatchQueue.main.async { [weak self] in
          if error as! NetworkError == NetworkError.failResponse {
            if self?.locationTextField.text != "전국"  {
              self?.view.makeToast("지방단위로 정책을 모으는 중이에요\n전국으로 설정한뒤 이용해주세요\n불편을 드려서 죄송합니다🥲")
            } else {
              self?.view.makeToast("결과가 없습니다.🥲")
            }
          } else {
            self?.view.makeToast("인터넷을 확인해주세요!🥲")
          }
          self?.clearSearch()
          self?.tableView.reloadData()
        }
      }
    }
  }
}

//MARK: - PickerView

extension PolicyMainViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  //toolbar
  private func addToolbar() {
    locationPickerView.backgroundColor = .white
    let toolbar = UIToolbar()
    toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
    toolbar.barTintColor = .white
    locationTextField.inputAccessoryView = toolbar
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let done = UIBarButtonItem()
    done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Asset.Colors.pink1.color], for: .normal)
    done.title = "완료"
    done.target = self
    done.action = #selector(pickerDone)
    
    toolbar.setItems([flexSpace, done], animated: true)
  }
  
  @objc private func pickerDone(_ sender: Any) {
    clearSearch()
    getPolicy(page: page)
    self.view.endEditing(true)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let pickerLabel = UILabel()
    pickerLabel.textAlignment = .center
    pickerLabel.textColor = Asset.Colors.pink1.color
    pickerLabel.font = UIFont.systemFont(ofSize: 24)
    pickerLabel.text = cityName[row]
    return pickerLabel
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return cityName.count
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    locationTextField.text = cityName[row]
  }
}

extension PolicyMainViewController {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == searchField {
      clearSearch()
      getPolicy(page: 1)
    }
    textField.resignFirstResponder()
    return true
  }
}

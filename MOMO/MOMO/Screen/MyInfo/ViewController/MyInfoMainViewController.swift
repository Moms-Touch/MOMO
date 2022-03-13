//
//  MyInfoMainViewController.swift
//  MOMO
//
//  Created by abc on 2021/11/08.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class MyInfoMainViewController: UIViewController, ViewModelBindableType {
  
  //MARK: - ViewModelBindableType

  func bindViewModel() {
    viewModel.output.nickName
      .drive(nickname)
      .disposed(by: disposeBag)
    viewModel.output.email
    viewModel.output.description
    viewModel.output.isLoggedIn
  }
  
  var viewModel: MyInfoViewModel
  //MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  //MARK: - Init
  init(viewModel: MyInfoViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.bind(viewModel: self.viewModel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Private
  
  private var nickname = BehaviorRelay<String?>(value: nil)
  private var email = BehaviorRelay<String?>(value: nil)
  private var userDescription = BehaviorRelay<String>(value: "대한민국에 사는 엄마")
  private var isLoggedIn = BehaviorRelay<Bool>(value: true)
  private var disposeBag = DisposeBag()

  //MARK: - UI
  
  let collectionView : UICollectionView = {
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = InfoMainConstant.lineSpacing
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
    
    collectionView.backgroundColor = .clear
    collectionView.register(MyInfoCollectionViewCell.self)
    collectionView.isPagingEnabled = true
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    
    return collectionView
  }()
  
  let navTitle = UILabel().then {
    $0.navTitleStyle()
    $0.text = InfoMainConstant.navTitle
  }
  
  let closeBar = UIView().then {
    $0.setRound()
    $0.backgroundColor = .systemGray3
  }
  
  let closeButton = UIButton().then {
    $0.setImage(InfoMainConstant.backbutton, for: .normal)
    $0.tintColor = Asset.Colors._45.color
  }
  
  private func setupUI() {
    
    view.addSubview(closeButton)
    view.backgroundColor = InfoMainConstant.backgroundColor
    
    closeButton.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(InfoMainConstant.verticalSpaing)
      make.width.height.equalTo(InfoMainConstant.buttonSize)
    }
    
    view.addSubview(navTitle)
    navTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(InfoMainConstant.navTitleSpacing)
      make.centerX.equalToSuperview()
      make.centerY.equalTo(closeButton)
    }
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide)
      make.top.equalTo(self.navTitle.snp.bottom).offset(InfoMainConstant.verticalSpaing)
    }
    
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

//MARK: - CollectionViewDatasource

extension MyInfoMainViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.infoOptionContent.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCollectionViewCell.identifier, for: indexPath) as! MyInfoCollectionViewCell
   
    cell.configure(with: viewModel.infoOptionContent[indexPath.item], index: indexPath.item)
    
    return cell
  }
}


//MARK: - CollectionViewDelegateFlowLayout

extension MyInfoMainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.frame.size.width * InfoMainConstant.ratio
    let estimatedHeight: CGFloat = 50
    
    //더미셀을 활용해서 Cell의 최적화된 높이를 찾는다.
    let dummyCell = MyInfoCollectionViewCell(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))
    dummyCell.configure(with: viewModel.infoOptionContent[indexPath.item], index: indexPath.item)
    dummyCell.layoutIfNeeded()
    let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: width, height: estimatedHeight))
    
    return CGSize(width: width, height: estimatedSize.height)
  }
}

class MyInfoMainTableViewController: InfoBaseTableViewController {
  
  lazy var networkManager = NetworkManager()
  
  @IBOutlet weak var loginLabel: MyPageLabel! {
    didSet {
      if let token = UserManager.shared.token {
        loginLabel.text = "로그아웃"
      } else {
        loginLabel.text == "로그인"
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
      let tableviewTitle = ["회원정보", "아기정보", "활동내역", "설정", loginLabel.text!, "회원탈퇴"]
      for index in tableView.visibleCells.indices {
        tableView.visibleCells[index].contentView.isAccessibilityElement = true
        
        tableView.visibleCells[index].contentView.accessibilityValue = "\(tableviewTitle[index])"
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0: //infoEdit
      self.navigationController?.pushViewController(MyInfoEditViewController.loadFromStoryboard(), animated: true)
    case 1: //babyInfo
      guard let token = UserManager.shared.token else { return }
      networkManager.request(apiModel: GetApi.babyGet(token: token)) { (result) in
        switch result {
        case .success(let data):
          let parsingManager = NetworkCoder()
          parsingManager.judgeGenericResponse(data: data, model: [BabyData].self) { [weak self] (body) in
            guard let self = self else {return}
            if body.count > 0 {
              let baby = body[0]
              DispatchQueue.main.async {
                guard let babyInfoVC = MyBabyInfoViewController.loadFromStoryboard() as? MyBabyInfoViewController else {return}
                babyInfoVC.babyViewModel = BabyInfoViewModel()
                babyInfoVC.babyViewModel?.model = baby
                print(baby)
                self.navigationController?.pushViewController(babyInfoVC, animated: true)
              }
            } else  {
              DispatchQueue.main.async {
                guard let babyInfoVC = MyBabyInfoViewController.loadFromStoryboard() as? MyBabyInfoViewController else {return}
                babyInfoVC.babyViewModel = BabyInfoViewModel()
                self.navigationController?.pushViewController(babyInfoVC, animated: true)
              }
            }
            
          }
        case .failure(let error):
          print(error)
        }
      }
      
      
    case 2: //MyActivity
      self.navigationController?.pushViewController(MyActivityViewController.loadFromStoryboard(), animated: true)
    case 3: // MySetting
      self.navigationController?.pushViewController(MySettingViewController.loadFromStoryboard(), animated: true)
    case 4: //로그인 로그아웃
      if loginLabel.text == "로그아웃" {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃을 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: {
          [weak self] (action) in
          UserManager.shared.deleteUser()
          guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
          let newNaviController = UINavigationController(rootViewController: loginVC)
          newNaviController.isNavigationBarHidden = true
          let sceneDelegate = UIApplication.shared.connectedScenes
                  .first!.delegate as! SceneDelegate
          sceneDelegate.window!.rootViewController = newNaviController
        }))
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        self.present(alert, animated: true, completion: nil)
      } else {
        guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
        let newNaviController = UINavigationController(rootViewController: loginVC)
        newNaviController.isNavigationBarHidden = true
        let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = newNaviController
      }
    case 5:
      let alert = UIAlertController(title: "회원탈퇴", message: "회원탈퇴하시겠습니까?", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "네", style: .default, handler: {
        (action) in
        guard let token = UserManager.shared.token else {return}
        self.networkManager.request(apiModel: DeleteApi.deleteUser(token: token)) { (result) in
          switch result {
          case .success(let data):
              DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                UserManager.shared.deleteUser()
                guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
                let newNaviController = UINavigationController(rootViewController: loginVC)
                newNaviController.isNavigationBarHidden = true
                let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
                sceneDelegate.window!.rootViewController = newNaviController
              }
          case .failure(let error):
            self.view.makeToast("회원탈퇴에 실패했어요. 다시 시도해주세요")
          }
        }}))
      alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
      self.present(alert, animated: true, completion: nil)
    default:
      return
    }
  }
  
  
}


//MARK: - Constant

enum InfoMainConstant {
  
  static var lineSpacing: CGFloat {
    return 35
  }
  
  static var navTitle: String {
    return "마이 페이지"
  }
  
  static var navTitleSpacing: CGFloat {
    return 50
  }
  
  static var backbutton: UIImage {
    return UIImage(systemName: "chevron.left")!
  }
  
  static var buttonSize: CGFloat {
    return 24
  }
  
  static var verticalSpaing: CGFloat {
    return 20
  }
  
  static var backgroundColor: UIColor {
    return Asset.Colors.fa.color.withAlphaComponent(0.8)
  }
  
  static var ratio: Double {
    return 0.8
  }
  
}


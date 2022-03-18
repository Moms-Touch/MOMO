//
//  MyInfoCollectionViewCell.swift
//  MOMO
//
//  Created by abc on 2022/03/11.
//

import UIKit

import Then
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

class MyInfoCollectionViewCell: UICollectionViewCell {
  
  
  //MARK: - UI
  private var firstOptionLabel: UILabel?
  private var secondOptionLabel: UILabel?
  private var thirdOptionLabel: UILabel?
  private var forthOptionLabel: UILabel?
  private var labels: [UILabel] = []
  private var stackView: UIStackView?
  
  private func buildLabels() -> [UILabel] {
    
    let labels = [UILabel(), UILabel(), UILabel(), UILabel()]
    
    labels.forEach {
      $0.text = "TESTTESTTEST\n도레미파솔라시도"
      $0.font = .customFont(forTextStyle: .footnote)
      $0.textColor = Asset.Colors.pink4.color
      $0.numberOfLines = 0
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    self.firstOptionLabel = labels[0]
    self.secondOptionLabel = labels[1]
    self.thirdOptionLabel = labels[2]
    self.forthOptionLabel = labels[3]
    
    return labels
  }
  
  private func setupUI() {
    let labels = buildLabels()
    self.labels = labels
    makeAttributed()
    let stackView = UIStackView(arrangedSubviews: labels).then {
      $0.axis = .vertical
      $0.distribution = .equalSpacing
      $0.spacing = 20
      $0.alignment = .leading
    }
    self.stackView = stackView
    contentView.addSubview(stackView)
    contentView.backgroundColor = .white
    contentView.setRound(20)
    stackView.snp.makeConstraints { make in
      make.left.right.top.bottom.equalToSuperview().inset(20)
    }
  }
  
  //MARK: - Private
  
  private var disposeBag = DisposeBag()
  
  private func gotoLoginVC() {
    guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
    let newNaviController = UINavigationController(rootViewController: loginVC)
    newNaviController.isNavigationBarHidden = true
    let sceneDelegate = UIApplication.shared.connectedScenes
      .first!.delegate as! SceneDelegate
    sceneDelegate.window!.rootViewController = newNaviController
  }
  
  private func makeAttributed() {
    guard let viewmodel = viewModel, viewmodel.index == 1 else { return }
    self.labels.forEach { label in
      if let text = label.text, !text.contains("\n") {
        return
      }
      let fontSize = UIFont.customFont(forTextStyle: .caption1)
      let attributedStr = NSMutableAttributedString(string: label.text!)
      let selectedStr = label.text!.components(separatedBy: "\n")
      attributedStr.addAttribute(.font, value: fontSize, range: (label.text! as NSString).range(of: selectedStr[1]))
      label.attributedText = attributedStr
    }
  }
  
  private func removeLastLabel() {
    guard let viewmodel = viewModel, viewmodel.index != 1 else { return }
    forthOptionLabel?.isHidden = true
    forthOptionLabel?.removeFromSuperview()
  }
  
  private func presentLocationVC() {
    let vc = LocationViewController.loadFromStoryboard() as! LocationViewController
    vc.editMode = true
    self.present(viewController: vc, animated: true, completion: nil)
  }
  
  
  //MARK: - Binding
  
  func bindViewModel() {
    guard let viewModel = viewModel else {return}
    if viewModel.index == 0 {
      guard let viewModel = viewModel as? MyInfoCellViewModel else {return}
      
      viewModel.output.nick
        .drive(self.firstOptionLabel!.rx.text)
        .disposed(by: disposeBag)
      
      viewModel.output.email
        .drive(self.secondOptionLabel!.rx.text)
        .disposed(by: disposeBag)
      
      viewModel.output.description
        .drive(self.thirdOptionLabel!.rx.text)
        .disposed(by: disposeBag)
      
    } else if viewModel.index == 1 {
      guard let viewModel = viewModel as? InfoChangeCellViewModel else {return}
      
      viewModel.output.goToChangeNickname
        .filter { $0 == true }
        .drive(onNext: { _ in
          presentNicknameChangeAlertVC()
        })
        .disposed(by: disposeBag)
      
      viewModel.output.goToChangeLocation
        .filter { $0 == true }
        .drive(onNext: { [unowned self] _ in
          self.presentLocationVC()
        })
        .disposed(by: disposeBag)
            
      //input
      
      firstOptionLabel?.rx
        .tapGesture()
        .when(.recognized)
        .map { _ in return true }
        .bind(to: viewModel.input.isPregnantClicked)
        .disposed(by: disposeBag)
      
      secondOptionLabel?.rx
        .tapGesture()
        .when(.recognized)
        .map { _ in return true }
        .bind(to: viewModel.input.locationClicked)
        .disposed(by: disposeBag)
      
      thirdOptionLabel?.rx
        .tapGesture()
        .when(.recognized)
        .subscribe(onNext: { [unowned self] _ in
          // 비밀번호 변경
        })
        .disposed(by: disposeBag)
      
      forthOptionLabel?.rx
        .tapGesture()
        .when(.recognized)
        .map { _ in return true }
        .bind(to: viewModel.input.nicknameClicked)
        .disposed(by: disposeBag)
      
      func presentNicknameChangeAlertVC() {
        self.textfieldAlert(title: "닉네임 변경하기", text: "닉네임 변경하시겠습니까")
          .bind(to: viewModel.input.newNickname)
          .disposed(by: disposeBag)
      }
      
    } else {
      guard let viewModel = viewModel as? InfoUserManageViewModel else {return}
      firstOptionLabel?.rx
        .tapGesture()
        .when(.recognized)
        .subscribe(onNext: { [unowned self] _ in
          self.alert(title: "로그아웃", text: "로그아웃을 하시겠습니까?")
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: {
              self.gotoLoginVC()
            })
            .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)
      
      secondOptionLabel?.rx
        .tapGesture()
        .when(.recognized)
        .subscribe(onNext: { [unowned self] _ in
          self.alert(title: "회원탈퇴", text: "회원탈퇴를 하시겠습니까?")
            .subscribe(onCompleted: {
              viewModel.output.withdrawalUser
                .observe(on: MainScheduler.instance)
                .subscribe(onCompleted: {
                  self.gotoLoginVC()
                })
                .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)
      
      thirdOptionLabel?.rx
        .tapGesture()
        .when(.recognized)
        .subscribe(onNext: { [unowned self] _ in
          
        })
        .disposed(by: disposeBag)
      
    }
  }
  
  var viewModel: InfoCellViewModel? {
    didSet {
      self.bindViewModel()
      self.removeLastLabel()
      self.makeAttributed()
    }
  }
  
  private var nick = BehaviorRelay<String?>(value: nil)
  
  //MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    viewModel = nil
    disposeBag = DisposeBag()
  }
  
}

extension MyInfoCollectionViewCell {
  func findCellheight(with options: [String]?) {
    guard let options = options else {
      return
    }
    if options.count > 3 {
      firstOptionLabel?.text = options[0]
      secondOptionLabel?.text = options[1]
      thirdOptionLabel?.text = options[2]
      forthOptionLabel?.text = options[3]
      stackView?.spacing = 0
    } else {
      firstOptionLabel?.text = options[0]
      secondOptionLabel?.text = options[1]
      thirdOptionLabel?.text = options[2]
      forthOptionLabel?.isHidden = true
      forthOptionLabel?.removeFromSuperview()
    }
  }
}

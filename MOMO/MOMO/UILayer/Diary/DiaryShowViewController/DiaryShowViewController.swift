//
//  DiaryShowViewController.swift
//  MOMO
//
//  Created by Jung peter on 2022/04/04.
//

import UIKit

import Then
import SnapKit

//공통적인 UI를 위해서 DiaryShowViewController를 생성

class DiaryShowViewController: UIViewController {
  
  let dateLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    $0.text = Date().toString()
  }
  
  let backButton = UIButton(type: .system).then {
    $0.setImage(UIImage(systemName:"chevron.left"), for: .normal)
  }
  
  let navBar = UIView(frame: .zero).then {
    $0.backgroundColor = .clear
  }
  
  let completeOrDeleteButton = UIButton(type:.custom).then {
    $0.setTitle("완료", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    $0.setTitleColor(.label, for: .normal)
  }
  
  let diaryInputContainerView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  let blurView = BlurView()
  var emotionButtons = [UIButton]()
  
  func appendChildVC(to parentView: UIView, with child: UIViewController) {
    self.addChild(child)
    parentView.addSubview(child.view)
    child.view.snp.makeConstraints { make in
      make.left.right.top.bottom.equalTo(self.diaryInputContainerView)
    }
    child.didMove(toParent: self)
  }
  
  func makeEmotionButtonArray() -> [UIButton] {
    
    let happyBirdButton = makeEmotionButton(emotion: "bird.happy")
    let sadBirdButton = makeEmotionButton(emotion: "bird.sad")
    let blueBirdButton = makeEmotionButton(emotion: "bird.blue")
    let angryBirdButton = makeEmotionButton(emotion: "bird.angry")
    
    return [happyBirdButton, angryBirdButton, sadBirdButton, blueBirdButton]
  }
  
  func makeStackView(emotionButtons: [UIButton]) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: emotionButtons).then {
      $0.axis = .horizontal
      $0.distribution = .equalSpacing
      $0.spacing = 20
    }
    
    self.view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(20)
      make.top.equalTo(navBar.snp.bottom).inset(-25)
      make.bottom.equalTo(diaryInputContainerView.snp.top).offset(-15)
    }
    return stackView
  }
  
  func makeEmotionButton(emotion: String) -> UIButton {
    let button = UIButton(type: .custom).then {
      $0.setImage(UIImage(named: emotion + ".default"), for: .normal)
      $0.setImage(UIImage(named: emotion), for: .selected)
    }
    return button
  }
  
  func setupUI() {
    navBar.addSubview(backButton)
    navBar.addSubview(dateLabel)
    navBar.addSubview(completeOrDeleteButton)
    view.addSubview(blurView)
    view.addSubview(navBar)
    view.addSubview(diaryInputContainerView)
    
    blurView.snp.makeConstraints { make in
      make.left.right.bottom.top.equalToSuperview()
    }

    backButton.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(20)
      make.centerY.equalToSuperview()
    }
    
    dateLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    completeOrDeleteButton.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(20)
      make.centerY.equalToSuperview()
    }
    
    navBar.snp.makeConstraints { make in
      make.height.equalTo(44)
      make.left.right.top.equalTo(view.safeAreaLayoutGuide)
    }
    
    self.emotionButtons = makeEmotionButtonArray()
    let stackview = makeStackView(emotionButtons: emotionButtons)
    
    diaryInputContainerView.snp.makeConstraints { make in
      make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
      make.top.equalTo(stackview.snp.bottom).offset(-15)
    }
    
  }
  
}

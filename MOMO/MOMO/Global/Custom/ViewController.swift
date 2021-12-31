//
//  ViewController.swift
//  MOMO
//
//  Created by 오승기 on 2021/12/31.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarHidden()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 네비게이션 백 스와이프 모션으로도 뒤로가기가 가능하도록 만들어주는 함수
    func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    //MARK: - 네비게이션 바 숨기는 함수
    func navigationBarHidden() {
        self.navigationController?.navigationBar.isHidden = true
    }
}

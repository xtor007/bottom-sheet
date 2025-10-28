//
//  ViewController.swift
//  bottom-sheet
//
//  Created by Anatoliy Khramchenko on 28.10.2025.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }

}

private extension ViewController {
  
  func setup() {
    setupBackground()
  }
  
  func setupBackground() {
    UIImageView(image: .map).then {
      $0.contentMode = .scaleAspectFill
      
      view.addSubview($0)
      
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
  }
  
}

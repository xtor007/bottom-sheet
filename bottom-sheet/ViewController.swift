//
//  ViewController.swift
//  bottom-sheet
//
//  Created by Anatoliy Khramchenko on 28.10.2025.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
  
  private let sheetView = UIView()
  private let floatingButton = UIButton()
  
  private var sheetTopConstraint: Constraint!
  private var currentTop: CGFloat = 0
  private var animator: UIViewPropertyAnimator?
  
  private var collapsedTop: CGFloat { view.bounds.height - 136.0 }
  private var middleTop: CGFloat { view.bounds.height * 0.5 }
  private var expandedTop: CGFloat { 80.0 }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    currentTop = middleTop
    setup()
  }
}

private extension ViewController {
  
  func setup() {
    setupBackground()
    setupSheet()
    setupFloatingButton()
  }
  
  func setupBackground() {
    UIImageView(image: .map).then {
      $0.contentMode = .scaleAspectFill
      
      view.addSubview($0)
      
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
  }
  
  func setupSheet() {
    sheetView.then {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 60.0
      $0.clipsToBounds = true
      
      view.addSubview($0)
      
      $0.snp.makeConstraints { make in
        sheetTopConstraint = make.top.equalToSuperview().offset(currentTop).constraint
        make.trailing.leading.bottom.equalToSuperview()
      }
      
    }
    
    UIView().then {
      $0.backgroundColor = .gray
      $0.layer.cornerRadius = 2.0
      
      sheetView.addSubview($0)
      
      $0.snp.makeConstraints {
        $0.height.equalTo(4.0)
        $0.width.equalTo(40.0)
        $0.centerX.equalToSuperview()
        $0.top.equalToSuperview().offset(4.0)
      }
    }
    
    updateSheetLayout(for: currentTop)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    sheetView.addGestureRecognizer(pan)
  }
  
  func setupFloatingButton() {
    floatingButton.then {
      $0.setTitle("🛰️", for: .normal)
      $0.backgroundColor = .white
      $0.tintColor = .white
      $0.layer.cornerRadius = 25.0
      
      view.addSubview($0)
      
      $0.snp.makeConstraints { make in
        make.width.height.equalTo(50.0)
        make.trailing.equalToSuperview().offset(-20.0)
        make.bottom.equalTo(sheetView.snp.top).offset(-20.0)
      }
    }
  }
  
  @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view).y
    gesture.setTranslation(.zero, in: view)
    
    switch gesture.state {
    case .changed:
      currentTop = max(expandedTop, min(currentTop + translation, collapsedTop))
      sheetTopConstraint.update(offset: currentTop)
      updateSheetLayout(for: currentTop)
      view.layoutIfNeeded()
      
    case .ended, .cancelled:
      let velocity = gesture.velocity(in: view).y
      let target = nearestState(from: currentTop, velocity: velocity)
      snap(to: target)
      
    default: break
    }
  }
  
  func updateSheetLayout(for top: CGFloat) {
    let fraction = (top - expandedTop) / (collapsedTop - expandedTop) // 0..1
    let sideInset = 16.0 * fraction // expanded=0, collapsed=16
    sheetView.snp.updateConstraints { make in
      make.leading.equalToSuperview().offset(sideInset)
      make.trailing.bottom.equalToSuperview().offset(-sideInset)
    }
    
    floatingButton.alpha = min(fraction * 2, 1.0)
  }
  
  func nearestState(from current: CGFloat, velocity: CGFloat) -> CGFloat {
    let velocityTreshold = 1200.0
    if velocity < -velocityTreshold { return expandedTop }
    if velocity > velocityTreshold { return collapsedTop }
    let positions = [expandedTop, middleTop, collapsedTop]
    return positions.min(by: { abs($0 - current) < abs($1 - current) })!
  }
  
  func snap(to target: CGFloat) {
    animator?.stopAnimation(true)
    currentTop = target
    animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.85) { [weak self] in
      self?.sheetTopConstraint.update(offset: target)
      self?.updateSheetLayout(for: target)
      self?.view.layoutIfNeeded()
    }
    animator?.startAnimation()
  }
  
}

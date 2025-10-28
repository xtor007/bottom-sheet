//
//  SceneDelegate.swift
//  bottom-sheet
//
//  Created by Anatoliy Khramchenko on 28.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let windowScene = (scene as? UIWindowScene)  else { return }
    window = UIWindow(windowScene: windowScene)
    let controller = ViewController()
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
  }


}


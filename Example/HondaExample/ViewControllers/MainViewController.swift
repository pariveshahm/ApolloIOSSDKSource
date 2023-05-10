//  MainViewController.swift
//  FCAExample
//
//  Created by Selma Suvalija on 7/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.

import UIKit
import SwiftUI
import ApolloMobileSDK

class MainViewController: UITabBarController {

    let testController = TestTableViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        let carModel = CarModel(name: "Honda Civic", logo: "honda-logo", image: "honda-civic", brand: "jeep")
        initTabBarViewControllers(carModel)
    }
    
    func initTabBarViewControllers(_ carModel: CarModel) {
        let remoteController = initRemoteController(carModel)
        let infoController = initInfoController()
        let locationController = initLocationController()
        
        let testController = initTestViewController()
        
        let controllers = [remoteController, infoController, locationController, testController]
        self.viewControllers = controllers
    }
    
    func initRemoteController(_ carModel: CarModel) -> UIViewController  {
        
        let remoteVC = RemoteViewController(carImage: carModel.image, navigationDelegate: self)
        let navigationVC = UINavigationController(rootViewController: remoteVC)
        
        remoteVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: nil, action: nil)
        remoteVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bubble.left.fill"), style: .plain, target: nil, action: nil)
        remoteVC.navigationItem.leftBarButtonItem?.tintColor = AttAppTheme.primaryColor.uiColor()
        remoteVC.navigationItem.rightBarButtonItem?.tintColor = AttAppTheme.primaryColor.uiColor()
        
        remoteVC.navigationItem.title = carModel.name
        
        let remoteIcon = UITabBarItem(title: "remote".localized(), image: UIImage(named: "remote"), selectedImage: UIImage(named: "remote"))
        
        navigationVC.tabBarItem = remoteIcon
        return navigationVC
    }

    func initTestViewController() -> UIViewController {
        testController.tabBarItem.image = UIImage.init(systemName: "tablecells")
        testController.tabBarItem.title = "table".localized()
        
        return testController
    }
    
    func initInfoController() -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let infoController = storyboard.instantiateViewController(identifier: "infoVC")
        return infoController
    }
    
    func initLocationController() -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let locationController = storyboard.instantiateViewController(identifier: "locationVC")
        return locationController
    }
    
    struct CarModel {
        var name: String
        var logo: String
        var image: String
        var brand: String
    }
}

extension MainViewController: AttNavigationDelegate {
    public func pop(viewController: UIViewController, completion: @escaping () -> Void) {
        completion()
        
        if let pushedVC = self.navigationController?.viewControllers.last, pushedVC.view.tag == viewController.view.tag {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func present(viewController: UIViewController) {
        self.present(viewController, animated: false, completion: nil)
    }
    
    func push(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

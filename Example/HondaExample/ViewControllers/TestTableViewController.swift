//
//  TestTableViewController.swift
//  HondaExample
//
//  Created by Elvis on 4/7/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import ApolloMobileSDK
import SwiftUI

class TestTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var widgetViewModel = AttWidgetViewModel()
    private var widgetController: AttWidgetController?
    
    // private flag which determines by the availability status if widget would be shown or hidden
    private var widgetHidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the delegate for height changes of a widget, after loading the data
        widgetViewModel.output = self
        widgetViewModel.automaticLoad = false
        
        // storing viewController into private variable so it wouldn't be recreated every time when tableview reload happens
        widgetController = AttWidgetController(isOnDashboard: false, isForCellView: true, navigationDelegate: self, model: self.widgetViewModel, screenType: .homePage)
        widgetController?.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // registering tableView celll
        tableView.register(AttWidgetCell.self, forCellReuseIdentifier: "AttWidgetCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // setting the delegate for listening of vehicleAvailability, and showing/hiding error widget
        ApolloSDK.current.setDelegate(self)
        
        widgetViewModel.setViewActive()
        widgetViewModel.loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        widgetViewModel.setViewInactive()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // default number of sections for testing purposes
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // default number of rows for testing purposes
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // AttWidgetCell should have automatic dimension set, otherwise it won't adapt to height changes
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row, widgetHidden) {
        case (0, false):
            
            // setup of AttWidgetCell for first position in tableview, if vehicleAvailability is not error
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttWidgetCell", for: indexPath) as! AttWidgetCell
            
            if let widgetController = widgetController {
                cell.set(controller: widgetController, model: widgetViewModel, parentController: self)
            }
            
            return cell
        default:
            
            // default cell
            let defaultCell = UITableViewCell()
            defaultCell.textLabel?.text = "Row \(indexPath.row)"
            return defaultCell
        }
    }
    
    // This method is not used but you can use it to make a full reload of a widget if needed
    private func reloadWidget() {
        widgetController = AttWidgetController(isOnDashboard: false, navigationDelegate: self, model: self.widgetViewModel, screenType: .homePage)
        tableView.reloadData()
    }
    
    private func switchVin() {
        ApolloSDK.current.resetSubscriptionData()
        // set the values here
        ApolloSDK.current.vin("4D83028HONERM4415")
        ApolloSDK.current.accessToken("eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2MjA3MzI2ODcsImlhdCI6MTYyMDcyNTQ4NywianRpIjoiNWY1NTVjMTAtZDkzNS00ZTYwLTg0ZDctM2ZmNjFmNjI3ZTQxIiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6NzkxZDJiZGYtNDI4OS00N2ZmLTgwZGItODBlNjJkMGU2MDg3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6ImYzM2Y3YjQ0LTgzNTktNGEyYy1iZTgxLTFlODJjMjZmNTE5MiIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6ImVsdmlzMkBtYWVzdHJhbHRlc3RpbmcubmV0In0.fKAKimYnYdRzPLXRQI9dinHgMnInxDX75Lg0qzVHy16KjWR3xaBBxRnZ7M0FuJkdIzl6avD7VBqtHcU6QYj0YlJYdReYhPJGqSlHP_ZlxPlJJ5mU3iCExypdadcnwpRHjYgj5h8tmEmb7LGeyeg3FpqGO-JHzc0xtppotnlPZktI5T0LDcald4SoqOEx0iTlAflqUXI2eycb4Ce1S2Hf20kYr8BiieAtsJ58NBcttJhWHAWEgfNWBaGPRYhGn0T_m6qrGyr9A5VCVdD3togqZApGNCztPLQB5YYlLoVqeIR_xQe5zYkaAio78bh774zUh1zQJbJumUiXayM-mCNyIw")
        
        // reload the widget
        reloadWidget()
    }
}

extension TestTableViewController: ApolloSDKDelegate {
    func vinStateUpdated(vehicleAvailability: String) {
        ApolloSDK.current.setDelegate(nil)
        // delegate method which takes information from loadSubscriptions about vehicle availability and in case if it returns error or vehicleNotEligible, widget will be hidden
        
        switch vehicleAvailability {
            case "error":
                widgetHidden = false
            case "vehicleNotEligible":
                widgetHidden = false
            default:
                widgetHidden = false
        }
        tableView.reloadData()
    }
    
    // not needed
    func openHotspotSetupGuide() {
        ApolloSDK.current.setDelegate(nil)
    }
    
    func exitFromSDKListener() {
        ApolloSDK.current.setDelegate(nil)
    }
}

extension TestTableViewController: AttWidgetViewModelDelegate {

    // after loading subscriptions, height of a widget should be refreshed depending on the vehicle status
    func onWidgetHeightUpdated() {
        self.tableView.reloadData()
    }
}

// navigation delegate implementation used for navigating from AttWidgetCell(View) to some of the flows
extension TestTableViewController: AttNavigationDelegate {

    public func pop(viewController: UIViewController, completion: @escaping () -> Void) {
        completion()
        
        if let pushedVC = self.navigationController?.viewControllers.last, pushedVC.view.tag == viewController.view.tag {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func present(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func push(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

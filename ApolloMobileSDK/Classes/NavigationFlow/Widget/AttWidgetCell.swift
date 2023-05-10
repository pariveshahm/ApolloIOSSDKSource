//
//  AttWidgetCell.swift
//  ApolloMobileSDK
//
//  Created by Elvis on 4/15/21.
//

import Foundation
import UIKit

public class AttWidgetCell: UITableViewCell {
    private var hostingController: AttWidgetController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.hostingController?.view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(controller: AttWidgetController, model: AttWidgetViewModel, parentController: UIViewController) {
        self.hostingController = controller
        
        guard let hostingController = self.hostingController else {return}
        hostingController.view.restorationIdentifier = "AttWidgetController"
        hostingController.view.sizeToFit()
        
        if let widgetView = self.contentView.subviews.first(where: {$0.restorationIdentifier == "AttWidgetController"}) {
            widgetView.removeFromSuperview()
        }
        
        contentView.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: model.horizontalPadding).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -model.horizontalPadding).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: model.verticalPadding).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -model.verticalPadding).isActive = true
        
        hostingController.view.updateConstraints()
        hostingController.view.layoutIfNeeded()
      
        contentView.updateConstraints()
        contentView.backgroundColor = .clear
        contentView.layoutIfNeeded()
    
    }
}

//  SubscriptionModel.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 19/01/2021.

import Foundation

struct AttSubscriptionViewModel {
    
    var id: String?  
    var name = ""
    var autoRenewalDate = ""
    var planType = ""
    var expiresOn = ""
    var usage = ""
    
    var limit: Double = 0.0
    var used: Double = 0.0
    
    // - Flags
    var autoRenew: Bool         = false
    var isUnlimited: Bool       = false
    var hasUsedAllTheData: Bool = false
    var usageNotReturned: Bool  = false
    var isTrial: Bool           = false
    var hasStackedRetailPlanError: Bool = false
    
    var progressMaxValue: Double {
        isUnlimited ? 1.0 : limit
    }
    
    var progressValue: Double {
        isUnlimited ? 1.0 : used
    }
    
    var disclamerText: String? {
        
        // ORDER is important
        
        // 1. if it is trial, first check usage
        if (isTrial && usageNotReturned) {
            return "usage_not_returned".localized()
        }
        
        // 2. if it not trial check stacked retail error, then usage
        if hasStackedRetailPlanError {
            return "has_stacked_retail_plan_error".localized()
        }
        if usageNotReturned {
            return "usage_not_returned".localized()
        }
        
        if isUnlimited && autoRenew {
            return nil
        }
    
        if hasUsedAllTheData {
            return "has_used_all_the_data".localized() //"has_used_all_the_data".localized()
        }
        
        if isTrial {
            return "wifi_text".localized()
        }
        
        if isTrial == false {
            return "dashboard_active_plan_prepaid_note".localized()
        }
        
        return ""
    }
    
    var hasEndDate: Bool {
        return autoRenew ? !autoRenewalDate.isEmpty : !expiresOn.isEmpty
    }
}

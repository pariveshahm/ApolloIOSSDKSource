//  SDKFont.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 22/01/2021.

import Foundation

enum AttSDKFont: String, CaseIterable {
    
    case thin    = "ATTAleckSans-Thin"
    case light   = "ATTAleckSans-Light"
    case regular = "ATTAleckSans-Regular"
    case medium  = "ATTAleckSans-Medium"
    case bold    = "ATTAleckSans-Bold"
    case black   = "ATTAleckSans-Black"
    
    case italicThin    = "ATTAleckSans-ThinItalic"
    case italicLight   = "ATTAleckSans-LightItalic"
    case italicRegular = "ATTAleckSans-Italic"
    case italicMedium  = "ATTAleckSans-MediumItalic"
    case italicBold    = "ATTAleckSans-BoldItalic"
    case italicBlack   = "ATTAleckSans-BlackItalic"
    
}

extension AttSDKFont {
    
    var fileName: String {
        switch self {
        case .thin:          return "ATTAleckSans_Th"
        case .light:         return "ATTAleckSans_Lt"
        case .regular:       return "ATTAleckSans_Rg"
        case .medium:        return "ATTAleckSans_Md"
        case .bold:          return "ATTAleckSans_Bold"
        case .black:         return "ATTAleckSans_Blk"
        case .italicThin:    return "ATTAleckSans_ThIt"
        case .italicLight:   return "ATTAleckSans_LtIt"
        case .italicRegular: return "ATTAleckSans_It"
        case .italicMedium:  return "ATTAleckSans_MdIt"
        case .italicBold:    return "ATTAleckSans_BdIt"
        case .italicBlack:   return "ATTAleckSans_BlkIt"
        }
    }

}

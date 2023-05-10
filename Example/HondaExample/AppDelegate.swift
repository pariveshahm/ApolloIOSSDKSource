//  AppDelegate.swift
//  FCAExample
//
//  Created by Selma Suvalija on 6/24/20.
//  Copyright © 2020 CocoaPods. All rights reserved.

import UIKit
import ApolloMobileSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window?.makeKeyAndVisible()

        let testUser = AttUser(
            firstName: "Joe",
            lastName: "Doe",
            email: "joedoe@mail.com",
            phone: "5554444333",
            country: .US,
            state: "CA",
            city: "Colton",
            street: "225 W Valley Blvd",
            zipCode: "92324"
        )

        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithTransparentBackground()
        coloredNavAppearance.backgroundColor = .systemPink
        // change navigation setup for this screen
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance

        ApolloSDK
            .current
            .tenant(.honda)
            .hostName("One App")
            .vin("DE27365HONERM1450")
            .accessToken("eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2NzE0NjA5MjgsImlhdCI6MTY3MTQ1MzcyOCwianRpIjoiZTgwMjM5MmItZGMyMi00OThhLWJjYjYtNTM0OGI1MmU3Y2YxIiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6YTZjZWVjNzQtMGFhMy00NGNiLTk1MzItYTY2ZjNhZWFiMmY1IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6ImQ0MmYxMWNlLWJiM2QtNDhhMC1hNTA2LWI0NTMxMzdiZWVjMyIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6IjNvaDB1MjZpNWRAMXNlY21haWwuY29tIn0.jg8a_tuddYUmSXjIX6Ez0thMlyYmLzh49WiqQQE9LPV9A30olGo7_OsUogeh1eWOxHu2aSlIDVibk91VACrYjIuua7ujU3b5YD1qoXD3GQ5thWvLHgQLrZvvcq_esBF6sVBO8lcnIXkrZ26SqzTbAGV7mbsHS7trxMC7_H-_d2QSeTxi-Va5hs7kNHxikvg9Civy82F9QUEFZxUaRDwslZP2pGViyC4yldeTU2dwSFEc7NsOLEhtGwnZQfJflUBv0yJQVA_VvnMfXCsEunYPLOdIkGY7TosSEyXbtrVn1KwW00QSNvW5kVRxOJLzPP-8V_f4r8v1kQyKsHaYZned_Q")
            .user(testUser)
            .country(.US)
            .language(.en)
            .environment(.sandbox)
            .channel(.simulator)
            .sdkDarkThemeFile("BrandedRetailSDKTheme-night", bundlePath: Bundle.main.bundlePath)
            .sdkLightThemeFile("BrandedRetailSDKTheme", bundlePath: Bundle.main.bundlePath)
            .hotspot(.init(HotspotView()))
            .setDelegate(TestingDelegateController())
            .setAuthenticationDelegate(TestingDelegateController())
            .setHotspotSetupGuideButtonText("Hotspot setup guide")
            .setValidateSubscriptionCachingDuration(15)
//            .setReturnToDashboardButtonText("Return to OEM dashboard")
            .build()

        #if DEBUG
          //  runTests()
         //   dateTest()
        #endif

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // This will ensure that theme change won't break UI. It will stay consistent until new start of the app.
        if (AttAppTheme.checkIsDarkTheme()) {
            window!.overrideUserInterfaceStyle = .dark
        } else {
            window!.overrideUserInterfaceStyle = .light
        }

        ApolloSDK.current.build()
    }


    private func runTests() {

        let viewModel = AttWidgetViewModel()
        var subscription = ApolloMobileSDK.AttSubscription()

        print("Tests ----------------------------------------------------")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "2097152" , used: "563200", unit: "KB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "550MB of 2GB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "2048" , used: "500", unit: "MB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "500MB of 2GB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "2048" , used: "0.02", unit: "MB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "0.02MB of 2GB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "800" , used: "120.83", unit: "MB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "120.83MB of 800MB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "800" , used: "0.02", unit: "MB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "0.02MB of 800MB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "3" , used: "0.8", unit: "GB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "819.20MB of 3GB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "3" , used: "1.2", unit: "GB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "1.20GB of 3GB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "2097152" , used: "563200", unit: "KB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "550MB of 2GB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "2097152" , used: "1039576", unit: "KB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "1015.21MB of 2GB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "2097152" , used: "1572864", unit: "KB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "1.50GB of 2GB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "10240" , used: "300", unit: "KB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "300KB of 10MB")

        subscription.usage = ApolloMobileSDK.AttUsage.init(limit: "10240" , used: "1305", unit: "KB")
        printResult(result: viewModel.getUsage(item: subscription), expected: "1.27MB of 10MB")

        print("------------------------------------------------------------")
    }
    
    private func dateTest(){
        var testTimeAgo: String = "2022-06-23 12:53:10.002 UTC"
        var testResult = AttDateUtils.formatCachedTimeString(timeAgo: testTimeAgo, compareTo: Date())
        
        printResult(result: testResult, expected: "2 hours ago")
    }

    private func printResult(result: String, expected expectedResult: String) {
        if result == expectedResult {
            print("Correct \(expectedResult)")

        } else { print("Incorrect: \(result) ==========> \(expectedResult)")}
    }

}

class TestingDelegateController: UIViewController, ApolloSDKDelegate {
    func vinStateUpdated(vehicleAvailability: String) {
        // do the  UI update here
    }

    func openHotspotSetupGuide() {
        // do the implementation here
    }
    
    func exitFromSDKListener(){
        // do the implementation here
    }
}

extension TestingDelegateController: ApolloSDKAuthenticationDelegate {
    func requestNewToken() {
//        // new token should be gathered
//        let newToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2MjA3MzI2ODcsImlhdCI6MTYyMDcyNTQ4NywianRpIjoiNWY1NTVjMTAtZDkzNS00ZTYwLTg0ZDctM2ZmNjFmNjI3ZTQxIiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6NzkxZDJiZGYtNDI4OS00N2ZmLTgwZGItODBlNjJkMGU2MDg3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6ImYzM2Y3YjQ0LTgzNTktNGEyYy1iZTgxLTFlODJjMjZmNTE5MiIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6ImVsdmlzMkBtYWVzdHJhbHRlc3RpbmcubmV0In0.fKAKimYnYdRzPLXRQI9dinHgMnInxDX75Lg0qzVHy16KjWR3xaBBxRnZ7M0FuJkdIzl6avD7VBqtHcU6QYj0YlJYdReYhPJGqSlHP_ZlxPlJJ5mU3iCExypdadcnwpRHjYgj5h8tmEmb7LGeyeg3FpqGO-JHzc0xtppotnlPZktI5T0LDcald4SoqOEx0iTlAflqUXI2eycb4Ce1S2Hf20kYr8BiieAtsJ58NBcttJhWHAWEgfNWBaGPRYhGn0T_m6qrGyr9A5VCVdD3togqZApGNCztPLQB5YYlLoVqeIR_xQe5zYkaAio78bh774zUh1zQJbJumUiXayM-mCNyIw"
//
//        // new token should be set here
//        ApolloSDK.current.accessToken(newToken)

        print("REQUEST NEW TOKEN triggered")
    }
}

# AT&T Mobile SDK Developer Docs
Last updated 11/09/2022 by [Danny Mustafic](mailto:dm835j@att.com?subject=SDK Docs question

## Introduction
Detailed documentation is available on AT&T Connected Car Developer Portal.
Visit [AT&T Connected Car Developer Portal](https://myvehicle-qc.stage.att.com/developerportal-1) testing environment to register and access documentation. AT&T Apollo Mobile SDK “The SDK” is offered to automotive OEMs and App creators alike to make implementation of AT&T Connected Car connectivity management simple and straightforward. The SDK offers out-of-box functionality related to all aspects of vehicle data plan management.

Scope of the SDK is to enable Mobile (companion) apps running on user’s phone (or tablet) device, facilitated by OEM’s digital experience programs. OEM implementers shall use AT&T CVC Dev Portal to download the SDK code, documentation, read FAQs and contact dev support.

This SDK currently supports Android and iOS based apps. It allows the OEM to present data connectivity offer by AT&T in an integrated coo-branded fashion, without the need to build the AT&T functions themselves, yet offers the OEM an to ability preserve car-branded experience for their users. The SDK flows are pre-built to interface with AT&T Connected Vehicle Cloud “CVC” API which then orchestrates operations to segments of AT&T Network in order to establish and manage connectivity service in user's vehicle.

> Not in scope of the SDK are implementations that warrant the use of CVC APIs directly, at which point the integrators will need to perform integration and development of flows. Yet another option is to use existing AT&T Apollo Portal directly by the end users [myvehicle.att.com](myvehicle.att.com) which offers the same functionality as SDK, albeit AT&T branded experience.

## Getting Started
### Requesting access to Dev Portal
Go to the AT&T Connected Car [Developer Portal](https://myvehicle-qc.stage.att.com/developerportal-1). to register for access or log in to access the developer tools.

Make sure you select proper tenant. This document uses **'AcmeOEM'** in place of a tenant name, which should be replaced with a real value used in the Developer Portal.

### Requesting access to private GitHub repo (to get SDK code)
Prior to being able to get the SDK users must be given permission to access SDK Github repo. Ensure that you have proper access to the private AT&T GitHub repository. <a href="mailto:dm835j@att.com?subject=Access request for SDK Github repository&body=Hello, my company/project is (company or project name) and I need access to SDK Github repository. Please add me with email address... (your GitHub email)">Send the access request</a> to be granted access to the repository.

# Xcode for iOS version of SDK
### Installing SDK
iOS version of SDK is offered as Cocoa Pod. Prior to being able to get the SDK users must be given permission to access SDK Github repo. Ensure that you have proper access to the private AT&T GitHub repository, then follow the instructions below.

With proper Github access, ensure you have cocoapods installed then initialize a pod, configure the pod with SDK config then run the command to install SDK CocoaPod using terminal.

Steps:  

Make sure that you have cocoapods installed. From the command line (terminal), type:
`pod --version`
If you cocoapods is not installed please run the following command to install it
`sudo gem install cocoapods` (ruby gem example. Download with your package manager of choice).

After installation of cocoa pods go to the root of your Xcode project (Example herein is 'ApolloTest') and run the following command to initialize cocoapods.
`pod init`
This will create a Podfile at the root of your project. Open the Podfile with you favorite editor and add the following lines of code:
<pre>
source 'git@github.com:att-iot/ApolloMobileSDKPodSpec.git'
source 'https://github.com/CocoaPods/Specs.git'
	// Pods for ApolloTest
	 pod 'Alamofire', '~> 5.0.4'
	 pod 'ApolloMobileSDK'
</pre>

Podfile example:

	// Uncomment the next line to define a global platform for your project
	// platform :ios, '9.0'
	source 'git@github.com:att-iot/ApolloMobileSDKPodSpec.git'
	source 'https://github.com/CocoaPods/Specs.git'
	target 'ApolloTest' do
	// Comment the next line if you don't want to use dynamic frameworks
	 use_frameworks!
	// Pods for ApolloTest
	 pod 'Alamofire', '~> 5.0.4'
	 pod 'ApolloMobileSDK'
	end

Save your Podfile and open the terminal and go to the root of your project.

Run the following commands in the terminal:

	pod repo add ApolloMobileSDKPodSpec git@github.com:att-iot/ApolloMobileSDKPodSpec.git
	pod install

> NOTE: Downloading of resources will take time and terminal will not share any status. Please give it time. Corporate users may be behind a corporate firewall that my block SSH or Github access. Make sure your access is permitted.

Terminal output:

	➜  yourProject git:(main) $ pod update
	Update all pods
	Updating local specs repositories

	$ /usr/local/bin/git -C /Users/yourname/.cocoapods/repos/ApolloMobileSDKPodSpec fetch origin --progress
	  remote: Enumerating objects: 12, done.        
	  remote: Counting objects: 100% (12/12), done.        
	  remote: Compressing objects: 100% (8/8), done.        
	  remote: Total 10 (delta 3), reused 9 (delta 2), pack-reused 0        
	  From github.com:att-iot/ApolloMobileSDKPodSpec
	     1aad621..db55bc4  main       -> origin/main
	$ /usr/local/bin/git -C /Users/yourname/.cocoapods/repos/ApolloMobileSDKPodSpec rev-parse --abbrev-ref HEAD
	  main
	$ /usr/local/bin/git -C /Users/yourname/.cocoapods/repos/ApolloMobileSDKPodSpec reset --hard origin/main
	  HEAD is now at db55bc4 [Update] ApolloMobileSDK (0.2.5)
	$ /usr/local/bin/git -C /Users/yourname/.cocoapods/repos/cocoapods fetch origin --progress
	  remote: Enumerating objects: 13908, done.        
	  remote: Counting objects: 100% (9265/9265), done.        
	  remote: Compressing objects: 100% (2958/2958), done.        
	  remote: Total 13908 (delta 6517), reused 8748 (delta 6124), pack-reused 4643        
	  Receiving objects: 100% (13908/13908), 2.49 MiB | 1.22 MiB/s, done.
	  Resolving deltas: 100% (8600/8600), completed with 1331 local objects.
	  From https://github.com/CocoaPods/Specs
	     a29d1893953f..ea5982b473db  master     -> origin/master
	$ /usr/local/bin/git -C /Users/yourname/.cocoapods/repos/cocoapods rev-parse --abbrev-ref HEAD
	  master
	$ /usr/local/bin/git -C /Users/yourname/.cocoapods/repos/cocoapods reset --hard origin/master
	  Checking out files: 100% (494912/494912), done.
	  HEAD is now at ea5982b473db [Add] Protobuf 3.17.0
	Analyzing dependencies
	Downloading dependencies
	Installing ApolloMobileSDK 0.2.5 (was 0.2.2)
	Generating Pods project
	Integrating client project
	Pod installation complete! There are 2 dependencies from the Podfile and 2 total pods installed.

	[!] Automatically assigning platform `iOS` with version `14.0` on target `test` because no platform was specified. Please specify a platform for this target in your Podfile. See `https://guides.cocoapods.org/syntax/podfile.html#platform`.
	➜  yourProject git:(main)


> NOTE: Ensure that your SSH key was properly added to the Github and access is granted, prior to running the `repo add` command.

#### First Run
To initialize SDK, use this class to instantiate the SDK early in your app. We recommend initiating as soon as the needed data is available for consumption. The AttOem class uses a singleton pattern with setters. After you have set all the needed properties of the AttOem class use the .build() method to build the SDK.

> NOTE: If the .build() method is missing your custom theme is not going to work as this method instantiates the theme for the SDK to use.

Setters:
Important setters ( need to be set when initializing SDK)

| key | value | Description |
| :--- | :----: | :--- |
| .vin | String | The VIN code of Vehicle
| .tenant | String | Tenant name i.e.: AcmeOEM  
| .hostName | String | Typically Host App Name i.e: Acme Connect
| .country | AttCountry | Country code where AT&T is providing the service i.e.: US
| .accessToken | String | Access token for the API. Depending on the integration, can be JWT or OAuth v2
| .channel | AttApiChannel | Channel for the API. Set to 'simulator' to use developer portal vehicle simulator, set to 'sdk' for integration testing.
| .environment | AttApiEnv | Environment for the API. Set to sandbox for development testing using developer portal simulated vehicle and data service. Set to prod for production environment.
| .setDelegate | TestingDelegateController() | Delegate implementation for vehicleAvailability and hotspotGuide. If you wish to invoke the vehicle availability or custom function, from outside the SDK.
| .sdkDarkThemeFile | String | Dark theme implementation. This is used to set theme for dark mode.
| .sdkLightThemeFile | String | Light theme implementation. This is used to set theme for light mode.
| .setValidateSubscriptionCachingDuration | Double | Caching duration of ValidateSubscription response. Default is 15 minutes, and it can not be set to lower value than default.

Other setters:

| key | value | Description |
| :--- | :----: | :--- |
| .user | AttUser | AT&T user info sets the host app user details to prevent retyping of the data during service activation    
| .sdkThemeFile | String | SDK theme file path and name  
| .dashboardButtonFirstTitle | String | Account dashboard first button title
| .dashboardButtonSecondTitle | String | Account dashboard second button title

Example:

	ApolloSDK
	        .current
	        .tenant("AcmeOEM")
		.hostName(“AcmeOEMLink”)
	        .vin("F5C7670HONERM3128")
	        .accessToken("F5C7670HONERM3128F5C7670HONERM3128F5C7670HONERM3128F5C7670HONERM312...")
	        .user(testUser)
	        .country(.US)
	        .language(.en)
		.channel(.simulator)
	        .environment(.Sandbox)
	        .sdkDarkThemeFile("BrandedRetailSDKTheme-night", bundlePath: Bundle.main.bundlePath)
            .sdkLightThemeFile("BrandedRetailSDKTheme", bundlePath: Bundle.main.bundlePath)
	        .hotspot(.init(HotspotView()))
	        .setDelegate(TestingDelegateController())
            .setValidateSubscriptionCachingDuration(15)
	        .build()
	class TestingDelegateController: UIViewController, ApolloSDKDelegate {
	    func vinStateUpdated(vehicleAvailability: String) {
	        // do the  UI update here
	    }
	    func openHotspotSetupGuide() {
	        // do the implementation here
	    }
	}

#### ATTUSER class
This class is used when the user is directed to the Create Account screen. You can pre-set the fields: first name, last name, email and phone for the user beforehand. This is important to prevent the user from retyping their info when activating data plan.

Example:

        val testUser = RegistrationFormModel(
            firstName = "Danny",
            lastName =  "Mustafic",
            email = "danny.mustafic@att.com",
            mobileWirelessNumber = "4042029116",
            notificationLanguage = "EN",
            country = "US",
            street = "225 W Valley Blvd",
            city = "Colton",
            state = "CA",
            zipCode = "92324"
        )

#### API Environments
The API environment to be used by the SDK.

`.environment` will be either `.sandbox`, `.pvt` or `.prod`

`.sandbox` environment is used for development testing, where you can create a simulated vehicle and a data service for it, to use for testing of AT&T SDK flows without the need for real vehicles and SIMs (ICCIDs’s),

`.pvt` A pre-prod validation testing environment with real SIMs that may or may not be inside a real vehicle (or a test bench). This is optional based on the integration needs.

`.prod` are real vehicles (factory test or otherwise).

If using `.sandbox` with `.sdk` channel, you will be able to test the vehicles for which we will provide you a list of VINs. SDK channel is also used for integration testing, (OEM Host App and OEM authentication...)

When using `.prod`, this will require you to pass a real vehicle VIN that is loaded in your AT&T account.

#### The API channel

`.channel` will be either `.simulator` or `.sdk`

This identifies the configuration of product offers, and the flow thru which they are offered. It also ensures proper messaging to the user via emails – for example to avoid an issue where the user may activate a vehicle via AcmeOEM app but receives an email with instructions to login to AT&T portal to manage the vehicle. When using channel .sdk, the email will instruct the user to use Honda Link app to manage their data plan.

if using `.simulator` you will be able to create simulated vehicles in the developer portal, and test the SDK flows by passing our JWT token via SDK as.

If using `.sdk` channel, you will be able to test the OEM authentication integration, which upon onboarding to our IDP can use either a JWT or OAuth 2.0 token. A pre-loaded list of VINs in our testing environment needs to used for this type of testing.

> NOTE: For testing and development please use the Sandbox.

#### Loading AT&T Data Widget
Data widget is meant to be displayed inside native app as the starting point for SDK functions. It is self contained and will display information (connectivity status) and actions to be performed by the user. In section 'Data Plan widget' select which way you wish to implement the data widget in your app.

Here is a quick example. In [yourApp.swift ensure you have the following lines:
	import SwiftUI

	@main
	struct testApp: App {
	    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	    var body: some Scene {
	        WindowGroup {
	            ContentView()
	        }
	    }
	}

In ContentView.swift ensure you have the following lines:
This will add the AT&T Data Widget to the view.

	import SwiftUI
	import ApolloMobileSDK

	struct ContentView: View {

	    var model: AttWidgetViewModel = AttWidgetViewModel()
	    weak var navigationDelegate: AttNavigationDelegate?

	    var body: some View {
	        VStack {
	            AttWidgetRepresentable(onDashboard: false, navigationDelegate: self.navigationDelegate, model: self.model, screenType: .homePage)
	                .getRootView()
	                .padding(.horizontal, model.horizontalPadding)
	                .environmentObject(model)
	        }
	    }
	}

	struct ContentView_Previews: PreviewProvider {
	    static var previews: some View {
	        ContentView()
	    }
	}

Target test and iPhone version and build the app.
iPhone Simulator shall load with this end result. Content may vary based on vehicle status, or if you have provided proper vehicle VIN and access token. More on that in authentication section. For instance, if you see 422 error, it means that the simulated vehicle access token has expired… Simulated vehicle access token should be refreshed every 5 minutes.

![First Run iOS simulator](https://attiot.atlassian.net/wiki/spaces/APOLLO/pages/1497596246/iOS+Documentation+-+5+12+21)

#### Invoking AT&T SDK Dashboard without widget being implemented
A connectivity button with the getConnectivity function has been implemented. By clicking on the button, will display information (connectivity status) and actions to be performed by the user.

	private func getConnectivity() {
        buttonClickType = AttButtonClickType.Connectivity
        ApolloSDK.current.setDelegate(self)

        // present loader screen
        showLoader()
        let viewModel = AttWidgetViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            viewModel.getConnectivityData()
        }
	}
 
     private func getVehicleAvailability() {
        buttonClickType = AttButtonClickType.InvokeVehicleAvailability
        ApolloSDK.current.setDelegate(self)
        
        let viewModel = AttWidgetViewModel()
        viewModel.getAvailabilityData()
    }   


Inside delegate implementation you have these cases:

	                switch vehicleAvailability {
                    case "vehicleHasDataPlan":
                        // Vehicle has active data plan
                        // Load ATT Widget or ATT Dashboard
                    case "vehicleNotEligible":
                        // Vehicle is not eligible for ATT services
                        // You can decide what do you you want to show
                    case "vehicleTrialEligible":
                        // Vehicle is eligible for trial plan
                        // Load Trial Flow, ATT Widget or ATT Dashboard
                    case "vehicleNoDataPlan":
                        // Vehicle has no Data Plan
                        // Load ATT Widget or ATT Dashboard
                    case "vehicleNonTrialEligible":
                        // Vehicle is not eligible for trial (but is eligible for prepaid)
                        // Load ATT Widget or ATT Dashboard
                    case "error":
                        // Error occurred while getting vehicle availability
                        // API Failure, you can implement retry logic
                    case "unableToProcessError":
                        // API Responded with code 400 - Bad Request.
                        // This could happen if VIN is not passed and you are calling getVehicleAvailability
                        // Make sure that everything is set correctly and then retry
                    case "invalidTokenError":
                        // API Responded with code 401
                        // There is an issue with your authentication token
                    case "userNotPermittedError":
                        // API Responded with code 403
                        // This could be due to blocked traffic or it could be that user is is not using right token
                    default:
                        //
                }

Once the delegate method is called, you should reset the delegate to nil.
ApolloSDK.current.setDelegate(nil)

And you need to have these methods implemented in this way:

	private func openActiveDashboard(){
		showLoader()
		guard let navigationDelegate = navigationDelegate else { return }
		ApolloSDK.current.goToDashboard(presentationDelegate: navigationDelegate, failure: { error in })
	}
	private func openDashboard(){
		showLoader()
		guard let navigationDelegate = navigationDelegate else { return }
		ApolloSDK.current.showError(presentationDelegate: navigationDelegate, failure: { error in })
	}
	private func startTrial() {
		showLoader()
		guard let navigationDelegate = navigationDelegate else { return }
		ApolloSDK.current.startTrialFlow(presentationDelegate: navigationDelegate, failure: { error in })
	}

#### Exposing user profile for service activation
A method is exposed to the host app to allow users to pre populate their information in the data plan activation screen that will be shared with AT&T. With users consent the data is populated in the create account screen. If user chooses not to share the info, the crate account screen will be blank, at which point the user we need to enter the required information manually.

**Setting user profile info for SDK to use**

Below is an example of the method that will be exposed and needs to be called, so that the native app is able to parse the user data to AT&T SDK.

	ApolloSDK.current
	...
	.user(userInfo)

> NOTE: In case the method is not called, no user information will be provided.

Example of the model:

		public struct AttUser {
		    var firstName: String
		    var lastName:  String
		    var email:     String
		    var phone:     String
		    var address:   AttAddress
		    var language:  Country.Language
		)   
		struct AttAddress {
		    var country: Country
		    var city:    String
		    var street:  String
		    var zipCode: String
		    var state:   Country.State
		    var appartmentNumber: String
		}
		struct Country {
		    public var id: Int
		    public var code: String
		    public var label: String
		    public var languages: [Language]
		    public var states: [State]
		    public struct Language{
		        var name: String
		        var code: String
		    }
		    public struct State {
		        public var name: String
		        public var code: String
		    }
		}

Example of populated model data:

		let userInfo = AttUser(
		            firstName: "Lex",
		            lastName: "Test",
		            email: "email.com",
		            phone: "5554444333",
		            country: .US,
		            state: "CA",
		            city: "Colton",
		            street: "225 W Valley Blvd",
		            zipCode: "92324"
		)

> NOTE: If fields have no value, it means that the value was not provided by the native


#### Authentication
During development implementers can take advantage of [AT&T Connected Car Developer Portal](https://myvehicle-qc.stage.att.com/developerportal-1) where simulated vehicles can be created and SDK flows tested using sandbox and local sandbox access token for the simulated vehicle. This is define in Connected Car Vehicle Simulator section.

For production implementation the native app IDP is recommended to be used as authentication token provider. A step for onboarding of tenants, definition for token validation endpoint is not in scope of this document.

SDK requires an access token to be set when private API requests towards SDK backend (CVC) are made. If native app did not 'set' access token the SDK will request it.

Inside of ApolloSDK class, there is
`.setAuthenticationDelegate(TestingDelegateController()) `
which accepts implementation of ApolloSDKAuthenticationDelegate protocol.

Example:

	extension TestingDelegateController: ApolloSDKAuthenticationDelegate {
	    func requestNewToken() {
	        // new token should be gathered
	        let newToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2MjA3MzI2ODcsImlhdCI6MTYyMDcyNTQ4NywianRpIjoiNWY1NTVjMTAtZDkzNS00ZTYwLTg0ZDctM2ZmNjFmNjI3ZTQxIiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6NzkxZDJiZGYtNDI4OS00N2ZmLTgwZGItODBlNjJkMGU2MDg3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6ImYzM2Y3YjQ0LTgzNTktNGEyYy1iZTgxLTFlODJjMjZmNTE5MiIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6ImVsdmlzMkBtYWVzdHJhbHRlc3RpbmcubmV0In0.fKAKimYnYdRzPLXRQI9dinHgMnInxDX75Lg0qzVHy16KjWR3xaBBxRnZ7M0FuJkdIzl6avD7VBqtHcU6QYj0YlJYdReYhPJGqSlHP_ZlxPlJJ5mU3iCExypdadcnwpRHjYgj5h8tmEmb7LGeyeg3FpqGO-JHzc0xtppotnlPZktI5T0LDcald4SoqOEx0iTlAflqUXI2eycb4Ce1S2Hf20kYr8BiieAtsJ58NBcttJhWHAWEgfNWBaGPRYhGn0T_m6qrGyr9A5VCVdD3togqZApGNCztPLQB5YYlLoVqeIR_xQe5zYkaAio78bh774zUh1zQJbJumUiXayM-mCNyIw"     
		// new token should be set here
	        ApolloSDK.current.accessToken(newToken)
	    }
	}

#### Token refresh
Inside of ApolloSDK class, there is:

 	.setAuthenticationDelegate(TestingDelegateController())

which accepts implementation of ApolloSDKAuthenticationDelegate protocol.

Example:

	extension TestingDelegateController: ApolloSDKAuthenticationDelegate {
    		func requestNewToken() {
        		// new token should be gathered
        		let newToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2MjA3MzI2ODcsImlhdCI6MTYyMDcyNTQ4NywianRpIjoiNWY1NTVjMTAtZDkzNS00ZTYwLTg0ZDctM2ZmNjFmNjI3ZTQxIiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6NzkxZDJiZGYtNDI4OS00N2ZmLTgwZGItODBlNjJkMGU2MDg3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6ImYzM2Y3YjQ0LTgzNTktNGEyYy1iZTgxLTFlODJjMjZmNTE5MiIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6ImVsdmlzMkBtYWVzdHJhbHRlc3RpbmcubmV0In0.fKAKimYnYdRzPLXRQI9dinHgMnInxDX75Lg0qzVHy16KjWR3xaBBxRnZ7M0FuJkdIz					l6avD7VBqtHcU6QYj0YlJYdReYhPJGqSlHP_ZlxPlJJ5mU3iCExypdadcnwpRHjYgj5h8tmEmb7LGeyeg3FpqGO-JHzc0xtppotnlPZktI5T0LDcald4SoqOEx0iTlAflqUXI2eycb4Ce1S2Hf20kYr8BiieAtsJ58NBcttJhWHAWEgfNWBaGPRYhGn0T_m6qrGyr9A5VCVdD3togqZApGNCztPLQB5YYlLoVqeIR_xQe5zYkaAio78bh774zUh1zQJbJumUiXayM-mCNyIw"

        		// new token should be set here
        		ApolloSDK.current.accessToken(newToken)
    		}
	}


Method `“requestNewToken()“` will be called in case if server returns 401 code for any request. In that case new token should be set. Example can be found at AppDelegate.swift file.


# SDK Features
## Data Plan widget
AT&T SDK offers a widget box that can be placed on host app screens to show the status of the vehicle data plan with actions to purchase data or see connectivity dashboard (the main SDK screen). Widget can be shown at all times or hidden based on conditions defined in 'deferring loading of SDK widget'. There are two ways the widget can be utilized. We suggest the screen containing the widget use 'UITableView' to allow the UI to conform to the height of the widget automatically, based on the content inside the widget.
### Implementing widget using UIKit and UITableView
Placing the widget using UITableView makes the display height dynamic based on the content within the widget.

Example:

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
            // set the values here
            ApolloSDK.current.vin("4D83028HONERM4415")
            ApolloSDK.current.accessToken("eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2MjA3MzI2ODcsImlhdCI6MTYyMDcyNTQ4NywianRpIjoiNWY1NTVjMTAtZDkzNS00ZTYwLTg0ZDctM2ZmNjFmNjI3ZTQxIiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6NzkxZDJiZGYtNDI4OS00N2ZmLTgwZGItODBlNjJkMGU2MDg3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6ImYzM2Y3YjQ0LTgzNTktNGEyYy1iZTgxLTFlODJjMjZmNTE5MiIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6ImVsdmlzMkBtYWVzdHJhbHRlc3RpbmcubmV0In0.fKAKimYnYdRzPLXRQI9dinHgMnInxDX75Lg0qzVHy16KjWR3xaBBxRnZ7M0FuJkdIzl6avD7VBqtHcU6QYj0YlJYdReYhPJGqSlHP_ZlxPlJJ5mU3iCExypdadcnwpRHjYgj5h8tmEmb7LGeyeg3FpqGO-JHzc0xtppotnlPZktI5T0LDcald4SoqOEx0iTlAflqUXI2eycb4Ce1S2Hf20kYr8BiieAtsJ58NBcttJhWHAWEgfNWBaGPRYhGn0T_m6qrGyr9A5VCVdD3togqZApGNCztPLQB5YYlLoVqeIR_xQe5zYkaAio78bh774zUh1zQJbJumUiXayM-mCNyIw")

            // reload the widget
            reloadWidget()
        }
    }

    extension TestTableViewController: ApolloSDKDelegate {
        func vinStateUpdated(vehicleAvailability: String) {

            // delegate method which takes information from loadSubscriptions about vehicle availability and in case if it returns error or vehicleNotEligible, widget will be hidden

            switch vehicleAvailability {
                case "error":
                    widgetHidden = true
                case "vehicleNotEligible":
                    widgetHidden = true
                default:
                    widgetHidden = false
            }
            tableView.reloadData()
        }

        // not needed
        func openHotspotSetupGuide() {}
    }

    extension TestTableViewController: AttWidgetViewModelDelegate {

        // after loading subscriptions, height of a widget should be refreshed depending on the vehicle status
        func onWidgetHeightUpdated() {
            self.tableView.reloadData()
        }
    }

    // navigation delegate implementation used for navigating from AttWidgetCell(View) to some of the flows
    extension TestTableViewController: AttNavigationDelegate {

        func present(viewController: UIViewController) {
            self.present(viewController, animated: true, completion: nil)
        }

        func push(viewController: UIViewController) {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }



> Note: In TestTableViewController there is a method:

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            widgetViewModel.setViewActive()
            widgetViewModel.loadData()
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            widgetViewModel.setViewInactive()
        }


this method gets called every time when user comes back to this screen.
Example: App navigates to Trial flow, but user decides to close it. This method will be triggered as well as widget refresh.

### Implementing widget using SwiftUI
For the purpose of making AttWidget with dynamic height, we would not use AttWidgetRepresentable directly, rather its rootView. Navigation to the flows, stays the same.

Example:

    struct RemoteView: View {

        var model: AttWidgetViewModel
        var carImage: String
        weak var navigationDelegate: AttNavigationDelegate?

        var body: some View {
            ScrollView(showsIndicators: false) {
                Spacer().frame(height: 32)

                AttWidgetRepresentable(onDashboard: false, navigationDelegate: self.navigationDelegate, model: self.model).getRootView()
                    .padding(.horizontal, model.horizontalPadding)
                    .environmentObject(model)

                Image(carImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                createInvokeButtons()

                HStack(spacing: 80) {
                    ItemView(imageName: "lock.fill", title: "lock".localized())
                    ItemView(imageName: "lock.open.fill", title: "unlock".localized())
                }
                Spacer().frame(height: 30).background(Color.red)

                Divider().padding([.leading, .trailing], 20)

                HStack(spacing: 80) {
                    ItemView(imageName: "arrow.clockwise", title: "start".localized())
                    ItemView(imageName: "arrow.clockwise", title: "cancel_service_modal_cancel".localized(), additionalImage: true, additionalImageName: "xmark")
                }
                Spacer().frame(height: 30)

                Divider().padding([.leading, .trailing], 20)
            }
            .frame(maxWidth: .infinity)
        }
     }


Additionally:
We have added `.setViewActive()` so it could stop viewModel from any changes/loading if AttWidget is not currently presented on the screen. It is very important to set this flag onAppear and onDissapear of parent View.


`NavigationDelegate` implementation should be done in the parent view controller of this view so it could push/present to the flows for trial/prepaid/special offer…

In RemoteView, body implementation, there is:

	AttWidgetRepresentable(onDashboard: false, navigationDelegate: self.navigationDelegate, model: self.model).getRootView()
		.padding(.horizontal, model.horizontalPadding)
		.environmentObject(model)

This part of code creates a widget on the screen. It will be called every time user comes back or navigates back to this screen.
Example: App navigates to purchase flow, but user decides to close it. This method will reload a widget.

### Deferring loading of SDK widget
You have choice to decide to load the AT&T data widget based upon these cases defined in the view, You can toggle T/F based on your needs. For example if you do not want to allow widget to load for vehicles that don't have Wi-Fi capabilities, you can set it like this:

	 case "vehicleNotEligible":
	             widgetHidden = true   
Options:

| key | value | Description |
| :--- | :----: | :--- |
| error | T/F	| Error occurred while loading SDK, widget UI should not load |
| vehicleNotEligible | T/F | Vehicle is not eligible for wi-fi service. AT&T widget and SDK functions are not visible to the user |
| vehicleTrialEligible| T/F | Vehicle is eligible for a trial data plan. |
| vehicleNonTrialEligible | T/F | Vehicle is eligible for retail data plan or trial has been used, or trial is otherwise not available (second owner scenario) |
| vehicleHasDataPlan | T/F | Vehicle has a data plan, either trail or retail |
| unableToProcessError | This error could happen if VIN is not passed and you are calling getVehicleAvailability |
| invalidTokenError | There is an issue with your authentication token |
| userNotPermittedError | This error could be due to blocked traffic or it could be that user is is not using the right token |
| 'default' | T/F | Default state of AT&T Data widget, you may chose to hide and only allow it to load if one condition above is met |

## Invoke Buy Flow Class
If you want to invoke a trial flow form outside SDK screens (for example if running a promotion inside the app, and the SDK via vehicle status check returned `vehicleTrialEligible = true` or if you want to load data plans screen from outside of the SDK dashboard.
In ApolloSDK.current() we have two functions:

	func startTrialFlow(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ())
It takes two parameters. First for `UIViewController` on which the flow would be presented, and second one in case of some preloading error for trial plan happens.

	func startPrepaidFlow(presentationDelegate: AttNavigationDelegate, failure: @escaping (Error) -> ())
It takes two parameters. First for `UIViewController` on which the flow would be presented, and second one in case of some preloading error for current user.

Usage:

	private func startTrial() {
		guard let navigationDelegate = navigationDelegate else { return }
		ApolloSDK.current.startTrialFlow(presentationDelegate: navigationDelegate, failure: { error in })
	}

	private func startPurchaseWifi() {
		guard let navigationDelegate = navigationDelegate else { return }
		ApolloSDK.current.startPrepaidFlow(presentationDelegate: navigationDelegate, failure: { error in })
	}

For this purpose, we would need to provide navigationDelegate implementation defined like this:

	public protocol AttNavigationDelegate: class {
	    func present(viewController: UIViewController)
	    func push(viewController: UIViewController)
	}
In parent view Controller we should control and define navigation like the example below:

	extension TestTableViewController: AttNavigationDelegate {
	    func present(viewController: UIViewController) {
	        self.present(viewController, animated: true, completion: nil)
	    }
	    func push(viewController: UIViewController) {
	        self.navigationController?.pushViewController(viewController, animated: true)
	    }
	}

## Custom button action within SDK
### Custom Button - Return to OEM Dashboard
The “Return to OEM dashboard” is customizable. The text of the button will be configurable (see below):

Example:

	ApolloSDK.current
  		.dashboardButtonFirstTitle("Return to OEM dashboard")

### Custom Button WiFi Hotspot Setup Guide

It is possible to invoke a native screen to display Hotspot setup guide. In ApolloSDK there is a method which will define if "Hotspot wifi setup guide" button should be shown or not.

	public func setIsHotspotSetupGuideButtonVisible(_ visible: Bool) -> ApolloSDK

Example of Usage:

	ApolloSDK
        .current
        .setIsHotspotSetupGuideButtonVisible(false)
        .build()

### Return to OEM Dashboard Button Listener
Implemented listener that the OEM application can listen to know that the SDK is closed by clicking on "Return to OEM Dashboard".

	func exitFromSDKListener(){
		// do the implementation here
	}

## Switching vehicle context
As native apps are supporting multiple vehicles under one user account, In RemoteView.swift there is an example of switchVehicle function

    private func switchVehicleExample() {
        // set the values here
        ApolloSDK
            .current
            .vin("9361354HONERM1951")
            .accessToken("eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2NTk3MTQ5MjIsImlhdCI6MTY1OTcwNzcyMiwianRpIjoiNzFmNTY0MTYtYWJkMi00MmVlLWJlZDgtZjkwZmYyZDhjZDg2IiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6NWQyYWU3OTktMDljNi00YjYyLTkxY2ItNjQ3OGU2NjIyNjE1IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6IjM2N2YzMzJkLTlkNjUtNDJiOC1hNzgwLWJiY2RmYWY3ZGY2YSIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6Im5lcm1pbnNhQG1hZXN0cmFsc29sdXRpb25zLmNvbSJ9.ZDkYjSTc03aZPnH6gAtPLC_LeGMcUWzT2gdNCgl5YyGStKP6ow9AakM7TOam4aiaBAxN0ci5gFc0Rz_C7JgzYTuB7jbNtruPbC4T1ij9G-buvKbSKzPmQsh4FKUtJYtxZCOiiQmtOoKx-ePDMWGJ3kwmtGpUmYKmAgs2QOOof0K7P61Pc62-MJaPMISqQdsh-k5yAHWVJKfvaOTztQPCvWRFhw3IsFA_XfDkv_DcQ6dqOwnyJ0rk7GRN65_KqzOyP2PyJYGrJC0b7AeTGHj__KXDZvUnuXZbDqvfdq9pgBawjca1U1CO_w9vfxdF-CY1-NCA5JiX1DoniRkmueVv1w")
            .build()

        // reload the widget
        model.setViewActive()
        model.loadData()
    }

On button click for switch vehicle, this function will be called.
In order to test this, you need to set the values for VIN and accessToken like described.

For tableView, approach is pretty the same:

    // This method is not used but you can use it to make a full reload of a widget if needed
    private func reloadWidget() {
        widgetController = AttWidgetController(isOnDashboard: false, navigationDelegate: self, model: self.widgetViewModel, screenType: .homePage)
        tableView.reloadData()
    }

    private func switchVin() {
        // set the values here
        ApolloSDK.current.vin("4D83028HONERM4415")
        ApolloSDK.current.accessToken("eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIyaG5uclFjQW5ieTRLb3FUWV9FM0k3LTRiTWxnZjZjb0gzazJWWjg4T2ZzIn0.eyJleHAiOjE2MjA3MzI2ODcsImlhdCI6MTYyMDcyNTQ4NywianRpIjoiNWY1NTVjMTAtZDkzNS00ZTYwLTg0ZDctM2ZmNjFmNjI3ZTQxIiwiaXNzIjoiaHR0cHM6Ly9teXZlaGljbGUtcWMuc3RhZ2UuYXR0LmNvbS9hdXRoL3JlYWxtcy9pb3RhLWN2Yy1vcGVuaWQtcmVhbG0iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjo5NGE0NDY2OC05YzZmLTRlMjEtOWQ5NC1hMTk2NjI5YjM4ZDU6NzkxZDJiZGYtNDI4OS00N2ZmLTgwZGItODBlNjJkMGU2MDg3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaW90LWN2Yy1vcGVuaWQtY2xpZW50LXFjIiwic2Vzc2lvbl9zdGF0ZSI6ImYzM2Y3YjQ0LTgzNTktNGEyYy1iZTgxLTFlODJjMjZmNTE5MiIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoib3BlbmlkIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJlbWFpbCI6ImVsdmlzMkBtYWVzdHJhbHRlc3RpbmcubmV0In0.fKAKimYnYdRzPLXRQI9dinHgMnInxDX75Lg0qzVHy16KjWR3xaBBxRnZ7M0FuJkdIzl6avD7VBqtHcU6QYj0YlJYdReYhPJGqSlHP_ZlxPlJJ5mU3iCExypdadcnwpRHjYgj5h8tmEmb7LGeyeg3FpqGO-JHzc0xtppotnlPZktI5T0LDcald4SoqOEx0iTlAflqUXI2eycb4Ce1S2Hf20kYr8BiieAtsJ58NBcttJhWHAWEgfNWBaGPRYhGn0T_m6qrGyr9A5VCVdD3togqZApGNCztPLQB5YYlLoVqeIR_xQe5zYkaAio78bh774zUh1zQJbJumUiXayM-mCNyIw")

        // reload the widget
        reloadWidget()
    }

## UI Themes
### Light and Dark mode

SDK supports Light (day) and Dark (night) mode. You will use your “BrandedRetailSDKTheme-night” for dark mode and “BrandedRetailSDKTheme” to define your light theme.

Example:
SDK theme elements are name-spaced such as `attSDKbackgroundColor` this identifies the color set for SDK screen background. other element examples defined bellow in "Item Descriptions" section.

Example to define night (dark) theme `BrandedRetailSDKTheme-night.plist`:

	<key>primaryColor</key>
	<string>"007cc3"</string>
	<key>attSDKPrimaryButtonTextColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKButtonDisabledTextColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKSecondaryButtonBackgroundColor</key>
	<string>"00ff001C"</string>
	<key>attSDKSecondaryButtonTextColor</key>
	<string>"D2D2D2"</string>
	<key>attSDKSecondaryButtonBorderWidth</key>
	<real>1.5</real>
	<key>attSDKSecondaryButtonBorderColor</key>
	<string>"D2D2D2"</string>
	<key>attSDKButtonCurvature</key>
	<integer>2</integer>
	<key>attSDKTextPrimaryColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKTextSecondaryColor</key>
	<string>"dbdee2"</string>
	<key>attSDKTextColorHint</key>
	<string>"787878"</string>
	<key>attSDKSelectedProductBackgroundColor</key>
	<string>"A5DDF5"</string>
	<key>attSDKDashboardWidgetBackgroundColor</key>
	<string>"1C2329"</string>
	<key>attSDKDashboardWidgetBorderColor</key>
	<string>"1C2329"</string>
	<key>attSDKBlockBackgroundColor</key>
	<string>"1C2329"</string>
	<key>attSDKBackgroundColor</key>
	<string>"000000"</string>
	<key>attSDKButtonHeight</key>
	<integer>46</integer>
	<key>attSDKPillButtonHeight</key>
	<integer>36</integer>
	<key>attSDKDashboardCardCornerRadius</key>
	<integer>5</integer>
	<key>attSDKDashboardCardShadowElevation</key>
	<real>1.5</real>
	<key>attSDKWidgetBackgroundColor</key>
	<string>"1C2329"</string>
	<key>attSDKWidgetBorderColor</key>
	<string>"1c2329"</string>
	<key>attSDKWidgetCardCornerRadius</key>
	<integer>2</integer>
	<key>attSDKWidgetCardShadowElevation</key>
	<real>1.5</real>
	<key>attSDKWidgetButtonCurvature</key>
	<integer>24</integer>
	<key>attSDKWidgetButtonHeight</key>
	<integer>46</integer>
	<key>attSDKWidgetTextPrimaryColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKWidgetTextSecondaryColor</key>
	<string>"dbdee2"</string>
	<key>attSDKWidgetPrimaryButtonColor</key>
	<string>"007cc3"</string>
	<key>attSDKWidgetPrimaryButtonTextColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKWidgetSecondaryButtonBackgroundColor</key>
	<string>"00ff001C"</string>
	<key>attSDKWidgetSecondaryButtonTextColor</key>
	<string>"D2D2D2"</string>
	<key>attSDKWidgetSecondaryButtonBorderWidth</key>
	<real>1.5</real>
	<key>attSDKWidgetSecondaryButtonBorderColor</key>
	<string>"D2D2D2"</string>
	<key>attSDKButtonDisabledBackgroundColor</key>
	<string>"C7CCCF"</string>
    <key>attSDKDashboardHeaderBackgroundColor</key>
    <string>"1C2329"</string>  
    <key>attSDKDashboardBackgroundColor</key>
    <string>"000000"</string>   

Example to define light theme `BrandedRetailSDKTheme.plist`:

	<key>primaryColor</key>
	<string>"007cc3"</string>
	<key>attSDKPrimaryButtonTextColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKButtonDisabledTextColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKSecondaryButtonBackgroundColor</key>
	<string>"00ff001C"</string>
	<key>attSDKSecondaryButtonTextColor</key>
	<string>"D2D2D2"</string>
	<key>attSDKSecondaryButtonBorderWidth</key>
	<real>1.5</real>
	<key>attSDKSecondaryButtonBorderColor</key>
	<string>"D2D2D2"</string>
	<key>attSDKButtonCurvature</key>
	<integer>2</integer>
	<key>attSDKTextPrimaryColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKTextSecondaryColor</key>
	<string>"dbdee2"</string>
	<key>attSDKTextColorHint</key>
	<string>"a9a9a9"</string>
	<key>attSDKSelectedProductBackgroundColor</key>
	<string>"A5DDF5"</string>
	<key>attSDKDashboardWidgetBackgroundColor</key>
	<string>"1C2329"</string>
	<key>attSDKDashboardWidgetBorderColor</key>
	<string>"1C2329"</string>
	<key>attSDKBlockBackgroundColor</key>
	<string>"1C2329"</string>
	<key>attSDKBackgroundColor</key>
	<string>"000000"</string>
	<key>attSDKButtonHeight</key>
	<integer>46</integer>
	<key>attSDKPillButtonHeight</key>
	<integer>36</integer>
	<key>attSDKDashboardCardCornerRadius</key>
	<integer>5</integer>
	<key>attSDKDashboardCardShadowElevation</key>
	<real>1.5</real>
	<key>attSDKWidgetBackgroundColor</key>
	<string>"1C2329"</string>
	<key>attSDKWidgetBorderColor</key>
	<string>"1c2329"</string>
	<key>attSDKWidgetCardCornerRadius</key>
	<integer>2</integer>
	<key>attSDKWidgetCardShadowElevation</key>
	<real>1.5</real>
	<key>attSDKWidgetButtonCurvature</key>
	<integer>24</integer>
	<key>attSDKWidgetButtonHeight</key>
	<integer>46</integer>
	<key>attSDKWidgetTextPrimaryColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKWidgetTextSecondaryColor</key>
	<string>"dbdee2"</string>
	<key>attSDKWidgetPrimaryButtonColor</key>
	<string>"0057B8"</string>
	<key>attSDKWidgetPrimaryButtonTextColor</key>
	<string>"FFFFFF"</string>
	<key>attSDKWidgetSecondaryButtonBackgroundColor</key>
	<string>"00ff001C"</string>
	<key>attSDKWidgetSecondaryButtonTextColor</key>
	<string>"D2D2D2"</string>
	<key>attSDKWidgetSecondaryButtonBorderWidth</key>
	<real>1.5</real>
	<key>attSDKWidgetSecondaryButtonBorderColor</key>
	<string>"D2D2D2"</string>
	<key>attSDKButtonDisabledBackgroundColor</key>
	<string>"C7CCCF"</string>
    <key>attSDKDashboardHeaderBackgroundColor</key>
    <string>"FFFFFF"</string>
    <key>attSDKDashboardBackgroundColor</key>
    <string>"e5e5e5"</string>  
    
### NOTE
In addition to make the app work consistently for hot swap change of dark/light mode, you should add this part in `AppDelegate.swift` class:

    func applicationWillEnterForeground(_ application: UIApplication) {
            // This will ensure that theme change won't break UI. It will stay consistent until new start of the app.
            if (AppTheme.checkIsDarkTheme()) {
                window!.overrideUserInterfaceStyle = .dark
            } else {
                window!.overrideUserInterfaceStyle = .light
            }

            ApolloSDK.current.build()
    }

### Item Descriptions

| key | Description |
| :--- | :--- |
| primaryColor | Main color [ Primary button color (when enabled), Step indicators (horizontal lines), Step name, Checkboxes, Switches, Links, Accordion arrows (except on WarnerMedia), Close button “X” on dialogs ]|
| attSDKPrimaryButtonTextColor | Text color of primary button|
| attSDKButtonDisabledBackgroundColor | Background color of button when it is in disabled state|
| attSDKButtonDisabledTextColor | Text color of button when it is in disabled state|
| attSDKSecondaryButtonBackgroundColor | Secondary button background color (default is transparent with defined border)|
| attSDKSecondaryButtonTextColor | Text color of secondary button|
| attSDKSecondaryButtonBorderWidth | Width (thickness) of the border around secondary button|
| attSDKSecondaryButtonBorderColor | Color of secondary button border|
| attSDKButtonCurvature | Curvature of buttons|
| attSDKTextPrimaryColor | Primary text color used in SDK, Back arrow on dashboard, “X” button on payment screens|
| attSDKTextSecondaryColor | Secondary text color used in SDK|
| attSDKTextColorHint | Text color of placeholder hint|
| attSDKSelectedProductBackgroundColor | On prepaid products list, background for selected item|
| attSDKDashboardWidgetBackgroundColor | Background color of widget and other cards which are present on Dashboard|
| attSDKDashboardWidgetBorderColor | Border color of widget card (present only in dark mode)|
| attSDKBlockBackgroundColor | Background color of alerts and popups (Cancel Subscription and Data Share Consent)|
| attSDKBackgroundColor | Background color of screens through any SDK flow|
| attSDKButtonHeight | Button height of all buttons in SDK except “Change Plan” on Transaction Summary and “Purchase” on Products screen.|
| attSDKPillButtonHeight | Button height of “Change Plan” and “Purchase”|
| attSDKDashboardCardCornerRadius | Corner radious of all cards which are present on ATT Dashboard|
| attSDKDashboardCardShadowElevation |  Shadow around cards on ATT Dashboard (Set to 0dp to disable shadow)|
| attSDKDashboardHeaderBackgroundColor | Background color of the header navigation bar|

SDK Widget (which will be present in OEM app) configurations

| key | Description |
| :--- | :--- |
| attSDKWidgetBackgroundColor | Background color of widget|
| attSDKWidgetBorderColor | Border color of widget card|
| attSDKWidgetCardCornerRadius | Corner radious of widget|
| attSDKWidgetCardShadowElevation | Shadow around widget (Set to 0dp to disable shadow)|
| attSDKWidgetButtonCurvature | Curvature of widget buttons|
| attSDKWidgetButtonHeight | Button height of widget buttons|
| attSDKWidgetTextPrimaryColor | Primary text color used in widget|
| attSDKWidgetTextSecondaryColor | Secondary text color used in widget|
| attSDKWidgetPrimaryButtonColor | Primary button color of widget|
| attSDKWidgetPrimaryButtonTextColor | Primary button text color of widget|
| attSDKWidgetSecondaryButtonBackgroundColor | Secondary button bacground color of widget|
| attSDKWidgetSecondaryButtonTextColor | Secondary button text color of widget|
| attSDKWidgetSecondaryButtonBorderWidth | Secondary button border width (thickness) of widget|
| attSDKWidgetSecondaryButtonBorderColor | Secondary button border color|

## Localization
SDK is translated to AT&T language and cultures by default. Those are EN-US, ES-MX, FR-CA. SDK will make an attempt to display the OS user language and if one of the supported, it will display the content accordingly. Else it will default to EN-US.

## SDK Developer Tools
Developers can take advantage of AT&T Connected Car Developer Portal during development and integration. For purposes of development, and integration testing, the Developer Portal offers the ability to create simulated vehicles that can be used to step through the available flows without impacting real vehicles or connectivity services.

## Connected Car Developer Portal
This document, and SDK downloads are available on AT&T Connected Car Developer Portal. Visit [AT&T Connected Car Developer Portal](https://myvehicle-qc.stage.att.com/developerportal-1) testing environment to register and access the artifacts.
## SDK Documentation
This document and other assets are available in Developer Portal.
## Connected Car Vehicle Simulator
The simulated vehicles are enabled using local authentication tokens exposed via this developer portal. To generate an auth token, first a simulated vehicle needs to be created.

> Simulated vehicles auth token expire after 5 minutes, and can be re-generated via this portal.

### Create a simulated vehicle
Dashboard > Create New Vehicle
Fill out the information using dropdown menus. You do not need to change randomly generated data in the text fields. Select Plan Configuration desired for the vehicle. Provide real email address in order to receive email notifications that are part of the test flows to simulate communication the user would receive. Emails will come from an odd email address (att-services@emailff.att-mail.com) that may end up spam folder.

Click Create Vehicle

![Click Create Vehicle](https://attiot.atlassian.net/wiki/spaces/APOLLO/pages/1139933187/Dev+Portal+Authentication)

### Use simulated vehicle
Dashboard > Vehicle
Clicking on the vehicle you created in the previous step, you can see the details of the vehicle connectivity along with randomly generated vehicle data.

![Use simulated vehicle](https://attiot.atlassian.net/wiki/spaces/APOLLO/pages/1139933187/Dev+Portal+Authentication)

If the vehicle data plan has been activated, you will have an option to simulate data usage (by adding numerical value), you can set the plan expiration date, or cancel the data plan to simulate different scenarios and connectivity status.

![If the vehicle data plan has been activated](https://attiot.atlassian.net/wiki/spaces/APOLLO/pages/1139933187/Dev+Portal+Authentication)

### Access token
At the bottom of the vehicle screen is JWT token to use when making requests via SDK or API to interact with the vehicle connectivity service. Simulated vehicles auth token expire after 5 minutes, and can be re-generated there.

![JWT token to use when making requests via SDK](https://attiot.atlassian.net/wiki/spaces/APOLLO/pages/1139933187/Dev+Portal+Authentication)

### Using the simulated vehicle via SDK
Follow the SDK or API instructions but generally, you need to ‘set’ the vehicle in AppDelegate in order to make private API request. See SDK Docs and Example App. Key thing is to set setEnvironment to .Sandbox to target developer environment. This will be set to Prod for production API.

Other setters required are:

.setTenant .setVin .setCountry .setLanguage along with accessToken generated via developer portal for the simulated vehicle.

### Toggle vehicle connectivity state or data usage
For the vehicle created above on its page in Developer portal, you can change data plan parameters, and see them affect the SDK functions inside your app. You can simulate data usage, plan expiration, different eligibility states, stacking of plans, etc.

If you need to simulate the buy-flow, [request a dummy credit card](mailto:dm835j@att.com?subject=Need a dummy CC for SDK Simulator)


## Updating SDK
`$ pod update`

:-)

## Developer Support
OEMs and integrators having issues needing developer support shall use Developer Portal to request help.

### Steps
- Log in to developer portal (should be prod URL)
- Locate the self-help FAQ section to look for a Q/A on the issue observed.
If unsuccessful:
- Click on Help icon in the left nav, and select technical help tab

![Technical help tab](https://attiot.atlassian.net/wiki/spaces/APOLLO/pages/838369285/Contacting+Developer+Support)

### Requesting SDK developer help
- Click ‘send an email’
- Put “SDK help needed” in the subject line.
- Provide details of the issue

### Resulting action
- AT&T will receive a notification and respond with resolution within 2 days.

### Resolution may include:
- Immediate fix/resolution with ETA for delivery, along with steps to take to apply resolution
- Inviting the requested to join screen-sharing session to triage an issue (a meeting)
- Creation of trouble ticket and an invitation for the requested to join Jira portal to track issue resolution and get updates on the ticket.

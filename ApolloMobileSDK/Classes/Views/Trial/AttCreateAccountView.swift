//  AccountFormView.swift
//  ATTORMRetailSDK
//
//  Created by Shak4l on 16/12/2020.

import SwiftUI

struct AttCreateAccountView: View {
    
    // - State
    @Environment(\.presentationMode)
    private var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject
    private var trialModel: AttTransactionSummaryModel
    
    @ObservedObject
    private var model = AttCreateAccountModel()
    
    // - Properties
    private var product: AttProduct
    private var onNext:  () -> Void
    private var onExit:  () -> Void
    private var onShowStepper: (Bool) -> Void
    
    // - Init
    init(user: AttUser,
         product: AttProduct,
         onNext: @escaping () -> Void = { },
         onExit: @escaping () -> Void = { },
         onPresentDialogHandler: @escaping ( _ replaceAddress: @escaping (AttAddress) -> (), _ addresses: [AttAddress]) -> Void = { _,_  in },
         onShowStepper: @escaping (Bool) -> Void = { _ in }) {
        
        self.onExit = onExit
        self.onNext = onNext
        self.onShowStepper = onShowStepper
        self.product = product
        self.model.user = user
        
        self.model.presentAddressDialog = onPresentDialogHandler
    }
    
    // - Actionsm
    private func handleSubmit() {
        model.pristine = false
        model.validate(forOnSubmit: true)
        guard model.errors.isEmpty else { return }
        self.onShowStepper(true)
        model.validateAddress { isValid in
            
            guard isValid else { return }
            self.trialModel.user = model.user
            ApolloSDK.current.country(AttCountryType(rawValue: model.user.address.country.code)!)
            onNext()
        }
    }
    
    private func onExiting() {
        presentationMode.wrappedValue.dismiss()
        onExit()
    }
    
    // - Body
    public var body: some View {
        ZStack {
            
            AttAppTheme.attSDKBackgroundColor
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    Text("createAccount_form_customer_details".localized().uppercased())
                        .bold()
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.top, 16)
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    
                    AttInputField(
                        value: $model.user.firstName,
                        label: "createAccount_form_first_name".localized(),
                        placeholder: "John",
                        submitError: model.errors["submit_firstName"],
                        error: model.errors["firstName"],
                        textType: .givenName
                    )
                    
                    AttInputField(
                        value: $model.user.lastName,
                        label: "createAccount_form_last_name".localized(),
                        placeholder: "Doe",
                        submitError: model.errors["submit_lastName"],
                        error: model.errors["lastName"],
                        textType: .familyName
                    )
                    
                    AttInputField(
                        value: $model.user.email,
                        label: "createAccount_form_email".localized(),
                        placeholder: "johndoe@example.com",
                        submitError: model.errors["submit_email"],
                        error: model.errors["email"],
                        textType: .emailAddress,
                        keyType: .emailAddress,
                        disabled: true
                    )
                    
                    AttInputField(
                        value: $model.user.phone,
                        label: "createAccount_form_mobile_wireless_number".localized(),
                        placeholder: "0123456789",
                        submitError: model.errors["submit_phone"],
                        error: model.errors["phone"],
                        textType: .telephoneNumber,
                        keyType: .numberPad,
                        textLimit: 10
                    )
                    
                    AttPickerField<AttCountry.Language>(
                        value: $model.user.language,
                        label: "createAccount_form_notification_language".localized(),
                        options: model.languages,
                        placeholder: "Languages",
                        nameKey: \.name,
                        error: model.errors["language"],
                        submitError: model.errors["submit_language"]
                    )
                }.padding(.horizontal, 14)
                
                VStack(spacing: 16) {
                    Text("createAccount_form_address".localized().uppercased())
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    
                    AttPickerField<AttCountry>(
                        value: $model.user.address.country,
                        label: "createAccount_form_country".localized(),
                        options: model.countries,
                        placeholder: "country_placeholder".localized(),
                        nameKey: \.code,
                        error: model.errors["country"],
                        submitError: model.errors["submit_country"]
                    ).padding(.bottom, 4)
                    
                    AttInputField(
                        value: $model.user.address.street,
                        label: "createAccount_form_street".localized(),
                        placeholder: "123 N Street",
                        submitError: model.errors["submit_street"],
                        error: model.errors["street"]
                    )
                    
                    AttInputField(
                        value: $model.user.address.appartmentNumber,
                        label: "createAccount_form_apt_suite_other".localized(),
                        placeholder: "optional".localized(),
                        submitError: model.errors["submit_appartmant"],
                        error: model.errors["appartmant"]
                    )
                    
                    AttInputField(
                        value: $model.user.address.city,
                        label: "createAccount_form_city".localized(),
                        placeholder: "city".localized(),
                        submitError: model.errors["submit_city"],
                        error: model.errors["city"]
                    )
                    
                    AttInputField(
                        value: $model.user.address.zipCode,
                        label: model.user.address.country.code == "US" ? "createAccount_form_zip_code".localized() : "createAccount_form_postal_code".localized(),
                        placeholder: model.user.address.country.code == "US" ? "zip_code".localized() : "postal_code".localized(),
                        submitError: model.errors["submit_zipCode"],
                        error: model.errors["zipCode"],
                        textType: .postalCode,
                        keyType: model.user.address.country.code == "US" ? .numberPad : .none,
                        uppercased: true,
                        textLimit: model.user.address.country.code == "US" ? 5 : 6
                    )
                    
                    AttPickerField<AttCountry.State>(
                        value: $model.user.address.state,
                        label: model.user.address.country.code == "US" ? "state_label".localized() : "createAccount_form_province".localized(),
                        options: model.states,
                        placeholder: model.user.address.country.code == "US" ? "state".localized() : "province".localized(),
                        nameKey: \.code,
                        error: model.errors["state"],
                        submitError: model.errors["submit_state"]
                    )
                    
                    Text("all_fields_are_required".localized())
                        .font(.custom(ApolloSDK.current.getMediumFont(), size: 11))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                }
                .padding(.horizontal, 14)
                
                Spacer().frame(height: 20)
                
                if model.showContact {
                    Section() {
                        Text("transaction_summary_trial_error_have_questions".localized())
                            .font(.custom(.medium, size: 14))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Text("transaction_summary_trial_error_please_contact_support".localized())
                            .font(.custom(.regular, size: 11))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                        
                        Spacer().frame(height: 8)
                        
                        Button("1 (866) 595-0020") {
                            let number = "tel://18665950020"
                            guard let url = URL(string: number) else { return }
                            UIApplication.shared.open(url)
                        }
                        .font(.custom(.bold, size: 15))
                        .foregroundColor(AttAppTheme.primaryColor)
                        
                        Spacer().frame(height: 32)
                    }
                }
                
                Section() {
                    
                    Button("createAccount_form_continue".localized(), action: handleSubmit)
                        .buttonStyle(AttPrimaryButtonStyle())
                        .disabled(!model.errors.isEmpty && !model.pristine)
                    
                    Spacer().frame(height: 12)
                    
                    Button("createAccount_form_back".localized(), action: onExiting)
                        .buttonStyle(AttSecondaryButtonStyle())
                }
                .padding(.horizontal, 14)
                
                Spacer().frame(height: 16)
            }
            .navigationBarHidden(true)
            .background(AttAppTheme.attSDKBackgroundColor)
//            .disabled(model.isPosting)
            
            if model.isPosting {
                ZStack {
                    Color.black.opacity(0.01).edgesIgnoringSafeArea(.all)
                    AttActivityIndicator()
                }.background(AttAppTheme.attSDKBackgroundColor)
            }
            
            if model.showError {
                AttErrorView(
                    showContact: true,
                    retryTitle: "dashboard_retry".localized(),
                    exitTitle: "createAccount_form_back".localized(),
                    onRetry: {
                        self.model.showError = false
                        self.handleSubmit()
                    },
                    onExit: {self.model.showError = false},
                    contentView: Text("dashboard_error_something_went_wrong".localized())
                        .font(.custom(ApolloSDK.current.getBoldFont(), size: 14))
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor).multilineTextAlignment(.center)
                )
            }
        }
    }
}

struct AttCreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AttCreateAccountView(
                user: .init(),
                product: AttMockViewModal.products[0]
            )
        }
    }
}

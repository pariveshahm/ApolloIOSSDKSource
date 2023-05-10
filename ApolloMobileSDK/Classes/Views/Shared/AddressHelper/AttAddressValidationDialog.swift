//  AddressValidationDialog.swift
//  ApolloMobileSDK
//
//  Created by Shak4l on 09/02/2021.

import SwiftUI

struct AttAddressValidationDialog: View {
    
    // - State
    @State
    private var selectedIndex = -2
    
    // - Properties
    let addresses: [AttAddress]
    let onConfirm: (_ address: AttAddress) -> Void
    let onCancel:  () -> Void
    
    // - Actions
    private func onSubmit() {
        guard selectedIndex >= 0 else {
            selectedIndex = -1
            return
        }
        
        onConfirm(addresses[selectedIndex])
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Button(action: onCancel) {

                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .imageScale(.large)
                            .foregroundColor(.yellow)
                            .font(.system(size: 25))
                        
                        Text("validate_addresses_dialog_title".localized())
                            .font(.custom(.bold, size: 19))
                            .foregroundColor(AttAppTheme.yellowProgressBarColor)
                    }
                    Spacer()
                    
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(AttAppTheme.primaryColor)
                        .font(.system(size: 11, weight: .light))
                        .frame(width: 15, height: 15)
                    
                }
                
                Spacer().frame(height: 20)
                
                Spacer().frame(height: 8)
                
                if selectedIndex == -1 {
                    Spacer().frame(height: 16)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.red)
                            .font(.system(size: 16))
                        
                        Text("validate_addresses_dialog_body_error_text".localized())
                            .font(.custom(.regular, size: 16))
                            .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 0.5)
                    )
                    
                    Spacer().frame(height: 16)
                }
                
                if addresses.count == 1 {
                    Text("validate_addresses_dialog_body_first_line".localized())
                        .font(.custom(.regular, size: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                } else {
                    Text("atnt_is_checking_you_address_more".localized())
                        .font(.custom(.regular, size: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(AttAppTheme.attSDKTextPrimaryColor)
                }
                
                VStack(spacing: 10) {
                    ForEach(addresses.indices, id: \.self) { index in
                        let address = addresses[index]
                        AttAddressRow(
                            isSelected: index == selectedIndex,
                            address: address,
                            onSelect: { selectedIndex = index; }
                        )
                    }
                }.frame(minHeight: 10, maxHeight: 70)
                .background(AttAppTheme.attSDKBlockBackgroundColor)
                
                Button("validate_addresses_dialog_done_button".localized(), action: onSubmit)
                    .buttonStyle(AttPrimaryButtonStyle())
                
                Spacer().frame(height: 10)
                
                Button("cancel_service_modal_cancel".localized(), action: onCancel)
                    .buttonStyle(AttSecondaryButtonStyle())
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(AttAppTheme.attSDKBlockBackgroundColor)
            .cornerRadius(10.0)
            .padding()
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct AttAddressValidationDialog_Previews: PreviewProvider {
    
    static var previews: some View {
        AttAddressValidationDialog(
            addresses: AttMockViewModal.mockAddresses,
            onConfirm: { _ in },
            onCancel: { }
        )
    }
    
}


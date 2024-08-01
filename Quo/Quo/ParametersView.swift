//
//  ParametersView.swift
//  Quo
//
//  Created by Calin Gavriliu on 31.07.2024.
//

import SwiftUI

struct ParametersView: View {
    
    @Binding var rainDropletsAmmount: Int
    @Binding var avrageSpeed: CGFloat
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Cate plaoie vrei")
                    Slider(
                        value: Binding(
                            get: { Double(rainDropletsAmmount) },
                            set: { rainDropletsAmmount = Int($0) }
                        ),
                        in: 12...48,
                        step: 1
                    )
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .primary.opacity(0.08), radius: 12, x: 6, y: 2)
                
                VStack(alignment: .leading) {
                    Text("Viteza ploii")
                    Slider(value: $avrageSpeed, in: 4...24)
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .primary.opacity(0.08), radius: 12, x: 6, y: 2)
            }
            .padding(32)
        }
    }
}


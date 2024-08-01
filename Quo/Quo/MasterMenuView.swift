//
//  MasterMenuView.swift
//  Quo
//
//  Created by Calin Gavriliu on 31.07.2024.
//

import SwiftUI

struct MasterMenuView: View {
    
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var selectedTrackIndex: Int = 0
    
    private let fileNames: [String] = ["ploaie2", "ploaie3"]
    
    @State private var indexOfSelectedView = 1
    
    @State private var p: Double = 3
    
    @State private var showParameters = false
    @State private var rainDropletsAmmount: Int = 20
    @State private var avrageSpeed: CGFloat = 12
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker(selection: $indexOfSelectedView, label: Text("Alege ecranul!")) {
                    Text("Simulare")
                        .tag(1)
                    Text("Lectii")
                        .tag(0)
                }
                .pickerStyle(PalettePickerStyle())
                .padding(.horizontal, 32)
                .padding(.bottom, 18)
                
                Divider().opacity(indexOfSelectedView == 0 ? 1 : 0)
                
                ZStack {
                    switch indexOfSelectedView {
                    case 0:
                        LessonsListView()
                    case 1:
                        VStack {
                            ContentView(
                                fileNames: fileNames,
                                p: $p,
                                dropletsAmmount: $rainDropletsAmmount,
                                avrageSpeed: $avrageSpeed
                            )
                            .environmentObject(audioPlayer)
                        }
                    default:
                        LessonsListView()
                    }
                }
                Spacer(minLength: 0)
            }
            .navigationTitle("Quo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if indexOfSelectedView == 1 {
                    Button(action: {
                        showParameters = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showParameters) {
                ScrollView {
                    WaterCyclePredictionView(p: $p)
                        .frame(width: screenWidth - 64)
                        .padding(32)
                        .environmentObject(audioPlayer)
                }
                .scrollClipDisabled()
                .presentationDetents([.medium, .large])
            }
        }
    }
}


#Preview {
    MasterMenuView()
        .modelContainer(previewContainer)
}

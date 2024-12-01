//
//  ControlView.swift
//  Atlas Companion Watch App
//
//  Created by Guillermo Alcalá Gamero on 1/12/24.
//  Copyright © 2024 Guillermo Alcalá Gamero. All rights reserved.
//

import SwiftUI

struct ControlView: View {
	@ObservedObject private var viewModel = ControlViewModel()
	
	var body: some View {
		let isPaused: Bool = viewModel.isPaused
		let buttonTitle: String = isPaused ? "Play" : "Pause"
		let systemImage: String = isPaused ? "play.fill" : "pause.fill"
		
		let button = Button(buttonTitle, systemImage: systemImage) {
			viewModel.isPaused.toggle()
		}
		
		return button
	}
}

#Preview {
    ControlView()
}

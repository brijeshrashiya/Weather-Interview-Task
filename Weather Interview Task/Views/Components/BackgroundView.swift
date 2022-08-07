//
//  BackgroundView.swift
//  Weather Demo
//
//  Created by Brijesh on 03/08/22.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient:
                            Gradient(colors: [
                                ColorConstant.AppBackground,
                                ColorConstant.AppBackground,
                                ColorConstant.AccentColor,
                            ]), startPoint: .top, endPoint: .bottomTrailing)

            VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundVIew_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}

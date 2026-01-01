//
//  FeatureRow.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Feature Row

/// Display a single feature with checkmark
struct FeatureRow: View {
    let text: String
    let iconColor: Color
    
    init(_ text: String, iconColor: Color = .appPrimary) {
        self.text = text
        self.iconColor = iconColor
    }
    
    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(iconColor)
                .font(.title3)
            
            Text(text)
                .font(.appBody)
                .foregroundColor(.appText)
            
            Spacer()
        }
    }
}

// MARK: - Feature List

/// Display list of features
struct FeatureList: View {
    let features: [String]
    let iconColor: Color
    
    init(features: [String], iconColor: Color = .appPrimary) {
        self.features = features
        self.iconColor = iconColor
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            ForEach(features, id: \.self) { feature in
                FeatureRow(feature, iconColor: iconColor)
            }
        }
    }
}

// MARK: - Previews

#Preview("Feature Row") {
    VStack(spacing: AppSpacing.medium) {
        FeatureRow("Unlimited access to all features")
        FeatureRow("Ad-free experience", iconColor: .appSuccess)
        FeatureRow("Priority support", iconColor: .appPremium)
    }
    .padding()
}

#Preview("Feature List") {
    FeatureList(features: SubscriptionPlan.commonFeatures)
        .padding()
}

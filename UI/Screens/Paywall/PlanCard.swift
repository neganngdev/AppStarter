//
//  PlanCard.swift
//  AppStarter
//
//  Created on 2026-01-02
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Plan Card

/// Display a single subscription plan as a card
struct PlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                // Header with name and popular badge
                HStack {
                    Text(plan.name)
                        .font(Font.appHeadline)
                        .foregroundColor(Color.appText)
                    
                    Spacer()
                    
                    if plan.isPopular {
                        Text("POPULAR")
                            .font(Font.appCaption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, AppSpacing.xSmall)
                            .padding(.vertical, AppSpacing.xxSmall)
                            .background(Color.appPrimary)
                            .cornerRadius(AppRadius.xSmall)
                    }
                }
                
                // Price
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.xxSmall) {
                    Text(plan.price)
                        .font(Font.appTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.appText)
                    
                    Text("/ \(plan.period)")
                        .font(Font.appBody)
                        .foregroundColor(Color.appSecondaryText)
                }
                
                // Trial or Savings
                if let trialText = plan.trialText {
                    Label(trialText, systemImage: "gift.fill")
                        .font(Font.appCaption)
                        .foregroundColor(Color.appSuccess)
                } else if let savingsText = plan.savingsText {
                    Label(savingsText, systemImage: "tag.fill")
                        .font(Font.appCaption)
                        .foregroundColor(Color.appSuccess)
                }
            }
            .padding(AppSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.appPrimary.opacity(0.1) : Color.appSecondaryBackground)
            .cornerRadius(AppRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.medium)
                    .stroke(isSelected ? Color.appPrimary : Color.appBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Compact Plan Card

/// Horizontal compact plan card
struct CompactPlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color.appPrimary : Color.appBorder)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
                    HStack {
                        Text(plan.name)
                            .font(Font.appBodyEmphasized)
                            .foregroundColor(Color.appText)
                        
                        if plan.isPopular {
                            Text("POPULAR")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Color.appPrimary)
                                .cornerRadius(3)
                        }
                    }
                    
                    Text(plan.priceDisplay)
                        .font(Font.appCaption)
                        .foregroundColor(Color.appSecondaryText)
                    
                    if let savingsText = plan.savingsText {
                        Text(savingsText)
                            .font(Font.appCaption2)
                            .foregroundColor(Color.appSuccess)
                    }
                }
                
                Spacer()
            }
            .padding(AppSpacing.small)
            .background(isSelected ? Color.appPrimary.opacity(0.1) : Color.clear)
            .cornerRadius(AppRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.small)
                    .stroke(isSelected ? Color.appPrimary : Color.appBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Plan Cards") {
    VStack(spacing: AppSpacing.medium) {
        PlanCard(plan: SubscriptionPlan.samplePlans[0], isSelected: false) { }
        PlanCard(plan: SubscriptionPlan.samplePlans[1], isSelected: true) { }
        PlanCard(plan: SubscriptionPlan.samplePlans[2], isSelected: false) { }
    }
    .padding()
}

#Preview("Compact Cards") {
    VStack(spacing: AppSpacing.small) {
        CompactPlanCard(plan: SubscriptionPlan.minimalPlans[0], isSelected: false) { }
        CompactPlanCard(plan: SubscriptionPlan.minimalPlans[1], isSelected: true) { }
    }
    .padding()
}

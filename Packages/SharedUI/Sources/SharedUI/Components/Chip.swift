import SwiftUI

public struct Chip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    public init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            TextLabel(title, style: .chip)
                .foregroundStyle(isSelected ? Color.onBrand : Color.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.brand : Color.chipBackground)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

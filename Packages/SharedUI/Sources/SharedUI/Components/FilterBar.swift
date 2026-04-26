import SwiftUI

public struct FilterBar<ID: Hashable>: View {

    public struct Item: Identifiable {
        public let id: ID
        public let title: String

        public init(id: ID, title: String) {
            self.id = id
            self.title = title
        }
    }

    private let items: [Item]
    private let selectedId: ID?
    private let onSelect: (ID) -> Void

    public init(items: [Item], selectedId: ID?, onSelect: @escaping (ID) -> Void) {
        self.items = items
        self.selectedId = selectedId
        self.onSelect = onSelect
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items) { item in
                    Button(action: { onSelect(item.id) }) {
                        TextLabel(item.title, style: .chip)
                            .fontWeight(.medium)
                            .foregroundStyle(item.id == selectedId ? Color.onBrand : Color.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(item.id == selectedId ? Color.brand : Color.clear)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.brand, lineWidth: item.id == selectedId ? 0 : 1.5))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}

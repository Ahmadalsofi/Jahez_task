import AppService
import SharedUI

extension Array where Element == Genre {
    func toFilterBarItems() -> [FilterBar<Int>.Item] {
        map { FilterBar.Item(id: $0.id, title: $0.name) }
    }
}

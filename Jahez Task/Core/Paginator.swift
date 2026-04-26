struct Paginator<Item: Identifiable> where Item.ID: Hashable {
    private(set) var items: [Item] = []
    private(set) var currentPage = 0
    private(set) var totalPages = 1
    private var seenIds = Set<Item.ID>()

    var hasNextPage: Bool { currentPage < totalPages }
    var nextPage: Int    { currentPage + 1 }

    mutating func apply(page: Int, totalPages: Int, results: [Item]) {
        currentPage = page
        self.totalPages = totalPages
        let fresh = results.filter { seenIds.insert($0.id).inserted }
        items.append(contentsOf: fresh)
    }

    mutating func reset() {
        self = Paginator()
    }
}

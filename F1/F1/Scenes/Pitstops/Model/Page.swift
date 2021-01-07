import Foundation

struct Page {
    var total: Int
    var offset: Int
    var limit: Int
    
    init(pitStopData: PMPitStopsData) {
        total = Int(pitStopData.total) ?? 0
        offset = Int(pitStopData.offset) ?? 0
        limit = Int(pitStopData.limit) ?? 0
    }
}

import Foundation
import Kanna

public class Billboard {
    public init() {}
    private var hot100Rows : XPathObject?
    public var hot100 = [BillboardEntry]()
    public var htmlContents: String?
    public var returnedDocument: HTMLDocument?
    private let _baseUrlString: String = "http://www.billboard.com/charts/hot-100"
    
    /**
        Crawls Billboard Hot 100 by date. Date must be a Saturday in given year.
     
        - parameter dateString: The date you'd like to retrieve entries for. e.g. 2017-05-13
     
        - returns [BillboardEntry]?
     
     */
    public func getEntriesForCalendarWeek(_ dateString: String) -> [BillboardEntry]? {
        let foundEntries = [BillboardEntry]()
        
        return foundEntries
    }
    
    private func _getPage(urlString: String, document: (_ doc: HTMLDocument) -> ()) {
        document(HTML(url: URL(string: urlString)!, encoding: .utf8)!)
    }
    
    public func fetchHot100() {
        _getPage(urlString: _baseUrlString) { (doc) in
            let calendarWeek = doc.css("time")[0].content!
            if let rows = doc.css(".chart-row") as XPathObject? {
                for row in rows {
                    let songTitle = row.at_css(".chart-row__song")!.content!
                    let artistName = row.at_css(".chart-row__artist")!.content!
                    let currentRank = row.at_css(".chart-row__current-week")!.content!
                    let previousRank = row.at_css(".chart-row__last-week")!.content!
                    
                    hot100.append(BillboardEntry(calendarWeek: calendarWeek, songTitle: songTitle, artistName: artistName.trimmingCharacters(in: .whitespacesAndNewlines), currentRank: currentRank, previousRank: previousRank.characters.last!))
                }
            }
        }
    }
    
    public func getHot100() -> [BillboardEntry] {
        return hot100
    }
    
    public func listHot100() {
        for row in hot100 {
            print("\(row.currentRank) --- \(row.songTitle) | \(row.artistName)")
        }
    }
}

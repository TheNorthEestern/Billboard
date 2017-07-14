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
    public func getEntriesFor(calendarWeek dateString: String) -> [BillboardEntry]? {
        var foundEntries = [BillboardEntry]()
        let dateFormatter = queryParamDateFormatter()
        let entryDate = dateFormatter.date(from: dateString)
        var validSaturdays = [Date]()
        do {
            validSaturdays = try getAllSaturdaysIn(theYear: dateString.components(separatedBy: "-")[0])
        } catch let error {
            print(error)
        }
        if isValidSaturday(date: entryDate!, datesInYear: validSaturdays) {
                getPageAt(url: "\(_baseUrlString)/\(dateString)") { (document) in
                    let calendarWeek = document.css("time")[0].content!
                    if let rows = document.css(".chart-row") as XPathObject? {
                        for row in rows {
                            let songTitle = row.at_css(".chart-row__song")!.content!
                            let artistName = row.at_css(".chart-row__artist")!.content!
                            let currentRank = row.at_css(".chart-row__current-week")!.content!
                            let previousRank = row.at_css(".chart-row__last-week")!.content!
                            
                            foundEntries.append(BillboardEntry(calendarWeek: calendarWeek, songTitle: songTitle, artistName: artistName.trimmingCharacters(in: .whitespacesAndNewlines), currentRank: currentRank, previousRank: previousRank.characters.last!))
                        }
                    }
            }
        }
        return foundEntries
    }
    
    public func fetchHot100() {
        getPageAt(url: _baseUrlString) { (doc) in
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
    
    private func isValidSaturday(date: Date, datesInYear: [Date]) -> Bool {
        return datesInYear.contains(date)
    }
    
    private func queryParamDateFormatter() -> DateFormatter {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    private func getAllSaturdaysIn(theYear year: String) throws -> [Date] {
        if year.characters.count < 4 || year.characters.count > 4 {
            throw BillboardError.wrongDateFormat
        }
        
        var saturdays : [Date] = [Date]()
        let formatter : DateFormatter = queryParamDateFormatter()
        
        let beginningOfTheYear : Date? = formatter.date(from: "\(year)/01/01")
        let endOfTheYear : Date? = formatter.date(from: "\(year)/12/31")
        let cal : Calendar = Calendar.current
        let stopDate : Date = cal.date(byAdding: .month, value: 0, to: beginningOfTheYear!)!
        
        var comps : DateComponents = DateComponents()
        comps.weekday = 7 // Saturday
        
        cal.enumerateDates(startingAfter: endOfTheYear!, matching: comps, matchingPolicy: .previousTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .backward) { (date, match, stop) in
            if let date = date {
                if date < stopDate {
                    stop = true // We've reached the end, exit the loop
                } else {
                    saturdays.append(date)
                }
            }
        }
        
        return saturdays
    }
    
    private func getPageAt(url: String, document: (_ doc: HTMLDocument) -> ()) {
        document(HTML(url: URL(string: url)!, encoding: .utf8)!)
    }
}

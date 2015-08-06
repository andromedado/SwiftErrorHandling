//
//  Extractor.swift
//  SupremeOpinions
//
//  Created by Shad Downey on 8/6/15.
//
//

import Foundation


class Extractor
{
    class var opts : NSRegularExpressionOptions {
        get {
            return NSRegularExpressionOptions(rawValue: NSRegularExpressionOptions.CaseInsensitive.rawValue | NSRegularExpressionOptions.DotMatchesLineSeparators.rawValue)
        }
    }

    class func extract(html:String) -> [Opinion] {
        var opinions : [Opinion] = []
        var tables = self.extractMatcingPair(html, tagname: "table")
        for table in tables {
            var rows = self.extractMatcingPair(table, tagname: "tr")
            for row in rows {
                var cells = self.extractMatcingPair(row, tagname: "td")
                if (cells.count != 6) {
                    continue;
                }
                var contents = cells.map({ (cell) -> String in
                    return Extractor.unwrap(cell, tagname: "td")
                })
                var opinion = Opinion()
                for i in 0..<contents.count {
                    if let cell = CellOrder(rawValue: i) {
                        switch(cell) {
                        case .Author:
                            opinion.author = contents[i]
                            break;
                        case .Date:
                            opinion.date = contents[i]
                            break;
                        case .Docket:
                            opinion.docket = contents[i]
                            break;
                        case .Link:
                            opinion.name = Extractor.unwrap(contents[i], tagname: "a")
                            opinion.summary = Extractor.attr(contents[i], attributeName: "title")
                            var hrefStr = Extractor.attr(contents[i], attributeName: "href")
                            opinion.href = NSURL(scheme: "http", host: "www.supremecourt.gov", path: hrefStr)
                            break;
                        case .Sequence:
                            opinion.sequence = Int(contents[i])
                            break;
                        case .Volume:
                            opinion.volumePrint = contents[i]
                            break;
                        }
                    }
                }
                opinions.append(opinion)
            }
        }
        return opinions
    }

    class func attr(html:String, attributeName:String) -> String {
        let strAsNSString = html as NSString
        var value = ""
        let range = NSMakeRange(0, strAsNSString.length)
        let singleQuotePattern = ".*\(attributeName)='(.*?)'.*"
        let doubleQuotePattern = ".*\(attributeName)=\"(.*?)\".*"


        let singleRegex = try! NSRegularExpression(pattern: singleQuotePattern, options: Extractor.opts)
        //Options ".allZeroes" changed to empty array "[]"
        if (singleRegex.matchesInString(html, options: [], range: range).count > 0) {
            let fizz = singleRegex.stringByReplacingMatchesInString(html, options: [], range: range, withTemplate: "$1")
            value += fizz
        }
        var doubleRegex : NSRegularExpression
        doubleRegex = try! NSRegularExpression(pattern: doubleQuotePattern, options: Extractor.opts)
        if (doubleRegex.matchesInString(html, options: [], range: range).count > 0) {
            let buzz = doubleRegex.stringByReplacingMatchesInString(html, options: [], range: range, withTemplate: "$1")
            value += buzz
        }
        return value
    }

    class func unwrap(html:String, tagname:String) -> String {
        let strAsNSString = html as NSString
        let pattern = "<\(tagname)[^>]*>(.*?)<\\/\(tagname)>"
        var regex : NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: Extractor.opts)
        } catch {
            return ""
        }
        var range = NSMakeRange(0, strAsNSString.length)
        var contents = ""
        contents += regex.stringByReplacingMatchesInString(html, options: [], range: range, withTemplate: "$1")
        return contents
    }

    class func extractMatcingPair(html:String, tagname:String) -> [String] {
        var pointer = NSErrorPointer()
        let strAsNSString = html as NSString
        let pattern = "<\(tagname)[^>]*>.*?\(tagname)>"
        var regex = try! NSRegularExpression(pattern: pattern, options: Extractor.opts)
        var range = NSMakeRange(0, strAsNSString.length)
        var pairs : [String] = []
        regex.enumerateMatchesInString(html, options: [], range: range, usingBlock: { (result, flags, stop) -> Void in
            guard let res = result else {return}
            let pair = strAsNSString.substringWithRange(res.range)
            pairs.append(pair)
        })
        return pairs
    }
    
}
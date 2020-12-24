//
//  FTS.swift
//  FTS5
//
//  Created by leon on 24/12/2020.
//

import Foundation
import GRDB


final class SimpleTokenizer : FTS5CustomTokenizer {
    static let name = "simple"
    
    init(db: Database, arguments: [String]) throws {
        print("init tokenizer `simple`")
    }
    
    func tokenize(context: UnsafeMutableRawPointer?,
                  tokenization: FTS5Tokenization,
                  pText: UnsafePointer<Int8>?,
                  nText: Int32,
                  tokenCallback: @escaping FTS5TokenCallback) -> Int32 {
        return simple_xTokenize(context, tokenization.rawValue, pText, nText, tokenCallback)
    }
}


// MAKR: -


class FTS {
    private var _queue_: DatabaseQueue?
    var queue: DatabaseQueue {
        _queue_!
    }
    
    var path: String {
        queue.path
    }
    
    init() {
        let path = NSTemporaryDirectory().appending("fts.db")
        var config = Configuration()
        config.prepareDatabase {db in
            db.trace(options: .profile) { event in
                if case let .profile(statement, duration) = event {
                    let ms = Int(round(duration * 1000))
                    if ms > 10 {
                        print("#GRDB: [slow query] \(ms)ms \(statement.sql)")
                    } else {
                        let sql = statement.sql
                        if !sql.contains("PRAGMA") &&
                            !sql.contains("sqlite_temp_master") {
                            let log = statement.expandedSQL.replacingOccurrences(of: "\n", with: " ")
                            if log.count > 1000 {
                                print("#GRDB: \(ms)ms", String(log.prefix(1000)), " ...")
                            } else {
                                print("#GRDB: \(ms)ms", log)
                            }
                        }
                    }
                }
            }
        }
        _queue_ = try! DatabaseQueue(path: path, configuration: config)
        
        do {
            try self.queue.write { db in
                try db.create(virtualTable: "t1", using: FTS5()) { t in
                    t.tokenizer = SimpleTokenizer.tokenizerDescriptor()
                    t.column("x")
                }
            }
        } catch let error {
            print(error)
        }
    }
}


// MAKR: -


extension FTS {
    static func test() {
        let fts = FTS()
        do {
            try fts.queue.write { db in
                try db.execute(sql: "insert into t1 (x) values (?)",
                               arguments: ["Hello world!"])
                
                let cursor = try Row.fetchCursor(db, sql: "SELECT rowid, * FROM t1 WHERE x MATCH ?",
                                                 arguments: ["world"])
                while let row = try cursor.next() {
                    print(row)
                }
            }
        } catch {
            print("ERROR:", error)
        }
    }
}

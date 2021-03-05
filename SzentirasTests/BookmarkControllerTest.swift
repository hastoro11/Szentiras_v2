//
//  BookmarkControllerTest.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 02. 22..
//

import CoreData
import XCTest
@testable import Szentiras

class BookmarkControllerTest: XCTestCase {
    var bookmarkController: BookmarkController!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        bookmarkController = BookmarkController(inMemory: true)
        context = bookmarkController.container.viewContext
    }
    
    func testSampleDataExists() throws {
        
        let request: NSFetchRequest<Bookmark> = NSFetchRequest(entityName: "Bookmark")
        let bookmarks = try context.fetch(request)
        
        for bkmrk in bookmarks {
            print(bkmrk.order, bkmrk.szep)
        }
        XCTAssertEqual(bookmarks.count, 7)
        XCTAssertEqual(bookmarkController.sortedBookmarks.count, 4)
        XCTAssertNotNil(bookmarkController.sortedBookmarks["Red"])
        let reds = bookmarkController.sortedBookmarks["Red"]!
        XCTAssertEqual(reds.count, Optional(2))
        XCTAssertEqual(reds[0].szep, Optional("Bír 3,1"))
        XCTAssertEqual(reds[1].szep, Optional("Bír 3,7"))
        
    }
    
    func testAddNewBookmark() {
        bookmarkController.selectedVers = Vers(szoveg: "szoveg", hely: Hely(gepi: 123, szep: "szep"))
        bookmarkController.addBookmark(color: "Red", translation: "RUF")
        
        XCTAssertNotNil(bookmarkController.sortedBookmarks["Red"])
        let reds = bookmarkController.sortedBookmarks["Red"]!
        
        XCTAssertEqual(reds.count, 3)
        XCTAssertEqual(reds[reds.count-1].gepi, "123")
    }
    
    func testAddExistingBookmark() {
        bookmarkController.selectedVers = Vers(szoveg: "szoveg", hely: Hely(gepi: 123, szep: "szep"))
        bookmarkController.addBookmark(color: "Red", translation: "RUF")
        
        XCTAssertNotNil(bookmarkController.sortedBookmarks["Red"])
        var reds = bookmarkController.sortedBookmarks["Red"]!
        
        XCTAssertEqual(reds.count, 3)
        XCTAssertEqual(reds[reds.count-1].gepi, "123")
        
        bookmarkController.addBookmark(color: "Red", translation: "RUF")
        XCTAssertEqual(reds.count, 3)
        
        bookmarkController.addBookmark(color: "Blue", translation: "RUF")
        reds = bookmarkController.sortedBookmarks["Red"]!
        XCTAssertEqual(reds.count, 2)
        XCTAssertEqual(bookmarkController.sortedBookmarks["Blue"]!.count, 3)
        
        bookmarkController.selectedVers = Vers(szoveg: "szoveg", hely: Hely(gepi: 456, szep: "szep"))
        bookmarkController.addBookmark(color: "Red", translation: "RUF")
        reds = bookmarkController.sortedBookmarks["Red"]!
        
        XCTAssertEqual(reds.count, 3)
    }

    func testDeletingBookmark() {
        bookmarkController.selectedVers = Vers(szoveg: "szoveg", hely: Hely(gepi: 123, szep: "szep"))
        bookmarkController.addBookmark(color: "Red", translation: "RUF")
        
        XCTAssertNotNil(bookmarkController.sortedBookmarks["Red"])
        var reds = bookmarkController.sortedBookmarks["Red"]!
        XCTAssertEqual(reds.count, 3)
        XCTAssertEqual(reds[2].order, 2)
        
        bookmarkController.deleteBookmark()
        reds = bookmarkController.sortedBookmarks["Red"]!
        XCTAssertEqual(reds.count, 2)
        XCTAssertEqual(reds[1].order, 1)
        
    }
    
    func testDeletingBookmarkFromList() {
        let indexSet = IndexSet(integer: 0)
        XCTAssertNotNil(bookmarkController.sortedBookmarks["Yellow"])
        var yellows = bookmarkController.sortedBookmarks["Yellow"]!
        XCTAssertEqual(yellows.count, 3)
        
        for (index, bookmark) in yellows.enumerated() {
            XCTAssertEqual(index, bookmark.order)
        }
        
        bookmarkController.deleteBookmark(color: "Yellow", indexSet: indexSet)
        yellows = bookmarkController.sortedBookmarks["Yellow"]!
        XCTAssertEqual(yellows.count, 2)
        XCTAssertEqual(yellows[1].order, 1)
        for (index, bookmark) in yellows.enumerated() {
            XCTAssertEqual(index, bookmark.order)
        }
    }
    
    func testMovingBookmark() {
        XCTAssertNotNil(bookmarkController.sortedBookmarks["Yellow"])
        var yellows = bookmarkController.sortedBookmarks["Yellow"]!
        XCTAssertEqual(yellows.count, 3)
        
        XCTAssertEqual(yellows[0].szep, "Tit 1,2")
        XCTAssertEqual(yellows[1].szep, "Tit 1,8")
        XCTAssertEqual(yellows[2].szep, "Fil 3,1")
        
        bookmarkController.moveBookmark(color: "Yellow", from: IndexSet(integer: 2), to: 0)
        
        yellows = bookmarkController.sortedBookmarks["Yellow"]!
        XCTAssertEqual(yellows[0].szep, "Fil 3,1")
        XCTAssertEqual(yellows[1].szep, "Tit 1,2")
        XCTAssertEqual(yellows[2].szep, "Tit 1,8")
        
    }
    
    func testCheckIfVersIsMarked() {
        XCTAssertNotNil(bookmarkController.sortedBookmarks["Yellow"])
        let vers = Vers(szoveg: "", hely: Hely(gepi: 123, szep: ""))
        bookmarkController.selectedVers = vers
        bookmarkController.addBookmark(color: "Yellow", translation: "RUF")
        let yellows = bookmarkController.sortedBookmarks["Yellow"]!
        XCTAssertEqual(yellows.count, 4)
        
        XCTAssertNotNil(bookmarkController.checkIfVersIsMarked(gepi: yellows[0].gepi))
        XCTAssertNotNil(bookmarkController.checkIfVersIsMarked(gepi: "123"))
        
    }
}

//
//  BookmarkController.swift
//  Szentiras
//
//  Created by Gabor Sornyei on 2021. 01. 22..
//

import SwiftUI
import CoreData
import Combine

class BookmarkController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    @Published var sortedBookmarks: [String: [Bookmark]] = [
        "Yellow": [],
        "Red": [],
        "Blue": [],
        "Green": []
    ]
    @Published var selectedVers: Vers?
    
    //--------------------------------
    // Init
    //--------------------------------
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Bookmark")
        
        if inMemory {
            //         container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { [self] _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            let context = container.viewContext
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context.automaticallyMergesChangesFromParent = true
        }
        if inMemory {
            selectedVers = Vers(szoveg: "This is the example text", hely: Hely(gepi: 123, szep: "Mk 99,1"))
            try? createSampleData()
        }
        fetchBookmarks()
    }
    
    //--------------------------------
    // Fetch bookmarks
    //--------------------------------
    func fetchBookmarks() {

        sortedBookmarks["Yellow"] = fetchBookmarks(by: "Yellow")
        sortedBookmarks["Green"] = fetchBookmarks(by: "Green")
        sortedBookmarks["Red"] = fetchBookmarks(by: "Red")
        sortedBookmarks["Blue"] = fetchBookmarks(by: "Blue")
        
    }
    
    func fetchBookmarks(by color: String) -> [Bookmark] {
        let context = container.viewContext
        let sortDescriptor = NSSortDescriptor(keyPath: \Bookmark.order_, ascending: true)
        let predicate = NSPredicate(format: "color_ = %@", color)
        let request: NSFetchRequest<Bookmark> = NSFetchRequest(entityName: "Bookmark")
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        
        return (try? context.fetch(request)) ?? []
    }
    
    //--------------------------------
    // Find if vers bookmarked
    //--------------------------------
    func getBookmarkColor(gepi: String) -> Color {
        if let found = checkIfVersIsMarked(gepi: gepi) {
            return Color(found.color)
        }
        
        return Color.clear
    }
    
    func checkIfVersIsMarked(gepi: String) -> Bookmark? {
        let context = container.viewContext
        let request = NSFetchRequest<Bookmark>(entityName: "Bookmark")
        request.predicate = NSPredicate(format: "gepi_ = %@", gepi)
        let bookmarks = (try? context.fetch(request)) ?? []
        return bookmarks.first
    }
    
    //--------------------------------
    // Add bookmark
    //--------------------------------
    func addBookmark(color: String, translation: String) {
        guard let vers = selectedVers  else { return }
        let count = sortedBookmarks[color]?.count ?? 0
        let context = container.viewContext
        if let foundBookmark = checkIfVersIsMarked(gepi: String(vers.hely.gepi)) {
            foundBookmark.translation = translation
            foundBookmark.color = color
        } else {
            let bookmark = Bookmark(context: context)
            bookmark.order = count
            bookmark.color = color
            bookmark.gepi = String(vers.hely.gepi)
            bookmark.szep = vers.hely.szep
            bookmark.szoveg = vers.szoveg ?? ""
            bookmark.translation = translation
        }
        try? context.save()
        fetchBookmarks()
        recalculateIndices(color: color)
    }
    
    //--------------------------------
    // Delete bookmark
    //--------------------------------
    func deleteBookmark() {
        guard let vers = selectedVers else { return }
        let context = container.viewContext
        if let found = checkIfVersIsMarked(gepi: String(vers.hely.gepi)) {
            context.delete(found)            
            fetchBookmarks()
            recalculateIndices(color: found.color)
        }
    }
    
    func deleteBookmark(color: String, indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        guard let bookmark = sortedBookmarks[color]?[index] else { return }

        let context = container.viewContext
        context.delete(bookmark)

        try? context.save()
        recalculateIndices(color: color)
    }
    
    //--------------------------------
    // Move bookmark
    //--------------------------------
    func moveBookmark(color: String, from source: IndexSet, to destination: Int) {
        guard var bookmarks = sortedBookmarks[color] else { return }
        bookmarks.move(fromOffsets: source, toOffset: destination)
        bookmarks.enumerated().forEach({index, bmrk in
            bmrk.order = index
            try? container.viewContext.save()
        })

        fetchBookmarks()
    }
    
    //--------------------------------
    // Recalculate indexes
    //--------------------------------
    private func recalculateIndices(color: String) {
        let context = container.viewContext
        let descriptor = NSSortDescriptor(keyPath: \Bookmark.order_, ascending: true)
        let predicate = NSPredicate(format: "color_ = %@", color)
        let fetchRequest: NSFetchRequest<Bookmark> = NSFetchRequest(entityName: "Bookmark")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [descriptor]
        
        let fetchedBookmarks = (try? context.fetch(fetchRequest)) ?? []
        for (index, bookmark) in fetchedBookmarks.enumerated() {
            bookmark.order = index
        }
        try? context.save()
        fetchBookmarks()
    }
    
    //--------------------------------
    // Preview Helpers
    //--------------------------------
    
    // swiftlint:disable line_length
    func createSampleData() throws {
        
        let context = container.viewContext
        let bookmark1 = Bookmark(context: context)
        bookmark1.szoveg = "az ??r??k ??let rem??nys??g??re, amelyet Isten, aki nem hazudik, ??r??k id??k el??tt meg??g??rt,"
        bookmark1.gepi = "21700100200"
        bookmark1.szep = "Tit 1,2"
        bookmark1.translation = "RUF"
        bookmark1.color = "Yellow"
        bookmark1.order_ = 0
        let bookmark2 = Bookmark(context: context)
        bookmark2.szoveg = "hanem vend??gszeret??, a j??ra hajland??, j??zan, igazs??gos, kegyes, ??nmegtart??ztat??,"
        bookmark2.gepi = "21700100800"
        bookmark2.szep = "Tit 1,8"
        bookmark2.translation = "RUF"
        bookmark2.color = "Yellow"
        bookmark2.order_ = 1
        let bookmark3 = Bookmark(context: context)
        bookmark3.szoveg = "Egy??bk??nt pedig, testv??reim, ??r??ljetek az ??rban! Hogy ugyanazt ??rjam nektek, az engem nem f??raszt, titeket viszont meger??s??t."
        bookmark3.gepi = "21100300100"
        bookmark3.szep = "Fil 3,1"
        bookmark3.translation = "KG"
        bookmark3.color = "Yellow"
        bookmark3.order_ = 2
        let bookmark4 = Bookmark(context: context)
        bookmark4.szoveg = "Ezek azok a n??pek, amelyeket hely??k??n hagyott az ??R, hogy pr??b??ra tegye vel??k Izr??elt, mindazokat, akik m??r mit sem tudtak a K??na??n??rt v??vott harcokr??l."
        bookmark4.gepi = "10700300100"
        bookmark4.szep = "B??r 3,1"
        bookmark4.translation = "RUF"
        bookmark4.color = "Red"
        bookmark4.order_ = 0
        let bookmark5 = Bookmark(context: context)
        bookmark5.szoveg = "Izr??el fiai azt tett??k, amit rossznak l??t az ??R. Elfeledkeztek Isten??kr??l, az ??Rr??l, ??s a Baalokat meg az As??r??kat tisztelt??k."
        bookmark5.gepi = "10700300700"
        bookmark5.szep = "B??r 3,7"
        bookmark5.translation = "KG"
        bookmark5.color = "Red"
        bookmark5.order_ = 1
        let bookmark6 = Bookmark(context: context)
        bookmark6.szoveg = "Hozz??juk pedig ??gy sz??lt: Szabad-e szombaton j??t tenni, vagy rosszat tenni, ??letet menteni vagy kioltani? De azok hallgattak."
        bookmark6.gepi = "20200300400"
        bookmark6.szep = "Mk 3,4"
        bookmark6.translation = "RUF"
        bookmark6.color = "Blue"
        bookmark6.order_ = 0
        let bookmark7 = Bookmark(context: context)
        bookmark7.szoveg = "Ezut??n ism??t a zsinag??g??ba ment. Volt ott egy sorvadt kez?? ember."
        bookmark7.gepi = "20200300100"
        bookmark7.szep = "Mk 3,1"
        bookmark7.translation = "RUF"
        bookmark7.color = "Blue"
        bookmark7.order_ = 1
        try context.save()
    }
    
}

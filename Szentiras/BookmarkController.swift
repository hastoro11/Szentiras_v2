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
        
        sortedBookmarks["Yellow"]!.forEach({print("DEBUG: fetched YELLOW bookmarks", $0.order, $0.szep)})
        sortedBookmarks["Green"]!.forEach({print("DEBUG: fetched GREEN bookmarks", $0.order, $0.szep)})
        sortedBookmarks["Red"]!.forEach({print("DEBUG: fetched RED bookmarks", $0.order, $0.szep)})
        sortedBookmarks["Blue"]!.forEach({print("DEBUG: fetched BLUE bookmarks", $0.order, $0.szep)})
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
    
    private func checkIfVersIsMarked(gepi: String) -> Bookmark? {
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
            bookmark.szoveg = vers.szoveg
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
        print("DEBUG: found bookmark on index \(index), order \(bookmark.order)")
        let context = container.viewContext
        context.delete(bookmark)
//        sortedBookmarks[color]?.remove(at: index)
        try? context.save()
        recalculateIndices(color: color)
    }
    
    //--------------------------------
    // Move bookmark
    //--------------------------------
    func moveBookmark(color: String, from source: IndexSet, to destination: Int) {
        guard var bookmarks = sortedBookmarks[color] else { return }
        bookmarks.move(fromOffsets: source, toOffset: destination)
        bookmarks.enumerated().forEach({index, bm in
            bm.order = index
            try? container.viewContext.save()
        })
        bookmarks.forEach({print("DEBUG: ", $0.order, $0.szep)})
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
        for (i, bm) in fetchedBookmarks.enumerated() {
            bm.order = i
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
        bookmark1.szoveg = "az örök élet reménységére, amelyet Isten, aki nem hazudik, örök idők előtt megígért,"
        bookmark1.gepi = "21700100200"
        bookmark1.szep = "Tit 1,2"
        bookmark1.translation = "RUF"
        bookmark1.color = "Yellow"
        bookmark1.order_ = 0
        let bookmark2 = Bookmark(context: context)
        bookmark2.szoveg = "hanem vendégszerető, a jóra hajlandó, józan, igazságos, kegyes, önmegtartóztató,"
        bookmark2.gepi = "21700100800"
        bookmark2.szep = "Tit 1,8"
        bookmark2.translation = "RUF"
        bookmark2.color = "Yellow"
        bookmark2.order_ = 1
        let bookmark3 = Bookmark(context: context)
        bookmark3.szoveg = "Egyébként pedig, testvéreim, örüljetek az Úrban! Hogy ugyanazt írjam nektek, az engem nem fáraszt, titeket viszont megerősít."
        bookmark3.gepi = "21100300100"
        bookmark3.szep = "Fil 3,1"
        bookmark3.translation = "KG"
        bookmark3.color = "Yellow"
        bookmark3.order_ = 2
        let bookmark4 = Bookmark(context: context)
        bookmark4.szoveg = "Ezek azok a népek, amelyeket helyükön hagyott az ÚR, hogy próbára tegye velük Izráelt, mindazokat, akik már mit sem tudtak a Kánaánért vívott harcokról."
        bookmark4.gepi = "10700300100"
        bookmark4.szep = "Bír 3,1"
        bookmark4.translation = "RUF"
        bookmark4.color = "Red"
        bookmark4.order_ = 0
        let bookmark5 = Bookmark(context: context)
        bookmark5.szoveg = "Izráel fiai azt tették, amit rossznak lát az ÚR. Elfeledkeztek Istenükről, az ÚRról, és a Baalokat meg az Asérákat tisztelték."
        bookmark5.gepi = "10700300700"
        bookmark5.szep = "Bír 3,7"
        bookmark5.translation = "KG"
        bookmark5.color = "Red"
        bookmark5.order_ = 1
        let bookmark6 = Bookmark(context: context)
        bookmark6.szoveg = "Hozzájuk pedig így szólt: Szabad-e szombaton jót tenni, vagy rosszat tenni, életet menteni vagy kioltani? De azok hallgattak."
        bookmark6.gepi = "20200300400"
        bookmark6.szep = "Mk 3,4"
        bookmark6.translation = "RUF"
        bookmark6.color = "Blue"
        bookmark6.order_ = 0
        let bookmark7 = Bookmark(context: context)
        bookmark7.szoveg = "Hozzájuk pedig így szólt: Szabad-e szombaton jót tenni, vagy rosszat tenni, életet menteni vagy kioltani? De azok hallgattak."
        bookmark7.gepi = "20200300400"
        bookmark7.szep = "Mk 3,4"
        bookmark7.translation = "RUF"
        bookmark7.color = "Blue"
        bookmark7.order_ = 1
        try context.save()
    }
    
}

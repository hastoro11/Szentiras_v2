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
      let context = container.viewContext
      let request = NSFetchRequest<Bookmark>(entityName: "Bookmark")
      let bookmarks = (try? context.fetch(request)) ?? []
      
      var result: [String: [Bookmark]] = [
         "Yellow": [],
         "Red": [],
         "Blue": [],
         "Green": []
      ]
      for bookmark in bookmarks {
         result[bookmark.color]!.append(bookmark)
      }
      sortedBookmarks = result
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
      let context = container.viewContext
      if let foundBookmark = checkIfVersIsMarked(gepi: String(vers.hely.gepi)) {
         foundBookmark.translation = translation
         foundBookmark.color = color
      } else {
         let bookmark = Bookmark(context: context)
         bookmark.color = color
         bookmark.gepi = String(vers.hely.gepi)
         bookmark.szep = vers.hely.szep
         bookmark.szoveg = vers.szoveg
         bookmark.translation = translation
         bookmark.order = 0
      }
      try? context.save()
      fetchBookmarks()
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
      }
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
      bookmark1.order_ = 1
      let bookmark2 = Bookmark(context: context)
      bookmark2.szoveg = "hanem vendégszerető, a jóra hajlandó, józan, igazságos, kegyes, önmegtartóztató,"
      bookmark2.gepi = "21700100800"
      bookmark2.szep = "Tit 1,8"
      bookmark2.translation = "RUF"
      bookmark2.color = "Yellow"
      bookmark2.order_ = 2
      let bookmark3 = Bookmark(context: context)
      bookmark3.szoveg = "Egyébként pedig, testvéreim, örüljetek az Úrban! Hogy ugyanazt írjam nektek, az engem nem fáraszt, titeket viszont megerősít."
      bookmark3.gepi = "21100300100"
      bookmark3.szep = "Fil 3,1"
      bookmark3.translation = "KG"
      bookmark3.color = "Yellow"
      bookmark3.order_ = 3
      let bookmark4 = Bookmark(context: context)
      bookmark4.szoveg = "Ezek azok a népek, amelyeket helyükön hagyott az ÚR, hogy próbára tegye velük Izráelt, mindazokat, akik már mit sem tudtak a Kánaánért vívott harcokról."
      bookmark4.gepi = "10700300100"
      bookmark4.szep = "Bír 3,1"
      bookmark4.translation = "RUF"
      bookmark4.color = "Red"
      bookmark4.order_ = 4
      let bookmark5 = Bookmark(context: context)
      bookmark5.szoveg = "Izráel fiai azt tették, amit rossznak lát az ÚR. Elfeledkeztek Istenükről, az ÚRról, és a Baalokat meg az Asérákat tisztelték."
      bookmark5.gepi = "10700300700"
      bookmark5.szep = "Bír 3,7"
      bookmark5.translation = "KG"
      bookmark5.color = "Red"
      bookmark5.order_ = 5
      let bookmark6 = Bookmark(context: context)
      bookmark6.szoveg = "Hozzájuk pedig így szólt: Szabad-e szombaton jót tenni, vagy rosszat tenni, életet menteni vagy kioltani? De azok hallgattak."
      bookmark6.gepi = "20200300400"
      bookmark6.szep = "Mk 3,4"
      bookmark6.translation = "RUF"
      bookmark6.color = "Blue"
      bookmark6.order_ = 6
      try context.save()
   }
   
}

## On start
- Active translation, book, chapter from UserDefaults
- Fetch actove book from network

## Books View
- Show bookbuttons
- Change bookbuttons on translationchange
- On tapping on a button show a sheet with the chapterbuttons

#### Chapter View
- On tapping set active chapter
- Close chapter view
- Select Reading Tab


## Reading View
- In pagetabview the complete book
- Changes chapter on swiping left-right
- On long press on vers: brings up bookmarkview 

### Header
- Left
	- Active book
		- on tapping: changes to books tab
	- Active chapter
		- on tapping: brings up chapter sheet
- Right
	- Translation change button
		- on tapping brigns up translation actionsheet
			- if active book is catholic: allows only catholic translations
	- Settings button - only in reading mode
		- brings up settings view: fontsize, versindexes, continouos reading 

- Middle
	- Active translation
	- Arrows to change chapter
		- Indicates if last or first chapter

## Bookmarking
- On select color: toggles bookmarking
- On select xmark: deletes bookmarking
- Saves bookmark regardless of translation: if selected, it's marked in all translations

## Bookmark View
- Show Text if there's no bookmark
- Sections for different color categories
- Deleting, ordering (within color categories)
- On long press brings up context menu with jumping to context

## Settings View
- Policy button with url 

## Others
- Cashe for books
- Network detect 
- Timing in network connections

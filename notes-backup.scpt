#!/usr/bin/osascript -l JavaScript

var app = Application.currentApplication();
app.includeStandardAdditions = true;
var notesApp = Application('Notes');
notesApp.includeStandardAdditions = true;

// choose which notes
var notes = notesApp.accounts.byName('iCloud').notes;
var whichNotes = app.chooseFromList(notes.name(), { withPrompt: "Which Notes?", multipleSelectionsAllowed: true });


if (whichNotes) {

	// choose save location
	var saveWhere = app.chooseFolder().toString();
	
	if (saveWhere) {
	
		// loop through all notes
		for(var i=0; i<notes.length; i++) {
		
			// is this note one to be exported?
			if (whichNotes.indexOf(notes[i].name()) > -1) {
			
				// save file as html
				var filename = saveWhere+"/"+notes[i].name()+".html";
				var file = app.openForAccess(Path(filename), { writePermission: true });
				app.setEof(file, { to: 0 });
				app.write(notes[i].body(), {to: file});
				app.closeAccess(file);
			}
		}
	}
}

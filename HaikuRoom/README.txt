Name: Selina Hsu-Ying Liu
PennKey: liu15
App Name: Haikuteer

App Summary:
Haikuteer is a social app for people to write and share their haikus with each other. Users can comment on each others' haikus by the way of a simple doodle. The main activities that users can perform include:
1) Sign up / Create a new account for the app (powered by Parse)
2) Log into his/her account
3) Post a new haiku and have it show up in other users' feed (On "Haiku Wall")
4) Read others' new haikus at the "Haiku Wall" tab. The user can refresh the feed by pulling the table down. This will fetch new data from the database.
5) Make a doodle (with 4 simple colors and eraser) in response to other users' haiku(s). (Users cannot draw on their own haikus)
6) Delete their own haikus at "My Haikus" tab
7) Log out of their account

Some Haikuteer rules:
1) The new haiku that the user writes must have at least 3 lines of text. Each line must be at least 3 characters long.
2) The user cannot make a doodle on his or her own haikus.
3) The user must have a unique username and email address when signing up.


Changes after in-class demo:
1) Add UIAlertView to confirm with user before he/she logs out of the app
2) During the demo, the "Haiku Wall" (feed of everyone's newly posted haikus) and "My Haikus" did not refresh after a user posted a new haiku. This has been rectified by fetching new data from the Parse database everytime either of the view controllers appears.

"Reach" features that weren't implemented:
1) A way to parse the user's new haiku to ensure that it follows the 5-7-5 syllables format, as usual haikus do, before he/she posts the haiku.

Other notes:
1) The app was renamed from "Haiku Room" to "Haikuteer" after the XCode project was created. While the package name, target name, and xcode project file have been renamed, the file directories still have the old name. But this doesn't impact the usage of the app.
2) The tab bar icons are taken from www.icons8.com/download-free-icons-for-ios-tab-bar/.
3) The sakura bloom image is taken from www.vectips.com. 

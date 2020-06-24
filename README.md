# NewsApp
********************
NEWS APP
Joey Morquecho
Intro to iOS Development
May 15, 2020
********************

* Zip file contains all necessary folders and files. To view app, open .xcodeworkspace file and run project.*

Has three main tabs/functionalities:
Your News
Categories
Search

Each Tab:
***
Your News
Displays (in collection view) articles of the categories/topics that the user 'follows', 
if user does not follow any category, "Home" articles are displayed on this tab. The user
can press on a cell to open the article in a webpage.

****
Categories
Displays (in table view) all the categories/topics a user can view. Click anywhere on a cell, 
besides the button, to see articles of that category in a collection view where the cells are 
'clickable' and take user to the article webpage. Back on the table view, user can "add" 
categories to view on "Your News" tab. These categories selected are saved with UserDefaults.

***
Search
User can search for articles (results show up in table view). Clicking on table view cell pushes 
detail view of that article and the user can go to the article webpage by pressing "Read More" in 
detail view.

*************
Known Errors:
*************
There is a limit to number of requests per minute. I've made the search functionality more efficient for 
requests but articles will not show up once this limit is hit.

# LettuceCook
Ngee Ann Polytechnic ICT Year 2 Sem 4 - MAD2 Assignment

## Team Members ##
**Chew Kah Seng** - S10208180 <br>
**Ee Jun Kai Julian** - S10202587 <br>
**Lee Kang Martin Sutton** - S10195583 <br>

## Important Notice! ##
If you want to run and test our app, after you have cloned the repo, please **Run the Workspace Executable** instead of the regular xcode executable and also **Create a New Schema** in order to run the app.

![Create New Scheme GIF](https://media.giphy.com/media/DL7LJSwk6ZQMQgmtvb/giphy.gif)

## Description ##
LettuceCook is a recipe meal application which aims to assist and inspire users to cook! Features include a personal account to store information such as shopping lists allowing users to have a more convenient way of gathering the needed ingredients. Bookmarks to keep track of recipes and notification reminder tool to help remind you what to cook next! Diet conscious users can look up the recipe nutritional information or calories intake regarding their dishes.

* [GitHub Repository](https://github.com/kahseng-dev/lettuce-cook)
* [Youtube Demo](https://www.youtube.com/watch?v=8wWApJSVmQs&feature=youtu.be)

## Design Process ##
* **Beginners**
    * Beginners may want to use our app to check out a wide variety of recipes to choose from and view the details regarding them to start cooking their dishes.
    * Through the use of the shopping list, beginners can look out for certain ingredients needed to cook their dishes.

* **Regular Cooks**
    * Regular Cooks may want to spice up their dishes by looking up other recipes regarding their normal dishes to improve them.
    * Regular Cooks may use our app to set notification reminders to help them plan out their next meal to cook.

* **Diet Conscious Users**
    * Diet conscious users can look up the recipe nutritional information like calories intake regarding their dishes.

## Roles & Contributions ##
**Chew Kah Seng** - API Integrator, Home, Account, List of Recipes View, Recipe Details, and Bookmarks
* Home
* Account Login/Create
* Recipe Details
* List of Recipes View
* Bookmark
* Nutritional Information
* Implement Meal API
* Implement Calories Ninja API
* Firebase Authentication Integration
* Firebase Realtime Database Integration

**Ee Jun Kai Julian** - Shopping List
* View Shopping List
* Add Recipe to Shopping List
* View Recipe Ingredients in Shopping List
* Save Shopping List to Firebase
* Delete Shopping List from Firebase

**Lee Kang Martin Sutton** - App Icon, Launch Screen and Reminders
* App Icon
* Launch Screen
* Reminder Core Data
* Notification Reminder
* Create Custom Reminders
* Create Recipe Reminders
* Delete Reminder Records

## Features ##
### Existing Features ###
* **Home**
  * Featured Meal
  * Browse Recipes
      * View List of Categories
      * View List of Recipes
  * Latest Recipes
      * View List of Latest Recipes
  * View Reminders

* **Profile**
  * Login/Create Account
  * When logged in, Account Information and Logout

* **Recipe Details**
  * Recipe Information
  * Set a Reminder for recipe
  * If user is logged in, they can bookmark the recipe
  * Play a Step by Step Guide to Create the Recipe
  * Ingredients List
  * Show Nutritional Information when User clicks on an ingredient

* **Bookmark**
  * When logged in, view all Bookmarked Recipes

* **Shopping List**
  * Add Recipe to Shopping List
  * Delete Shopping List
  * View Shopping List Ingredients

* **Reminders**
  * Create a Custom Reminder 
  * Create a Recipe Reminder
  * Keep records of created Reminder
  * Delete reminder records

### Features Left to Implement ###
* Completed all intended features as of (29/01/2022)

## Technologies Used ##
**Tools**
* [XCode](https://developer.apple.com/xcode/) → IDE and test environment for our app.
* [Cocoa Pods](https://cocoapods.org/) → Used to import firebase features.

**Languages**
* Swift

## Credits ##
**Content**
* [Firebase Authentication](https://firebase.google.com/docs/auth/ios/start) → Used for login and create account featuers.
* [Firebase Realtime Database](https://firebase.google.com/docs/database/ios/start) → Used to store account information.
* [Meal API](https://www.themealdb.com/) → Used to retrieve a list of recipes.
* [Calories Ninjas API](https://calorieninjas.com/api) → Used to retrieve nutritional information for a ingredient.
  
**Acknowledgements**
* [How to Create TableView in Xcode 12 (Swift 5) by iOS Academy](https://www.youtube.com/watch?v=C36sb5sc6lE)
* [Swift: Firebase Email/Password Log In & Authentication (Swift 5) Xcode 11 - 2022 by iOS Academy](https://www.youtube.com/watch?v=ife5YK-Keng)
* [Firebase Authentication Tutorial 2020 - Custom iOS Login Page (Swift) by CodeWithChris](https://www.youtube.com/watch?v=1HN7usMROt8)
* [Build Carousel Effect in iOS with Swift by David Tran](https://www.youtube.com/watch?v=XKXFRHctC6o)
* [UICollectionView inside UITableView in iOS with Swift 5 by Pushpendra Saini](https://www.youtube.com/watch?v=yt7YL2PCdxI)
* [JSON data into UITableView with images (Swift 4 + Xcode 9.0) by PlanetVeracity](https://www.youtube.com/watch?v=FNkS_QIngg8)
* [Easiest UIScrollView EVER (Xcode 11 & Swift 5) by PlanetVeracity](https://www.youtube.com/watch?v=orONrVT6CAg)
* [DispatchQueues: Serial, Concurrent, Async, & Sync – Overview by iOS Academy](https://www.youtube.com/watch?v=tVJqvPg5i6M)
* [Swift: TableView w/ Custom Cells Tutorial (2021, iOS) - 2021 by iOS Academy](https://www.youtube.com/watch?v=R2Ng8Vj2yhY)
* [Parse JSON in App Like a PRO (Xcode 12, Swift 5, 2020) - iOS Development by iOS Academy](https://www.youtube.com/watch?v=g0kOJk4hTnY)
* [What is JSON - JSON Parsing in Swift by CodeWithChris](https://www.youtube.com/watch?v=_TrPJQWD8qs)
* [How to Send Local Notification With Swift by Darren](https://programmingwithswift.com/how-to-send-local-notification-with-swift-5/)
* [How To Build Reminders iOS App in Swift 5 (Xcode 12, 2022) - Beginners by iOS Academy](https://www.youtube.com/watch?v=E6Cw5WLDe-U)
* [Remove an entire child from Firebase using Swift](https://stackify.dev/669951-remove-an-entire-child-from-firebase-using-swift)

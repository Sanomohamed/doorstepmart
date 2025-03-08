Code Structure 
main.dart 
Entry point of the app it's integrates 
Firebase core ... initializes firebase in my app
Firebase authentication  ....  Manage user authentication 
Firebase app check   ...... Protect my app from abuse
Provider   .....   Manages state using the provider packages
Geolocator ...... Access the device's location

***Main functions 
WidgetsFlutterBinding.ensureInitialization(): Ensures that flutter framework is properly initialized before running the app 

Firebase.initializeApp(): Initializes firebase with the specified options.

runApp(): Runs my application. It uses MultiProvider to provide instances of CartModel and FavoriteModel to the widget tree.

***App Class
MyApp: Is a stateless widget  that serves as the root of my application.

MaterialApp: Is the main app widget that provides navigation and theming

home: Is the initial route of the app, set to AuthWrapper.

routes: Is the mao of named routes for navigation within the app 

****AuthWrapper Class:
AuthWrapper: Is a stateless widget that determines which screen to show base on the user's authentication state.

StreamBuilder: Listens to the authentication state changes from firebase. 



****firebase_options.dart
'flutterfire configure'  this command guide through the process of setting up firebase for the app before generating the file 
firebase_options contains the default firebase configuration for different platform

****Landing.dart 
Use as the main landing page it uses a PageView and a BottomNavigationBar to allow users to navigate between different sections of the app, such as Home, Cart, Notifications, and Account.
The landing.dart file is the main landing page of the application.
It uses a PageView to display different pages (Home, Cart, Notifications, Account).
It uses a BottomNavigationBar to allow users to navigate between these pages.
The _selectedIndex keeps track of the currently selected tab, and the _pageController controls the PageView.
The initState method initializes the _pageController, and the dispose method disposes of it when the widget is removed.
The build method constructs the UI, including the PageView and BottomNavigationBar.

******Signup folder
******Signup.dart

******signupform.dart




##### need to complete reading for my product grid for now have some complication due to network image and fetch image from the firestore 
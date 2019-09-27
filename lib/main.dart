import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Following the "Your first Flutter app" codelab: https://codelabs.developers.google.com/codelabs/flutter-codelab-first

void main() {
  runApp(MyApp());
}

/// The code in [MyApp] sets up the whole app.
///
/// It creates the app-wide state (more on this later), names the app,
/// defines the visual theme, and sets the "home" widget—the starting point of your app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

/// One of the possible ways to manage state in a Flutter app is to use the
/// [ChangeNotifier] class.
///
/// This class extends the [ChangeNotifier] class, which means that it can notify
/// others about its own changes. For example, if the current word pair changes, some widgets in the app need to know.
/// The state is created and provided to the whole app using a [ChangeNotifierProvider]
/// (see code above in [MyApp]). This allows any widget in the app to get hold of the state.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  /// The getNext() method reassigns current with a new random WordPair.
  /// It also calls notifyListeners() (a method of [ChangeNotifier]) that ensures that anyone watching [MyAppState] is notified.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  /// A new property to MyAppState called favorites. This property is initialized with an empty list: []
  /// Then, specified that the list can only ever contain word pairs: [<WordPair>[]], using generics.
  /// This helps make your app more robust — Dart refuses to even run your app if you try to add anything other than WordPair to it.
  /// In turn, you can use the favorites list knowing that there can never be any unwanted objects (like null) hiding in there.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

/// The [MyHomePage] widget is the starting point of the app.
///
/// Every widget defines a build() method that's automatically called every time the widget's circumstances change so that the widget is always up to date.
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // [MyHomePage] tracks changes to the app's current state using the watch method.
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // Every build method must return a widget or (more typically) a nested tree of widgets.
    // In this case, the top-level widget is [Scaffold]. You aren't going to work with Scaffold in this codelab,
    // but it's a helpful widget and is found in the vast majority of real-world Flutter apps.
    return Scaffold(
      // [Column] is one of the most basic layout widgets in Flutter.
      // It takes any number of children and puts them in a column from top to bottom.
      // By default, the column visually places its children at the top.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // This [Text] widget takes appState, and accesses the only member of that class, current (which is a [WordPair]).
            // [WordPair] provides several helpful getters, such as asPascalCase or asSnakeCase. Here, we use asLowerCase
            BigCard(pair: pair),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Calls the toggleFavorite method on the appState object.
                    appState.toggleFavorite();
                  },
                  icon: Icon(
                    appState.favorites.contains(pair)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  label: Text('Like'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Calls the getNext method on the appState object.
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ], // Notice how Flutter code makes heavy use of trailing commas.
          // This particular comma doesn't need to be here, because children is the last (and also only) member of this particular Column parameter list.
          // Yet it is generally a good idea to use trailing commas: they make adding more members trivial, and they also serve as a hint for Dart's
          // auto-formatter to put a newline there.
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // By using theme.textTheme, you access the app's font theme.
    // This class includes members such as bodyMedium (for standard text of medium size), caption (for captions of images), or headlineLarge (for large headlines).
    // The displayMedium property is a large style meant for display text. The word display is used in the typographic sense here, such as in display typeface.
    // The documentation for displayMedium says that "display styles are reserved for short, important text"—exactly our use case
    // Calling copyWith() on displayMedium returns a copy of the text style with the changes you define. In this case, you're only changing the text's color.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      // First, the code requests the app's current theme with Theme.of(context)
      // Then, the code defines the card's color to be the same as the theme's colorScheme property.
      // The color scheme contains many colors, and primary is the most prominent, defining color of the app.
      color: theme.colorScheme.primary,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          // for accessibility.
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

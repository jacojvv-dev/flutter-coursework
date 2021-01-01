import 'package:flutter/material.dart';
import 'package:menu_app/dummy_data.dart';
import 'package:menu_app/screens/categories_screen.dart';
import 'package:menu_app/screens/category_meals_screen.dart';
import 'package:menu_app/screens/filters_screen.dart';
import 'package:menu_app/screens/meal_detail_screen.dart';
import 'package:menu_app/screens/tabs_screen.dart';

import 'models/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    "gluten": false,
    "lactose": false,
    "vegan": false,
    "vegetarian": false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoritedMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;
      _availableMeals = DUMMY_MEALS.where((x) {
        if (_filters['gluten'] && !x.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !x.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] && !x.isVegan) {
          return false;
        }
        if (_filters['vegetarian'] && !x.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavourite(String mealId) {
    final currentIndex =
        _favoritedMeals.indexWhere((element) => element.id == mealId);
    setState(() {
      if (currentIndex >= 0) {
        _favoritedMeals.removeAt(currentIndex);
      } else {
        _favoritedMeals
            .add(DUMMY_MEALS.firstWhere((element) => element.id == mealId));
      }
    });
  }

  bool _isMealFavorite(String mealId) {
    return _favoritedMeals.any((element) => element.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: Color.fromRGBO(20, 5, 51, 1),
              ),
              body2: TextStyle(
                color: Color.fromRGBO(20, 5, 51, 1),
              ),
              title: TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
      ),
      routes: {
        '/': (ctx) => TabsScreen(_favoritedMeals),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_setFilters, _filters),
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) =>
            MealDetailScreen(_toggleFavourite, _isMealFavorite),
      },
      // onGenerateRoute: (settings) {
      //   return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      // },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
      },
    );
  }
}

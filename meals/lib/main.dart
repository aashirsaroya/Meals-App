import 'package:flutter/material.dart';
import 'package:meals/dummy_data.dart';
import 'package:meals/screens/filters_screen.dart';
import 'package:meals/screens/meal_detail_screen.dart';
import 'package:meals/screens/tabs_screen.dart';
import 'screens/category_meals_screen.dart';
import 'screens/categories_screen.dart';
import './models/meal.dart';
void main()=>runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String,bool> _filters = {
    'gluten':false,
    'lactose':false,
    'vegan':false,
    'vegetarian':false
  };
  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeals = [];
  void _setFilters(Map<String,bool>filterData)
  {
     setState(() {
       _filters = filterData;

       _availableMeals = DUMMY_MEALS.where((meal){
               if( _filters['gluten'] && !meal.isGlutenFree)
                 {
                     return false;
                 }
               if( _filters['lactose'] && !meal.isLactoseFree)
               {
                 return false;
               }
               if( _filters['vegan'] && !meal.isVegan)
               {
                 return false;
               }
               if( _filters['vegetarian'] && !meal.isVegetarian)
               {
                 return false;
               }
               return true;
       }).toList();
     });
  }
  bool _isMealFavourite(String id)
  {
    return _favouriteMeals.any((meal)=> meal.id == id);
  }

  void _toggleFavourite(String mealId)
  {
    final exisitinigIndex = _favouriteMeals.indexWhere((meal)=> meal.id == mealId);
    if(exisitinigIndex >= 0)
      {
        setState(() {
          _favouriteMeals.removeAt(exisitinigIndex);
        });
      }
    else
      {
        setState(() {
          _favouriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Catalogue',
      color: Colors.black,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
          body1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            body2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
          title: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.normal,
          )
        )

      ),
      routes:{
        '/': (ctx) => TabsScreen(_favouriteMeals),
        '/category-meals': (ctx) => CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (ctx) => MealDetailScreen(_toggleFavourite,_isMealFavourite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters,_setFilters),
      } ,
    );
  }
}


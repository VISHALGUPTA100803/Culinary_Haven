import 'package:flutter/material.dart';
//import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';
//import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_drawer.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:meals_app/providers/meal_provider.dart';
import 'package:meals_app/providers/favourites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  //final List<Meal> _favouriteMeals = [];
  // Map<Filter, bool> _selectedFilters = kInitialFilters;

  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(message),
  //   ));
  // }

  // now it is managed by state notifier we no longer need this method

  // void _toggleMealFavouriteStatus(Meal meal) {
  //   final isExisting = _favouriteMeals.contains(meal);

  //   if (isExisting) {
  //     setState(() {
  //       _favouriteMeals.remove(meal);
  //       _showInfoMessage('Meal is no longer a favourite');
  //     });
  //   } else {
  //     setState(() {
  //       _favouriteMeals.add(meal);
  //       _showInfoMessage('Marked as favourite');
  //     });
  //   }
  // }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop(); // close the  drawer
    if (identifier == 'filters') {
      // Navigator.of(context).pushReplacement(
      //   // this will make sure filtersscreen is not pushed as a new screen
      //   // onto the stack of screens currently activescreen in this case tabsscreen will
      //   // be replaced with the filters screen because of that back button of phone wont work
      //   // because there is nowhere to go back to
      //   MaterialPageRoute(
      //     builder: (ctx) => FiltersScreen(),
      //   ),
      // );
      await Navigator.of(context).push<Map<Filter, bool>>(
        // it returns map data type of future
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(
              // currentFilters: _selectedFilters,
              ),
        ),
      );
      // setState(() {
      //   _selectedFilters = result ??
      //       kInitialFilters; // ?? operator in dart checks value infront of it is null and if it is null
      //   // the fallback value defined after the double question mark will be used
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    // final availiableMeals = meals.where((meal) {
    //   if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
    //     return false;
    //   }
    //   if (activeFilters[Filter.vegan]! && !meal.isVegan) {
    //     return false;
    //   }
    //   return true;
    // }).toList();

    // final meals = ref.watch(mealsProvider); // ref is a listner
    // final activeFilters = ref.watch(filtersProvider);

    final availiableMeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(
      //onToggleFavourite: _toggleMealFavouriteStatus,
      availiableMeals: availiableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favouriteMeals = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(
        meals: favouriteMeals,
        //onToggleFavourite: _toggleMealFavouriteStatus,
      );
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        // onTap: (index) {} , // index is from flutter
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}

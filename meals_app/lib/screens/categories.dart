import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen(
      {super.key,
      //required this.onToggleFavourite,
      required this.availiableMeals});
  //final void Function(Meal meal) onToggleFavourite;
  final List<Meal> availiableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync:
          this, // from this in the entire class which has now  SingleTickerProviderStateMixin merged
      //into this behind the scene the animation controller will be able to
      // get frame rate information which it needs to fire our animation once per frame
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController
        .forward(); // this will start the animation and play to its end unless
    // you stop it in between
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availiableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    // Here's how the code works step by step:
// dummyMeals is the original list of meals.
// The where method is called on dummyMeals to filter the list based on a condition.
// The condition is defined using a callback function (meal) => meal.categories.contains(category.id).
// For each meal in dummyMeals, the callback function is executed.
// The callback function checks if the categories list of the current meal contains the id of the category.
// If the condition is true, the meal is included in the filtered list.
// Finally, the toList() method is called on the filtered iterable to convert it into a new list called filteredMeals.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          // onToggleFavourite: onToggleFavourite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      // child: ,  set any widget that maybe should be output as part of the animated content,
      // but that should not be animated themselves to improve performance
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2, // height by width relation
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
        ),
        children: [
          // we want a list of widget here so we convert the map to list
          // alternative of for each loop
          // availableCategories.map((category) => CategoryGridItem(category: category) ).toList()
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      // builder: (context, child) => Padding(
      //   padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
      //   child: child,
      // ), // only padding widget will be rebuilt 60 frames per second
      builder: (context, child) => SlideTransition(
        // one position from another
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)),
        // Curves.easeInOut animation where we start slow and end slow so that we have some 
        // acceleration in the middle

        child: child,
      ),
    );
  }
}

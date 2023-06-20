import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavouriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavouriteMealsNotifier() : super([]); // used for initialising the list

  bool toggleMealFavouriteStatus(Meal meal) {
    // And this approach is not allowed when using StateNotifier,
    // you're not allowed to edit an existing value in memory,
    // instead you must always create a new one.
    // That's simply a pattern enforced by this package. Therefore,
    // we're not allowed to reach out to this list and call add or remove as we did before.
    // instead we have to replace it to replace it there is globally availiable state property made availiable by statenotifier class.

    final mealIsFavourite = state.contains(meal);

    if (mealIsFavourite) {
      state = state
          .where((m) => m.id != meal.id)
          .toList(); // .where() gives a new iterable or list
      // for removing the meal
      return false;
    } else {
      // for adding the meal
      state = [...state, meal];
      return true;
      // and set my state equal to a new list,
      //where i simply wanna keep all the existing items
      //but then also add a new one so we use spread(...) operator
      //to pull out all the elements that are stored in that list
      //and add them as individual ELEMENTS TO THIS NEW LIST,
      // and then seperated by a comma we can add yet another new element,
    }
  }
}

final favouriteMealsProvider =
    StateNotifierProvider<FavouriteMealsNotifier, List<Meal>>((ref) {
  return FavouriteMealsNotifier();
});
// StateNotifierProvider is used for data which changes like favourite meals

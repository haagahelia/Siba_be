import express, { Request, Response } from 'express';
import db from '../db/index_knex.js';
import {
  dbErrorHandler,
  requestErrorHandler,
  successHandler,
} from '../responseHandler/index.js';

const mealTracker = express.Router();

const ingredientNumberFields = [
  'id',
  'calories_per_100',
  'protein_per_100',
  'fiber_per_100',
  'sugar_per_100',
  'fat_per_100',
  'salt_per_100',
] as const;

function normalizeIngredient(row: Record<string, unknown>) {
  const normalized = { ...row };

  for (const field of ingredientNumberFields) {
    if (normalized[field] !== undefined && normalized[field] !== null) {
      normalized[field] = Number(normalized[field]);
    }
  }

  return normalized;
}

function normalizeRecipe(row: Record<string, unknown>) {
  return {
    ...row,
    id: Number(row.id),
  };
}

function normalizeRecipeIngredient(row: Record<string, unknown>) {
  return {
    ...row,
    recipe_id: Number(row.recipe_id),
    ingredient_id: Number(row.ingredient_id),
    amount: Number(row.amount),
  };
}

mealTracker.get('/ingredients', (req: Request, res: Response) => {
  db('ingredients')
    .select()
    .orderBy('id')
    .then((rows) => {
      successHandler(
        req,
        res,
        rows.map((row) => normalizeIngredient(row)),
        'Successfully read mealtracker ingredients from DB',
      );
    })
    .catch((err) => {
      dbErrorHandler(req, res, err, 'Error reading mealtracker ingredients');
    });
});

mealTracker.get('/ingredients/:id', (req: Request, res: Response) => {
  db('ingredients')
    .select()
    .where('id', req.params.id)
    .first()
    .then((row) => {
      if (!row) {
        requestErrorHandler(
          req,
          res,
          `No ingredient found with id ${req.params.id}`,
        );
        return;
      }

      successHandler(
        req,
        res,
        normalizeIngredient(row),
        'Successfully read mealtracker ingredient from DB',
      );
    })
    .catch((err) => {
      dbErrorHandler(req, res, err, 'Error reading mealtracker ingredient');
    });
});

mealTracker.get('/recipes', (req: Request, res: Response) => {
  db('recipes')
    .select()
    .orderBy('id')
    .then((rows) => {
      successHandler(
        req,
        res,
        rows.map((row) => normalizeRecipe(row)),
        'Successfully read mealtracker recipes from DB',
      );
    })
    .catch((err) => {
      dbErrorHandler(req, res, err, 'Error reading mealtracker recipes');
    });
});

mealTracker.get('/recipes/:id', (req: Request, res: Response) => {
  db('recipes')
    .select()
    .where('id', req.params.id)
    .first()
    .then((row) => {
      if (!row) {
        requestErrorHandler(req, res, `No recipe found with id ${req.params.id}`);
        return;
      }

      successHandler(
        req,
        res,
        normalizeRecipe(row),
        'Successfully read mealtracker recipe from DB',
      );
    })
    .catch((err) => {
      dbErrorHandler(req, res, err, 'Error reading mealtracker recipe');
    });
});

mealTracker.get('/recipes/:id/details', (req: Request, res: Response) => {
  db('recipes')
    .select()
    .where('id', req.params.id)
    .first()
    .then(async (recipe) => {
      if (!recipe) {
        requestErrorHandler(req, res, `No recipe found with id ${req.params.id}`);
        return;
      }

      const ingredientRows = await db('recipe_ingredients')
        .join('ingredients', 'recipe_ingredients.ingredient_id', 'ingredients.id')
        .select(
          'recipe_ingredients.recipe_id',
          'recipe_ingredients.ingredient_id',
          'recipe_ingredients.amount',
          'ingredients.name',
          'ingredients.unit',
          'ingredients.calories_per_100',
          'ingredients.protein_per_100',
          'ingredients.fiber_per_100',
          'ingredients.sugar_per_100',
          'ingredients.fat_per_100',
          'ingredients.salt_per_100',
        )
        .where('recipe_ingredients.recipe_id', req.params.id)
        .orderBy('ingredients.id');

      const details = {
        ...normalizeRecipe(recipe),
        ingredients: ingredientRows.map((row) => ({
          recipe_id: Number(row.recipe_id),
          ingredient_id: Number(row.ingredient_id),
          amount: Number(row.amount),
          ingredient: normalizeIngredient({
            id: row.ingredient_id,
            name: row.name,
            unit: row.unit,
            calories_per_100: row.calories_per_100,
            protein_per_100: row.protein_per_100,
            fiber_per_100: row.fiber_per_100,
            sugar_per_100: row.sugar_per_100,
            fat_per_100: row.fat_per_100,
            salt_per_100: row.salt_per_100,
          }),
        })),
      };

      successHandler(
        req,
        res,
        details,
        'Successfully read mealtracker recipe details from DB',
      );
    })
    .catch((err) => {
      dbErrorHandler(req, res, err, 'Error reading mealtracker recipe details');
    });
});

mealTracker.get('/recipeingredients', (req: Request, res: Response) => {
  db('recipe_ingredients')
    .select()
    .orderBy(['recipe_id', 'ingredient_id'])
    .then((rows) => {
      successHandler(
        req,
        res,
        rows.map((row) => normalizeRecipeIngredient(row)),
        'Successfully read mealtracker recipe ingredients from DB',
      );
    })
    .catch((err) => {
      dbErrorHandler(req, res, err, 'Error reading mealtracker recipe ingredients');
    });
});

mealTracker.get('/recipeingredients/:recipeId', (req: Request, res: Response) => {
  db('recipe_ingredients')
    .select()
    .where('recipe_id', req.params.recipeId)
    .orderBy('ingredient_id')
    .then((rows) => {
      successHandler(
        req,
        res,
        rows.map((row) => normalizeRecipeIngredient(row)),
        'Successfully read mealtracker recipe ingredients by recipe from DB',
      );
    })
    .catch((err) => {
      dbErrorHandler(req, res, err, 'Error reading mealtracker recipe ingredients');
    });
});

export default mealTracker;

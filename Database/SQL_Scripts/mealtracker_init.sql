CREATE DATABASE IF NOT EXISTS mealtracker;
USE mealtracker;

DROP TABLE IF EXISTS recipe_ingredients;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS ingredients;

CREATE TABLE ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    unit ENUM('g', 'ml', 'pcs') NOT NULL,
    calories_per_100 DECIMAL(8,2) NOT NULL,
    protein_per_100 DECIMAL(8,2) DEFAULT 0,
    fiber_per_100 DECIMAL(8,2) DEFAULT 0,
    sugar_per_100 DECIMAL(8,2) DEFAULT 0,
    fat_per_100 DECIMAL(8,2) DEFAULT 0,
    salt_per_100 DECIMAL(8,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE recipe_ingredients (
    recipe_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (recipe_id, ingredient_id),
    CONSTRAINT fk_recipe FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    CONSTRAINT fk_ingredient FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE
);

INSERT INTO ingredients
(name, unit, calories_per_100, protein_per_100, fiber_per_100, sugar_per_100, fat_per_100, salt_per_100)
VALUES
('Fat-free milk', 'ml', 34.00, 3.40, 0.00, 5.00, 0.10, 0.10),
('Oat flakes', 'g', 370.00, 13.00, 10.00, 1.00, 7.00, 0.01),
('Blueberries', 'g', 57.00, 0.70, 2.40, 10.00, 0.30, 0.00),
('Water', 'ml', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00),
('Banana', 'g', 89.00, 1.10, 2.60, 12.00, 0.30, 0.00),
('Greek yogurt', 'g', 97.00, 10.00, 0.00, 4.00, 5.00, 0.10),
('Peanut butter', 'g', 588.00, 25.00, 6.00, 9.00, 50.00, 0.60),
('Egg', 'pcs', 155.00, 13.00, 0.00, 1.10, 11.00, 0.12),
('Whole wheat bread', 'g', 247.00, 13.00, 7.00, 4.00, 4.20, 0.90),
('Avocado', 'g', 160.00, 2.00, 6.70, 0.70, 15.00, 0.01),
('Chicken breast', 'g', 165.00, 31.00, 0.00, 0.00, 3.60, 0.18),
('Rice, cooked', 'g', 130.00, 2.70, 0.40, 0.10, 0.30, 0.00),
('Broccoli', 'g', 35.00, 2.80, 3.30, 1.70, 0.40, 0.03),
('Olive oil', 'ml', 884.00, 0.00, 0.00, 0.00, 100.00, 0.00),
('Tomato', 'g', 18.00, 0.90, 1.20, 2.60, 0.20, 0.01),
('Cucumber', 'g', 15.00, 0.70, 0.50, 1.70, 0.10, 0.01),
('Feta cheese', 'g', 265.00, 14.00, 0.00, 4.00, 21.00, 1.10),
('Lettuce', 'g', 15.00, 1.40, 1.30, 0.80, 0.20, 0.03),
('Pasta, cooked', 'g', 157.00, 5.80, 1.80, 0.80, 0.90, 0.01),
('Tomato sauce', 'g', 29.00, 1.40, 1.50, 4.20, 0.20, 0.40),
('Parmesan', 'g', 431.00, 38.00, 0.00, 0.90, 29.00, 1.60),
('Spinach', 'g', 23.00, 2.90, 2.20, 0.40, 0.40, 0.08),
('Apple', 'g', 52.00, 0.30, 2.40, 10.00, 0.20, 0.00),
('Almonds', 'g', 579.00, 21.00, 12.50, 4.40, 50.00, 0.01),
('Honey', 'g', 304.00, 0.30, 0.00, 82.00, 0.00, 0.01),
('Strawberries', 'g', 32.00, 0.70, 2.00, 4.90, 0.30, 0.00);

INSERT INTO recipes (name, description, image_url)
VALUES
('Overnight Oats', 'Oat breakfast with milk and berries.', 'overnight-oats.jpg'),
('Berry Smoothie', 'Smoothie with banana, berries and yogurt.', 'berry-smoothie.jpg'),
('Chicken Rice Bowl', 'Simple chicken bowl with rice and broccoli.', 'chicken-rice-bowl.jpg'),
('Greek Salad', 'Fresh salad with feta and olive oil.', 'greek-salad.jpg'),
('Pasta Spinach Bowl', 'Warm pasta with spinach, tomato sauce and parmesan.', 'pasta-spinach-bowl.jpg');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount)
VALUES
(1, 1, 200.00), (1, 2, 55.00), (1, 3, 100.00), (1, 4, 150.00), (1, 5, 80.00), (1, 25, 10.00),
(2, 1, 200.00), (2, 6, 150.00), (2, 5, 100.00), (2, 3, 80.00), (2, 26, 100.00), (2, 4, 100.00),
(3, 11, 150.00), (3, 12, 180.00), (3, 13, 100.00), (3, 14, 10.00), (3, 15, 80.00),
(4, 15, 120.00), (4, 16, 100.00), (4, 17, 60.00), (4, 18, 80.00), (4, 14, 12.00), (4, 10, 70.00),
(5, 19, 200.00), (5, 20, 120.00), (5, 22, 80.00), (5, 21, 20.00), (5, 14, 8.00);

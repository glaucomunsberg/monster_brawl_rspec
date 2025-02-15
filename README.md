# b1

![image](https://flagsapi.com/US/flat/16.png) [**English**](README.md) | ![image](https://flagsapi.com/BR/flat/16.png) [Portuguese](LEIAME.md)  

The "Monster Brawl" app is an interactive game where different monsters with unique statistics, such as attack and defense, face each other. The project includes an API that allows the management of monsters and battles, offering an exciting and dynamic experience.

![](docs/76bde65f665cde678c5bf7682d9de08bd293d25c0244eb3fe2518ae5c3b1c57d.png)

## Proposal 

The goal is to create a Ruby on Rails application that explores the game rules and teaches how to use [RSpec](https://rspec.info/) for creating automated tests. This project will guide you through setting up the application, implementing the game logic, and writing tests to ensure the correctness of your code.

The best part is that you will learn how to use **csv files** to import data into the database, making the process of creating monsters and battles more efficient.

## Monster Brawl Algorithm

For calculating the battle algorithm, take into account the flow below:

* The monster with the highest speed makes the first attack, if both speeds are equal, the monster with the higher attack goes first.
* For calculating the damage, subtract the defense from the attack `(attack - defense)`; the difference is the damage; if the attack is equal to or lower than the defense, the damage is 1.
* Subtract the damage from the HP `(HP = HP - damage)`.
* Monsters will battle in turns until one wins; all turns should be calculated in the same request; for that reason, the battle endpoint should return winner data in just one call.
* Who wins the battle is the monster who subtracted the enemy’s HP to zero


# Setup

To run the project, you need to have the following tools installed:

* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)

After running the commands above, the database will be created and the migrations will be executed. Then, you need to create a `.env` file with the following command:

```bash
cp docker/api/.env.example docker/api/.env
```

Now, you need to build the application image:

```bash
docker compose build api
```

After that, you can run the following command to seed the database:
```bash
docker compose run api rails db:seed
```

## Run the Project

To run the project, you need to execute the following command:

```bash
docker compose up
```

Now, you can access the API at `http://localhost:8000`.


# API Endpoints

The API has the following endpoints:

## Monsters

* `GET /monsters`: Get all monsters
* `GET /monsters/:id`: Get a single monster
* `POST /monsters`: Create a new monster
* `PUT /monsters/:id`: Update a monster
* `DELETE /monsters/:id`: Delete a monster
* `POST /monsters/import`: Import all the CSV objects into the database

## Battles

* `GET /battles`: Get all battles
* `POST /battles`: Create a new battle
* `DELETE /battles/:id`: Delete a battle

# Tests RSpec with Factory Bot 

## Tests Coverage

The tests coverage is 100% for the models and controllers. The tests were created using [RSpec](https://rspec.info/) and [FactoryBot](https://github.com/thoughtbot/factory_bot). We have the following tests:

**Monster Controller**

- Get all monsters correctly
- Get a single monster correctly
- Get 404 error if monster does not exist
- Create a new monster
- Update a monster correctly
- Fail update when monster does not exist
- Delete a monster correctly
- Fail delete when monster does not exist
- Import all the CSV objects into the database successfully
- Fail when importing CSV file with inexistent columns
- Fail when importing CSV file with wrong columns
- Fail when importing file with different extension
- Fail when importing none file

To see the file access the link [monster_controller_spec.rb](api/spec/controllers/monster_controller_spec.rb)

**Battle Controllerrb**
- Get all battles correctly
- Create battle with bad request if one parameter is null
- Create battle with bad request if monster does not exist
- Create battle correctly with monsterA winning
- Create battle correctly with monsterB winning with equal defense and monsterB higher speed
- Delete a battle correctly
- Fail delete when battle does not exist
Verifies if a 404 error is returned when the battle to be deleted does not exist.

To see the file access the link [battle_controller_spec.rb](api/spec/controllers/battle_controller_spec.rb)

Read more about the tests in the [TEST-COVERAGE.md](TEST-COVERAGE.md) file.

## Running Tests

To run the tests, you need to execute the following command:

```bash
docker compose run api rspec
```
![](docs/Screenshot%202025-02-15%20at%208.09.36 PM.png)

# Next Steps

- Implement a feature to allow users to create their monsters and battles through the interface.
- Add a leaderboard to display the top monsters based on their wins.

# Conclusion

This project provides a comprehensive learning experience in developing a Ruby on Rails application with a focus on testing skills. By working through this project, you will gain valuable experience in:

- Accessing and managing an API to handle monsters and battles.
- Utilizing RSpec to create automated tests, ensuring the correctness and reliability of your code.
- Importing data from CSV files to efficiently populate the database with monsters and battles.

These skills are essential for building robust and maintainable applications, and this project offers a practical approach to mastering them.

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Monster.create!([{
    name: "Dead Unicorn",
    attack: 60,
    defense: 40,
    hp: 10,
    speed: 80,
    imageUrl: "https://fsl-assessment-public-files.s3.amazonaws.com/assessment-cc-01/dead-unicorn.png"
},
{
    name: "Old Shark",
    attack: 50,
    defense: 20,
    hp: 80,
    speed: 90,
    imageUrl: "https://fsl-assessment-public-files.s3.amazonaws.com/assessment-cc-01/old-shark.png"
},
{
    name: "Red Dragon",
    attack: 90,
    defense: 80,
    hp: 90,
    speed: 70,
    imageUrl: "https://fsl-assessment-public-files.s3.amazonaws.com/assessment-cc-01/red-dragon.png"
},
{
    name: "Robot Bear",
    attack: 50,
    defense: 40,
    hp: 80,
    speed: 60,
    imageUrl: "https://fsl-assessment-public-files.s3.amazonaws.com/assessment-cc-01/robot-bear.png"
},
{
    name: "Angry Snake",
    attack: 80,
    defense: 20,
    hp: 70,
    speed: 80,
    imageUrl: "https://fsl-assessment-public-files.s3.amazonaws.com/assessment-cc-01/angry-snake.png"
}])

p "Created #{Monster.count} monsters"
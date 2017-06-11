# Chess

### About
This is the final Ruby project for 'The Odin Project.' I have come a long way through the curriculum itself and through the projects I have done so here are some things I learned.

### Learned
* What file serialization is and how to implement it
* How Important it is to plan out how your project structure will work
* How much TDD/BDD is when it comes to having big projects

### Regrets
Most of these things I learned from personal expierence/fustration. I had to rewrite a lot of stuff to complete this Chess project because of lack of planning and lack of testing. I will definitely be doing a lot more of those two in the future.

Ok now to the project :)

### Usage
Use `ruby lib/board.rb` to start the game from the main project directory.

### User Inputs
* `esc` to leave game 
* `s` to leave game while saving the state
* `return` to confirm the selected action (whether that is selecting a piece to move or a location to move it to)
* `right arrow` to move to the next piece or the next location depending on the game state 
* `left arrow` to move to the previous piece or the previous location depending on the game state

### Files
* `board.rb` Contains the workflow of the game itself and the board class, which is comprised of a Pieces
* `piece.rb` contains the classes of the parent Piece class and it's children King, Queen, etc

This project is part of [TheOdinProject's](http://www.theodinproject.com) Ruby track.
The project itself can be seen [here](https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project?ref=lc-pb)!

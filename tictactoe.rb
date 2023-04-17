# current_board = '----------------------' + "\n" +
                # '- \  / - /==\ -      -' + "\n" +
                # '-  \/  -|    |-      -' + "\n" +
                # '-  /\  -|    |-      -' + "\n" +
                # '- /  \ - \==/ -      -' + "\n" +
                # '----------------------' + "\n" +
                # '-      -      -      -' + "\n" +
                # '-      -      -      -' + "\n" +
                # '-      -      -      -' + "\n" +
                # '-      -      -      -' + "\n" +
                # '----------------------' + "\n" +
                # '-      -      -      -' + "\n" +
                # '-      -      -      -' + "\n" +
                # '-      -      -      -' + "\n" +
                # '-      -      -      -' + "\n" +
                # '----------------------'
                # for the top left cell having an X, we have, counting the characters in the grid from 0 to 366,
                # \at 25,49,73,97 and /at 28,50,72 and 94.

                # for the TOP LEFT cell having an O, we have:
                # / at 25,97
                # = at 26,27,95,96
                # \ at 28,94
                # | at 47,52,70 and 75.

              
EMPTY_BOARD =  '----------------------' + "\n" +
               '-      -      -      -' + "\n" +
               '-      -      -      -' + "\n" +
               '-  1   -  2   -   3  -' + "\n" +
               '-      -      -      -' + "\n" +
               '----------------------' + "\n" +
               '-      -      -      -' + "\n" +
               '-      -      -      -' + "\n" +
               '-  4   -  5   -   6  -' + "\n" +
               '-      -      -      -' + "\n" +
               '----------------------' + "\n" +
               '-      -      -      -' + "\n" +
               '-      -      -      -' + "\n" +
               '-  7   -  8   -   9  -' + "\n" +
               '-      -      -      -' + "\n" +
               '----------------------'
               # The grid is 16 rows and 23 columns except for the last row having only 22 characters
               # because no newline is needed there. Once we know how to put an O or X in the top left
               # cell of the board, we add 7 to the character positions to go one column to the right
               # and we add 5*23 = 115 to go one row down.
               
            class Board
                attr_accessor :current_board 
                
                def initialize()
                   @current_board = EMPTY_BOARD;
                end

                def put_on_board(row,column,letter)
                    correction = 115*row + 7*column
                      # correction is how far we go further along the string to allow for being to the right and
                      # lower down than if putting the X in the top left corner
                    
                    if letter == 'X' # adds an X to the cell at row position (row) and column (column) with 
                      # rows and columns given as 0,1 or 2 respectively
                      places = [72,73,25,49,73,97,28,50,72,94].map{|num| num + correction}
                      current_board[places[0]] = ' '
                      current_board[places[1]] = ' '
                      # ensuring that the name of the cell 1 to 9 is replaced by a space first
                      (2..5).each do |i|
                        current_board[places[i]] = "\\"
                      end
                      # the positions of the backslashes in the artistic 'X'
                      
                      (6..9).each do |i|
                        current_board[places[i]] = "/"
                      end
                      # and now the forwardslashes have been drawn in. Voila! 
                      
                
                    else # adds an O to the cell at row position (row) and column (column) each numbered from
                    # 0 to 2
                    places = [72,73,25,97,28,94,26,27,95,96,47,52,70,75].map{|num| num + correction}
                    current_board[places[0]] = ' '
                    current_board[places[1]] = ' '
                    current_board[places[2]] = '/'
                    current_board[places[3]] = '/'
                    current_board[places[4]] = "\\"
                    current_board[places[5]] = "\\"
                    
                      (6..9).each do |i| 
                        current_board[places[i]] = "="
                      end
                      
                      (10..13).each do |j| 
                        current_board[places[j]] = "|"
                      end
                    end 
                end
            end

            class Cells
                attr_accessor :state

                def initialize
                  @state = Array.new(3) {Array.new(3, 'empty') }
                end
            end

            class Player
                attr_reader :name

                attr_accessor :letter

                def initialize(name)
                    @name = name
                    @letter = nil
                    # @letter will take the value O or X for each player
                end
            end

            class EndOfGame
                attr_accessor :end_game

                def initialize
                 @end_game = false
               end
               
               #t his method checks if the game is over based on the specific
               # cell that has just been filled in. That way, not every row/column/diagonal is checked
               
               def check_if_game_over(array,row,column)
                  # this is the one that wins if it is a decisive result and not a draw
                  # array will be the current state_of_game when the method is used, a 3 x 3 nested
                  # array of nil values, 'X' values and 'O' values. The output will be given as 'no result',
                  # 'X wins', 'O wins' or 'draw' and will then have to be interpreted in terms of the 
                  # player names and who was playing with Os and who with Xs.
                  
                  if (array[row][0] == array[row][1] && array[row][1] == array[row][2])
                    self.end_game = true
                    return 'win'
                    
                  end
                  if (array[0][column] == array[1][column] && array[2][column] == array[1][column])
                    self.end_game = true
                    return 'win'
                  end
                  if (row == column)
                    # check the main diagonal
                    if (array[0][0] == array[1][1] && array[1][1] == array[2][2])
                        self.end_game = true
                        return 'win'
                    end
                  end 
                  if (row + column == 2)
                    # check the non-main diagonal
                    if (array[0][2] == array[1][1] && array[1][1] == array[2][0])
                      self.end_game = true
                      return 'win'
                    end
                  end
                  # only if all of these checks dont return a result, do we then check if every cell is filled
                  if (array.flatten.compact.include?('empty') == false)
                    self.end_game = true
                    return 'draw'
                  else return 'no result'
                  end
                end
            end

            state_of_game = Cells.new()
            game_display = Board.new()
            win_checker = EndOfGame.new()
            puts "New Game! \n Player 1 name:"
            first_player = Player.new(gets.strip)
            puts "Player 2 name:"
            second_name = gets.strip
            second_name = second_name + " II" if (second_name == first_player.name)
            second_player = Player.new(second_name)
            puts "Does #{second_player.name} choose to play X's or O's?"
            inputted = gets.strip.upcase
            valid = false
            until valid do 
              if inputted == 'X' || inputted == 'O'
                choice = inputted
                valid = true
              else puts "#{second_player.name}, please type X or O to continue."
                inputted = gets.strip.upcase
              end
            end
            second_player.letter = choice
            first_player.letter = (['X','O'] - [choice])[0]
            # uses array subtraction to make one_letter 'O' if player 2 chose 'X' and vice versa
            puts "#{first_player.name} goes first with #{first_player.letter}."
            current_player = second_player
            waiting_player = first_player
            result = 'no result'
            # the loop starts by swapping the current and waiting players so we start wrongly on purpose! 
            # displays the empty board to start the game
            # now we loop do (having a turn for one player and toggling the current player for the next turn)
            # break if after using win_checker.check_if_game_over, win_checker.end_game = true

            while result == 'no result' 
              current_player,waiting_player = waiting_player,current_player
              puts game_display.current_board
              puts "#{current_player.name}, choose an empty cell numbered between 1 and 9."
              inputted = gets.strip.to_i;
                until (inputted > 0 && state_of_game.state.flatten[inputted - 1] == 'empty') do
                puts "No, please choose an empty cell by typing it's number."
                inputted = gets.strip.to_i;
                end
            # issue now is how to keep track of which player is which for a turn and who is playing 
            # X or O, efficiently without duplicating method calls. 
            # also the board display methods of put_x and put_o must be called correctly
              # now we convert the choice 1 to 9 into the row and column numbers 0 to 2.
              cell_row = (inputted - 1)/3;
              cell_column = (inputted - 1) % 3;
              state_of_game.state[cell_row][cell_column] = current_player.letter;
              result = win_checker.check_if_game_over(state_of_game.state,cell_row,cell_column)
              game_display.put_on_board(cell_row,cell_column,current_player.letter)
            end
            puts result
            if result == 'draw'
                puts game_display.current_board
                puts "The game is drawn. Well played, #{current_player.name} and #{waiting_player.name}!"
            else
                # current_player is the winner
                puts game_display.current_board
                puts "Congratulations, #{current_player.name}, you've won!
                Better luck next time, #{waiting_player.name}."
            end


               

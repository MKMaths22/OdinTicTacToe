# current_board =
# '----------------------' + "\n" +
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
# This section explains the design of the X and O for displaying during the game.
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

# the game_display will be an instance of class Board and will have the
# put_on_board method for putting X or O in the string game_display.current board using the above design
class Board
  attr_accessor :current_board

  def initialize
    @current_board = EMPTY_BOARD
  end

  def put_on_board(board, row, column, letter)
    correction = 115 * row + 7 * column
    board[72 + correction] = ' '
    board[73 + correction] = ' '
    # correction is how far we go further along the string to allow for being to the right and
    # lower down than if putting the X or O in the top left corner
    # characters 72 and 73 will 'catch' and effectively delete the placeholder number in the empty cell

    return put_x(board, correction) if letter == 'X'
    return put_o(board, correction) if letter == 'O'
  end

  def put_x(board, corr)
    places = [25, 49, 73, 97, 28, 50, 72, 94].map { |num| num + corr }
      
    (0..3).each do |i|
      board[places[i]] = '\\'
    end
      # the positions of the backslashes in the artistic 'X'

    (4..7).each do |i|
      board[places[i]] = '/'
    end
      # and now the forwardslashes have been drawn in. Voila!
    return board
  end

  def put_o(board, corr)
      # adds an O to the cell at row position (row) and column (column) each numbered from 0 to 2
      places = [25, 97, 28, 94, 26, 27, 95, 96, 47, 52, 70, 75].map { |num| num + corr }
      board[places[0]] = '/'
      board[places[1]] = '/'
      board[places[2]] = '\\'
      board[places[3]] = '\\'

      (4..7).each do |i|
        board[places[i]] = '='
      end

      (8..11).each do |j|
        board[places[j]] = '|'
      end
      return board
  end

end

# state_of_game will be an instance of the class Cells to store the cells as a 3 x 3 array
class Cells
  attr_accessor :state

  def initialize
    @state = Array.new(3) { Array.new(3, 'empty') }
  end
end

# Both players will be instances of the Player class, player_one and player_two
class Player
  attr_reader :name

  attr_accessor :letter

  def initialize(name)
    @name = name
    @letter = nil
    # @letter will take the value O or X for each player
  end
end

# win_checker will be an instance of EndOfGame, housing the method for checking if the game has finished.
class EndOfGame
  def check_if_game_over(array, row, column)
    # this is the one that wins if it is a decisive result and not a draw
    # the method checks if the game is over based on the specific
    # cell that has just been filled in. That way, not every row/column/diagonal is checked
    # array will be the current state_of_game when the method is used, a 3 x 3 nested
    # array of nil values, 'X' values and 'O' values. The output will be given as 'no result',
    # 'X wins', 'O wins' or 'draw' and will then have to be interpreted in terms of the
    # player names and who was playing with Os and who with Xs.

    return 'win' if array[row][0] == array[row][1] && array[row][1] == array[row][2]

    return 'win' if array[0][column] == array[1][column] && array[2][column] == array[1][column]

    return 'win' if row == column && array[0][0] == array[1][1] && array[1][1] == array[2][2]
    # check the main diagonal

    return 'win' if row + column == 2 && array[0][2] == array[1][1] && array[1][1] == array[2][0]
    # check the non-main diagonal
    # only if all of these checks dont return a result, do we then check if every cell is filled

    return 'draw' if array.flatten.compact.include?('empty') == false

    return 'no result'
    # if method has not yet returned a value, there must be no result of the game
  end
end

def play_game
  state_of_game = Cells.new
  game_display = Board.new
  win_checker = EndOfGame.new
  puts "New Game! \n Player 1 name:"
  first_player = Player.new(gets.strip)
  puts 'Player 2 name:'
  second_name = gets.strip
  second_name += ' II' if second_name == first_player.name
  # A way of distinguishing players of the same name!

  second_player = Player.new(second_name)
  puts "Does #{second_player.name} choose to play X's or O's?"
  inputted = gets.strip.upcase

  valid = false

  until valid do
    if ['X', 'O'].include?(inputted)
      choice = inputted
      valid = true
    else
      puts "#{second_player.name}, please type X or O to continue."
      inputted = gets.strip.upcase
    end
  end

  second_player.letter = choice
  first_player.letter = (['X', 'O'] - [choice])[0]
  # uses array subtraction to make one_letter 'O' if player 2 chose 'X' and vice versa

  puts "#{first_player.name} goes first with #{first_player.letter}."
  current_player = second_player
  waiting_player = first_player
  result = 'no result'
  # the loop below starts by swapping the current and waiting players so we start wrongly on purpose!
  # the loop lasts for one turn of the game by one player

  puts game_display.current_board
  # displays the current board position

  while result == 'no result'
    current_player, waiting_player = waiting_player, current_player
    puts "#{current_player.name}, choose an empty cell numbered between 1 and 9."
    inputted = gets.strip.to_i

    until inputted.positive? && state_of_game.state.flatten[inputted - 1] == 'empty' do
      puts "No, please choose an empty cell by typing it's number."
      inputted = gets.strip.to_i
    end

    cell_row = (inputted - 1) / 3
    cell_column = (inputted - 1) % 3
    # converts the choice 1 to 9 into the row and column numbers 0 to 2. cell_row uses Ruby integer division
    # to give the quotient only, which is exactly what is needed!

    state_of_game.state[cell_row][cell_column] = current_player.letter
    result = win_checker.check_if_game_over(state_of_game.state, cell_row, cell_column)
    # updating value of result based on latest change to the game state

    game_display.current_board =
     game_display.put_on_board(game_display.current_board, cell_row, cell_column, current_player.letter)
    puts game_display.current_board
    # updates the board display string and displays it
  end

  # after the while loop, the following code executes as soon as the game has a result

  if result == 'draw'
    puts "The game is drawn. Well played, #{current_player.name} and #{waiting_player.name}!"
  else
    # current_player is the winner

    puts "Congratulations, #{current_player.name}, you've won! Better luck next time, #{waiting_player.name}."
  end
end
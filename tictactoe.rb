current_board = '----------------------' + "\n" +
                '- \  / - /==\ -      -' + "\n" +
                '-  \/  -|    |-      -' + "\n" +
                '-  /\  -|    |-      -' + "\n" +
                '- /  \ - \==/ -      -' + "\n" +
                '----------------------' + "\n" +
                '-      -      -      -' + "\n" +
                '-      -      -      -' + "\n" +
                '-      -      -      -' + "\n" +
                '-      -      -      -' + "\n" +
                '----------------------' + "\n" +
                '-      -      -      -' + "\n" +
                '-      -      -      -' + "\n" +
                '-      -      -      -' + "\n" +
                '-      -      -      -' + "\n" +
                '----------------------'
                #for the top left cell having an X, we have, counting the characters in the grid from 0 to 366,
                #\at 25,49,73,97 and /at 28,50,72 and 94.

                #for the TOP LEFT cell having an O, we have:
                #/ at 25,97
                # = at 26,27,95,96
                #\ at 28,94
                #| at 47,52,70 and 75.

              
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
               #The grid is 16 rows and 23 columns except for the last row having only 22 characters
               #because no newline is needed there. Once we know how to put an O or X in the top left
               #cell of the board, we add 7 to the character positions to go one column to the right
               #and we add 5*23 = 115 to go one row down.
               
            class Board
                attr_accessor :current_board, :cells_used;
                def initialize()
                   @current_board = EMPTY_BOARD;
                   @cells_state = Array.new(3) {Array.new(3,'empty')};
                   @turns_taken = 0;
                end

                def put_x(row,column)
                    #adds an X to the cell at row position (row) and column (column) with rows
                    #and columns given as 0,1 or 2 respectively
                    correction = 115*row + 7*column;
                    #correction is how far we go further along the string to allow for being to the right and
                    #lower down than if putting the X in the top left corner
                    places = [72,73,25,49,73,97,28,50,72,94].map{|num| num + correction}
                    current_board[places[0]] = ' '
                    current_board[places[1]] = ' '
                    #ensuring that the name of the cell 1 to 9 is replaced by a space first
                    for i in (2..5) do 
                        current_board[places[i]] = "\\"
                    end
                    #the positions of the backslashes in the artistic 'X'
                    for j in (6..9) do 
                         current_board[places[j]] = "/"
                    end
                    #and now the forwardslashes have been drawn in. Voila! 
                end

                def put_o(row,column)
                #adds an O to the cell at row position (row) and column (column) each numbered from 0 to 2
                  correction = 115*row + 7*column
                  #correction is how far we go further along the string to allow for being to the right and
                  #lower down than if putting the O in the top left corner
                  places = [72,73,25,97,28,94,26,27,95,96,47,52,70,75].map{|num| num + correction}
                  current_board[places[0]] = ' '
                  current_board[places[1]] = ' '
                  current_board[places[2]] = '/'
                  current_board[places[3]] = '/'
                  current_board[places[4]] = "\\"
                  current_board[places[5]] = "\\"
                    for i in (6..9) do
                      current_board[places[i]] = "="
                    end
                    for i in (10..13) do
                      current_board[places[i]] = "|"
                    end

                #correction is how far we go further along the string to allow for being to the right and
                #lower down than if putting the O in the top left corner


                end

            end

            game = Board.new()
            game.put_o(2,2)
            game.put_o(1,1)
            game.put_x(0,1)
            game.put_x(0,0)
            game.put_o(2,0)
            game.put_o(2,1)
            puts game.current_board;
               

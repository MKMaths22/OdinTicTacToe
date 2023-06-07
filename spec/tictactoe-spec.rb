# spec/tictactoe-spec.rb
require '../lib/tictactoe'

describe Board do

  describe "#put_on_board" do
    context "the board is empty" do
      subject(:empty_board) { described_class.new }
      let(:modified_board) { EMPTY_BOARD }

      it "clears characters 72 and 73 from the board string and calls put_x if letter = x" do
        modified_board[72] = ''
        modified_board[73] = ''
        expect(empty_board.put_on_board(EMPTY_BOARD, 0, 0, 'X')).to eq(empty_board.put_x(modified_board, 0))
      end

      it "clears characters 72 and 73 from the board string and calls put_y if letter = y" do
        modified_board[72] = ''
        modified_board[73] = ''
        expect(empty_board.put_on_board(EMPTY_BOARD, 0, 0, 'O')).to eq(empty_board.put_o(modified_board, 0))
      end
   
      it "puts x in the bottom left corner" do
        modified_board[72 + 2*115] = ''
        modified_board[73 + 2*115] = ''
        expect(empty_board.put_on_board(EMPTY_BOARD, 0, 2, 'O')).to eq(empty_board.put_o(modified_board, 230))
      end
    end
  # other contexts are possible with non-empty boards but this is tedious to code
  end

  describe "#put_x" do
    context "the board has O in the top left and bottom right corners and an X in the middle of the left column" do
      # initializing a new Board object makes the board empty. This method does not care about the state of the Board.
      # the method just accepts the board and correction (codifying where to put the x) as arguments and outputs the 
      # board after an x has been put in the right place
      subject(:new_board) { described_class.new }
      current_board = 
      '----------------------' + "\n" +
      '- /==\ -      -       ' + "\n" +
      '-|    |-      -       ' + "\n" +
      '-|    |-      -       ' + "\n" +
      '- \==/ -      -       ' + "\n" +
      '----------------------' + "\n" +
      '- \  / -      -      -' + "\n" +
      '-  \/  -      -      -' + "\n" +
      '-  /\  -      -      -' + "\n" +
      '- /  \ -      -      -' + "\n" +
      '----------------------' + "\n" +
      '-      -      - /==\ -' + "\n" +
      '-      -      -|    |-' + "\n" +
      '-      -      -|    |-' + "\n" +
      '-      -      - \==/ -' + "\n" +
      '----------------------'
      # to put an x in the centre, the variable 'correction' will be 115 + 7 = 122
      it 'outputs the same board but with x in the centre square' do
        changed_board = 
        '----------------------' + "\n" +
        '- /==\ -      -       ' + "\n" +
        '-|    |-      -       ' + "\n" +
        '-|    |-      -       ' + "\n" +
        '- \==/ -      -       ' + "\n" +
        '----------------------' + "\n" +
        '- \  / - \  / -      -' + "\n" +
        '-  \/  -  \/  -      -' + "\n" +
        '-  /\  -  /\  -      -' + "\n" +
        '- /  \ - /  \ -      -' + "\n" +
        '----------------------' + "\n" +
        '-      -      - /==\ -' + "\n" +
        '-      -      -|    |-' + "\n" +
        '-      -      -|    |-' + "\n" +
        '-      -      - \==/ -' + "\n" +
        '----------------------'
        expect(new_board.put_x(current_board, 122)).to eq(changed_board)
      end
    end
  end
end

describe EndOfGame do
  describe "#check_if_game_over" do
    context "a game is in progress" do
      subject(:end_of_game) { described_class.new }
        it 'declares a draw when the board is full and no player has won' do
          array = [['X', 'O', 'X'], ['O', 'O', 'X'], ['X', 'X', 'O']]
          row = 2
          column = 0
          expect(end_of_game.check_if_game_over(array, row, column)).to eq('draw')
        end

        it 'declares a win when a column has been completed' do
          array = [['X', 'O', 'empty'], ['empty', 'O', 'X'], ['empty', 'O', 'empty']]
          row = 2
          column = 1
          expect(end_of_game.check_if_game_over(array, row, column)).to eq('win')
        end

        it 'declares a win when a row has been completed' do
          array = [['X', 'X', 'X'], ['O', 'empty', 'empty'], ['O', 'O', 'empty']]
          row = 0
          column = 1
          expect(end_of_game.check_if_game_over(array, row, column)).to eq('win')
        end

        it 'declares a win when a diagonal has been completed' do
          array = [['O', 'O', 'X'], ['X', 'X', 'O'], ['X', 'O', 'X']]
          row = 1
          column = 1
          expect(end_of_game.check_if_game_over(array, row, column)).to eq('win')
        end

        it 'declares no result when board not full and no one has won' do
          array = [['X', 'empty', 'empty'], ['empty', 'X', 'O'], ['O', 'X', 'O']]
          row = 2
          column = 1
          expect(end_of_game.check_if_game_over(array, row, column)).to eq('no result')
        end
      end
  end
end



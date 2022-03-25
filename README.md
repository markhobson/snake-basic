# Snake BASIC

An implementation of [Snake](https://en.wikipedia.org/wiki/Snake_(video_game_genre)) written in [QBasic](https://en.wikipedia.org/wiki/QBasic) out of boredom whilst temping at HSBC Vancouver in 1999.

## Running the game

1. Install [DOSBox](https://www.dosbox.com/):

        sudo apt install dosbox
        
1. Increase the resolution if required by editing `~/.dosbox/dosbox-0.74-3.conf` as follows:

    	windowresolution=2048x1536
    	output=opengl

1. Download [QBasic 1.1](https://www.qbasic.net/en/qbasic-downloads/compiler/qbasic-interpreter.htm)
1. Extract QBasic into the project directory:

        unzip qb11.zip

1. Run DOSBox:

        dosbox

1. Mount and change to project directory:

        mount c .
        c:

1. Open the game in QBasic:

        QBASIC.EXE P.BAS
        
1. Press F5 to run the game

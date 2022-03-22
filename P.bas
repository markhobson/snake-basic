DECLARE SUB MoveSnake (x%, y%)
DECLARE SUB AddSnake (x%, y%)
DECLARE SUB EndScreen ()
DECLARE SUB PlayGame ()
DECLARE SUB Initialise ()
DECLARE SUB GameScreen ()
DECLARE SUB PlotBox (x1%, y1%, x2%, y2%)
DECLARE SUB Make Food (x1%, y1%, x2%, y2%)

TYPE FoodType
    x AS INTEGER
    y AS INTEGER
    n AS INTEGER
END TYPE

TYPE SnakeType
    x AS INTEGER
    y AS INTEGER
END TYPE

Columns% = 80
Rows% = 25
FoodN% = 20
SnakeN% = (9 * FoodN%) + 1
SnakeX% = Columns% / 2
SnakeY% = Rows% / 2
SnakeStart% = 0
SnakeEnd% = 1
SnakeMax& = 100000
SnakeDec& = 0

DIM SHARED Food (1 TO FoodN%) AS FoodType
DIM SHARED Snake (1 TO SnakeN%) AS SnakeType

CALL GameScreen
CALL PlayGame
CALL EndScreen

END

SUB AddSnake (x%, y%)

    SHARED SnakeStart%, SnakeN%

    SnakeStart% = SnakeStart% + 1
    IF SnakeStart% > SnakeN% THEN SnakeStart% = 1

    Snake(SnakeStart%).x = x%
    Snake(SnakeStart%).y = y%

    COLOR 10
    LOCATE y%, x%
    PRINT CHR$(219);

END SUB

SUB EndScreen

    SCREEN O
    COLOR 7, 0
    CLS

END SUB

SUB Game Screen

    SHARED Columns%, Rows%

    SCREEN O
    WIDTH Columns%, Rows%
    CLS

    COLOR 11, 1
    CALL PlotBox(1, 1, Columns%, Rows%)
    COLOR 14
    CALL MakeFood(2, 2, Columns% - 1, Rows% - 1)

END SUB

SUB MakeFood (x1%, y1%, x2%, y2%)

    SHARED FoodN%, SnakeX%, SnakeY%

    RANDOMIZE TIMER

    FOR i% = 1 TO FoodN%
    
        DO
            ok% = 1
            x% = (RND * (x2% - x1%)) + x1%
            y% = (RND * (y2% - y1%)) + y1%
            n% = (RND 8) + 1
            IF x% = SnakeX% AND y% = SnakeY% THEN ok% = 0
            IF i% > 1 THEN
                FOR j% = 1 TO i% - 1
                    IF x% = Food(j%).x AND y% = Food(j%).y THEN ok% = 0
                NEXT j%
            END IF
        LOOP UNTIL ok%

        LOCATE y%, x%
        PRINT CHR$(48 + n%);

        Food(i%).x = x%
        Food(i%).y = y%
        Food(i%).n = n%

    NEXT i%

END SUB

SUB MoveSnake (x%, y%)

    SHARED SnakeStart%, SnakeEnd%, SnakeN%

    LOCATE Snake(SnakeEnd%).y, Snake(SnakeEnd%).x
    PRINT " ";

    SnakeEnd% = SnakeEnd% + 1
    IF SnakeEnd% > SnakeN% THEN SnakeEnd% = 1

    SnakeStart% = SnakeStart% + 1
    IF SnakeStart% > SnakeN% THEN SnakeStart% = 1

    Snake(SnakeStart%).x = x%
    Snake(SnakeStart%).y = y%

    COLOR 10
    LOCATE Snake(SnakeStart%).y, Snake(SnakeStart%).x
    PRINT CHR$(219);

END SUB

SUB PlayGame

    SHARED Columns%, Rows%
    SHARED SnakeX%, SnakeY%, SnakeMax&, SnakeDec&, SnakeStart%, SnakeEnd%
    SHARED SnakeN%, FoodN%

    dead% = 0
    quit% = 0
    x% = SnakeX%
    y% = SnakeY%
    dx% = 0
    dy% = 0
    add% = 0
    speed& = SnakeMax&
    foodleft% = FoodN%
    CALL AddSnake(x%, y%)

    DO

    LOCATE 1, 1
    PRINT foodleft%

    SELECT CASE INKEYS

        CASE "z", "Z"
            dx% = -1
            dy% = 0

        CASE "x", "X"
            dx% = 1
            dy% = 0

        CASE "'", CHR$(34)
            dx% = 0
            dy% = -1

        CASE "/", "?"
            dx% = 0
            dy% = 1

        CASE "p", "P"
            COLOR 10
            LOCATE 1, (Columns% / 2) - 4
            PRINT " Paused "
            DO
                key$ = INKEY$
            LOOP UNTIL key$ = "o" OR key$ = "O"
            COLOR 11
            LOCATE 1, (Columns% / 2) - 4
            PRINT STRING$(8, CHR$(205))

        CASE CHR$(27)
            quit% = 1

    END SELECT

    x% = x% + dx%
    y% = y% + dy%

    IF x% = 1 OR x% = Columns% OR y% = 1 OR y% = Rows% THEN dead% = 1

    IF (NOT dead%) AND (dx% <> 0 OR dy% <> 0) THEN

        FOR i% = 1 TO FoodN%
            IF x% = Food(i%).x AND y% = Food(i%).y THEN
                add% = add% + Food(i%).n
                foodleft% = foodleft% - 1
                speed& = speed& - SnakeDec&
            END IF
        NEXT i%

        i% = SnakeEnd%
        DO
            IF x% = Snake(i%).x AND y% = Snake(i%).y THEN dead% = 1
            oldi% = i%
            i% = i% + 1
            IF i% > SnakeN% THEN i% = 1
        LOOP UNTIL oldi% = SnakeStart%

        IF NOT dead% THEN

            IF add% = 0 THEN
                CALL MoveSnake(x%, y%)
            ELSE
                CALL AddSnake%(x%, y%)
                add% = add% - 1
            END IF

            FOR i& = 1 TO speed&
            NEXT i&

        END IF

    END IF

    LOOP UNTIL dead% OR quit% OR foodleft% = 0

    IF foodleft% = 0 THEN
        LOCATE 2, 2
        PRINT "Nice one geezer !"
        DO WHILE INKEY$ = ""
        LOOP
    END IF

    IF dead% THEN
        LOCATE 2, 2
        PRINT "You died !"
        DO WHILE INKEY$ = ""
        LOOP
    END IF

END SUB

SUB PlotBox (x1%, y1%, x2%, y2%)

    LOCATE y1%, x1%
    PRINT CHR$(201); STRING$(x2% - x1% - 1, CHR$(205)); CHR$(187);

    IF (y2% - y1%) > 1 THEN
        FOR y% = y1% + 1 TO y2% - 1
            LOCATE y%, x1%
            PRINT CHR$(186); SPC(x2% - x1% - 1); CHR$(186);
        NEXT y%
    END IF

    LOCATE y2%, x1%
    PRINT CHR$(200); STRING$(x2% - x1% - 1, CHR$(205)); CHR$(188);

END SUB

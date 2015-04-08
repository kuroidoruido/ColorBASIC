DIM x AS Integer = 66
DIM y AS Integer = 99
DIM z AS String = "666"

'simple <
IF 1 < x THEN
	PRINT "Hello !"
END IF

'simple >=
IF x >= y THEN
	PRINT "Hello !"
END IF

'simple =
IF x = 2 THEN
	PRINT "Hello !"
END IF

'simple = with string
IF "3" = z THEN
	PRINT "Hello !"
END IF

'simple multi inst
IF 4 < 5 THEN
	PRINT "Hello"
	PRINT "world!"
	PRINT "The"
	PRINT "Doctor"
	PRINT "and"
	PRINT "his"
	PRINT "TARDIS!"
END IF

'if then else
IF 6 < 7 THEN
	PRINT "Hello !"
ELSE
	PRINT "World"
END IF

'if then elseif else
IF 8 > 9 THEN
	PRINT "Hello !"
ELSEIF 10 < 11 THEN
	PRINT "Tardis"
ELSE
	PRINT "World"
END IF

'if then elseif
IF 12 > 13 THEN
	PRINT "Hello !"
ELSEIF 14 < 15 THEN
	PRINT "Tardis"
END IF

'if then elseif elseif else
IF 16 > 17 THEN
	PRINT "Hello !"
ELSEIF 18 < 19 THEN
	PRINT "Tardis"
ELSEIF 20 < 21 THEN
	PRINT "Doctor"
ELSE
	PRINT "World"
END IF

'if in if
IF 22 > 23 THEN
	IF 24 > 25 THEN
		PRINT "Hello"
	END IF
END IF

'if in else + empty if
IF 26 > 27 THEN
ELSE
	IF 28 > 29 THEN
		PRINT "Hello"
	END IF
END IF

' if in elseif
IF 30 > 31 THEN
ELSEIF 32 > 33 THEN
	IF 34 > 35 THEN
		PRINT "Hello"
	END IF
END IF

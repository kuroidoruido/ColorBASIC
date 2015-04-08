'simple <
IF 1 < 2 THEN
	PRINT "Hello !"
END IF

'simple >=
IF 1 >= 2 THEN
	PRINT "Hello !"
END IF

'simple =
IF 1 = 2 THEN
	PRINT "Hello !"
END IF

'simple = with string
IF "1" = "2" THEN
	PRINT "Hello !"
END IF

'simple multi inst
IF 1 < 2 THEN
	PRINT "Hello"
	PRINT "world!"
	PRINT "The"
	PRINT "Doctor"
	PRINT "and"
	PRINT "his"
	PRINT "TARDIS!"
END IF

'if then else
IF 1 < 2 THEN
	PRINT "Hello !"
ELSE
	PRINT "World"
END IF

'if then elseif else
IF 1 > 2 THEN
	PRINT "Hello !"
ELSEIF 1 < 2 THEN
	PRINT "Tardis"
ELSE
	PRINT "World"
END IF

'if then elseif
IF 1 > 2 THEN
	PRINT "Hello !"
ELSEIF 1 < 2 THEN
	PRINT "Tardis"
END IF

'if then elseif elseif else
IF 1 > 2 THEN
	PRINT "Hello !"
ELSEIF 1 < 2 THEN
	PRINT "Tardis"
ELSEIF 1 < 2 THEN
	PRINT "Doctor"
ELSE
	PRINT "World"
END IF

'if in if
IF 1 > 2 THEN
	IF 1 > 2 THEN
		PRINT "Hello"
	END IF
END IF

'if in else + empty if
IF 1 > 2 THEN
ELSE
	IF 1 > 2 THEN
		PRINT "Hello"
	END IF
END IF

' if in elseif
IF 1 > 2 THEN
ELSEIF 2 > 3 THEN
	IF 1 > 2 THEN
		PRINT "Hello"
	END IF
END IF

DIM i AS Integer = 0
DIM j AS Integer = 0

WHILE i < 5
	PRINT "Hello"
	i = 1 + i
WEND

i = 0

WHILE i < 2
	WHILE j < 2
		PRINT "Hello"
		j = j + 1
	WEND
	i = i + 1
WEND

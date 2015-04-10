DIM x AS Integer = 0'n-2
DIM y AS Integer = 1'n-1
DIM tmp AS Integer

PRINT "== Suite de Fibonacci == "

PRINT x
PRINT y
	
DIM i AS Integer = 30

WHILE i > 0
	tmp = x
	x = y
	y = x + tmp
	PRINT y
	i = i - 1
WEND

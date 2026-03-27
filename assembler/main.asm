; Fibonacci Sequence

loop:
; c = b + a
c c next ; c = 0
x x next ; x = 0
b x next ; x = 0 - b
a x next ; x = -b - a = -(b + a)
x c next ; c = -(-(b + a)) = b + a

; a = b
a a next ; a = 0
x x next ; x = 0
b x next ; x = -b
x a next ; a = -(-b)

; b = c
b b next ; b = 0
x x next ; x = 0
c x next ; x = -c
x b next ; b = -(-c)

; jump loop
z z loop

; temporary variable
x: 0

; initialise a, b, c
a: 0
b: 1
c: 0

z: 0

; expected values
; 1	0001
; 1	0001
; 2	0002
; 3	0003
; 5	0005
; 8	0008
; 13	000d
; 21	0015
; 34	0022
; 55	0037
; 89	0059
; 144	0090
; 233	00e9
; 377	0179
; 610	0262
; 987	03db
; 1597	063d
; 2584	0a18
; 4181	1055
; 6765	1a6d
; 10946	2ac2
; 17711	452f
; 28657	6ff1
; 46368	b520

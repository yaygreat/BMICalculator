		.data
askname:		.asciiz	"What is your name? "
askheight:	.asciiz	"Please enter your height in inches: "
askweight:	.asciiz	"Now enter your weight in pounds (round to a whole number): "
bmimsg:		.asciiz	"Your bmi is: "
undermsg:	.asciiz	" This is considered underweight."
normalmsg:	.asciiz	" This is a normal weight."
overmsg:		.asciiz	" This is considered overweight."
obesemsg:	.asciiz	" This is considered obese."
height:		.word	0
weight:		.word	0
bmi:		.float	0
name:		.space	24
und:		.float	18.25
norm:		.float	25
ov:		.float	30

		.text
main:
	#prompt user for their name
	li	$v0, 4
	la	$a0, askname
	syscall
	#store their name
	la	$a0, name
	la	$a1, 24
	li	$v0, 8
	syscall
	#prompt user for their height
	li	$v0, 4
	la	$a0, askheight
	syscall
	#store input into height
	li	$v0, 5
	syscall
	sw	$v0, height
	#prompt user for their weight
	li	$v0, 4
	la	$a0, askweight
	syscall
	#store input into weight
	li	$v0, 5
	syscall
	sw	$v0, weight
	
	#load all variables- user inputed ints
	#and convert to float single precision
	lw	$t1, weight
	li	$t3, 703
	mul	$t1, $t1, $t3	#weight *= 703
	mtc1	$t1, $f5		#convert from int to float
	cvt.s.w	$f5, $f5
	lw	$t2, height
	mul	$t2, $t2, $t2	#height *= height
	mtc1	$t2, $f7		#convert from int to float
	cvt.s.w	$f7, $f7
	#calculate bmi
	div.s	$f0, $f5, $f7	#weight / height
	la	$t0, bmi
	s.s	$f0, ($t0)	#store calculation into bmi var
	
	#output the results
	#display user's name
	li 	$v0, 4
	la 	$a0, name
	syscall
	#display the results
	li 	$v0, 4		#print: "Your bmi is: "
	la 	$a0, bmimsg
	syscall
	#print bmi
	li 	$v0, 2		#syscall code (2) for printing float
	mov.s 	$f12, $f0
	syscall
	
	#branch for different messages
	#if bmi < 18.25: underweight msg
	la	$t0, und
	l.s	$f3, ($t0)
	c.lt.s	$f0, $f3
	bc1t	under
	#if 18.25 < bmi < 25: normal weight msg
	la	$t0, norm
	l.s	$f3, ($t0)
	c.lt.s	$f0, $f3
	bc1t	normal
	#if 25 < bmi < 30: overweight msg
	la	$t0, ov
	l.s	$f3, ($t0)
	c.lt.s	$f0, $f3
	bc1t	over
	#if bmi > 30: obese msg
	la	$t0, ov
	l.s	$f3, ($t0)
	c.lt.s	$f0, $f3
	bc1f	obese

under:
	li 	$v0, 4		#print: This is considered underweight.
	la 	$a0, undermsg
	syscall
	j	exit
normal:
	li 	$v0, 4		#print: This is a normal weight.
	la 	$a0, normalmsg
	syscall
	j	exit
over:
	li 	$v0, 4		##print: This is considered overweight.
	la 	$a0, overmsg
	syscall
	j	exit
obese:
	li 	$v0, 4		#print: This is considered obese.
	la 	$a0, obesemsg
	syscall
	j	exit
	
exit:
	li	$v0, 10
	syscall

#Brendan Grant
#4/9/2021
#CS 2400
#
#		Code to find and print the sign, mantissa, exponent, and approximate decimal representation for
#	IEEE 754 and TNS encoded floating point numbers.
#		The number being converted is the last variable created in the .data section, and includes examples.
#

.data
	
	prompt:.asciiz "Enter 1 for IEEE 754 or 0 for TNS: "
	mant:.asciiz "Mantissa = "
	exp:.asciiz "Exponent = "
	sign:.asciiz "Sign is "
	nega:.asciiz "negative.\n"
	pos:.asciiz "positive.\n"
	deci:.asciiz "Decimal = "
	nl:.asciiz "\n"
	
	float1:.float 1.0	#for storing mantissa
	float2:.float 2.0	#for calculating exponent
	
				#	IEEE		TNS		Decimal
	hex:.word  0xde86010e	#	0x41640000	0x64000103	14.25
				#	0x3b5844d0	0x5844d0f7	0.00329999998212
				#	0xc6de8600	0xde86010e	-28483

.text

main:
	#Print prompt, store opt
	li $v0,4
	la $a0,prompt
	syscall
	
	li $v0,5
	syscall
	
	move $t0,$v0
	
	li $v0,4
	la $a0,nl
	syscall
	
	beqz $t0,tns
	
ieee:	#store hex value in reg
	lw $t0,hex
	
	#store the mantissa (23 bits)
	andi $t2,$t0,0x7FFFFF		#mantissa = $t2
	srl $t0,$t0,23
	
	move $a1,$t2				#store mantissa in argument reg
	jal findMant
	
	#store the exponent (1 byte)
	andi $t1,$t0,0xFF		#exponent = $t1
	srl $t0,$t0,8			#sign = $t0
	
	subi $t1,$t1,127		#subtract 127 from exponent for correct value
	
	j printResult
	
tns:	#store hex value in reg
	lw $t0,hex

	#store the exponent (9 bits)
	andi $t1,$t0,0x1FF		#exponent = $t1
	srl $t0,$t0,9			
	
	subi $t1,$t1,256		#subtract 256 from exponent for correct value

	#store the mantissa (22 bits)
	andi $t2,$t0,0x3FFFFF		#mantissa = $t2
	sll $t2,$t2,1			#move mantissa left one bit to match ieee
	srl $t0,$t0,22			#sign = $t0
	
	move $a1,$t2			#store mantissa in argument reg
	jal findMant
	
	j printResult

#######################################################################
#	Decode mantissa
#######################################################################
findMant:
	l.s $f2,float1			#$f2 = numerator
	li $t5,1			#$t5 = denominator
	l.s $f0,float1			#$f0 = result
	
loop:	andi $t7,$a1,0x7FFFFF		#check if the mantissa contains anything
	beqz $t7,eLoop
	
	andi $t3,$a1,0x400000		#retrieve leftmost bit
	
	sll $a1,$a1,1			#move mantissa to next bit
	
	sll $t5,$t5,1			#multiply denominator by 2
	
	bgt $t3,0,addDec		#add only if $t3 is not empty
	
	j loop
	
addDec:	mtc1 $t5,$f1			#convert denominator to float
	cvt.s.w $f1,$f1
	div.s $f3,$f2,$f1		#$f3 = 1/(2^x)
	add.s $f0,$f0,$f3		#add fraction to $f0
	j loop

#######################################################################
#	Calculate exponent and decimal representation
#######################################################################
expCalc:l.s $f1,float1
	l.s $f2,float2
	bltz $a1,negLoop

posLoop:#Loop to find positive exponent
	beqz $a1,finCalc
	subi $a1,$a1,1		#decrement the exponent tracker
	mul.s $f1,$f1,$f2	#multiply current exponent by 2
	j posLoop

negLoop:#Loop to find negative exponent 
	beqz $a1,finCalc
	addi $a1,$a1,1		#increment the exponent tracker
	div.s $f1,$f1,$f2	#divide current exponent by 2
	j negLoop

finCalc:#multiply the mantissa and exponent
	mtc1 $a3,$f3		#convert sign to float
	cvt.s.w $f3,$f3
	mul.s $f0,$f0,$f1	#multiply mantissa by exponent
	mul.s $f0,$f0,$f3	#multiply mantissa by sign

eLoop:	jr $ra	
	
	
printResult:
	#print mantissa
	li $v0,4
	la $a0,mant
	syscall
	
	li $v0,2
	mov.s $f12,$f0
	syscall
	
	li $v0,4
	la $a0,nl
	syscall
	
	#print exponent
	li $v0,4
	la $a0,exp
	syscall
	
	li $v0,1
	move $a0,$t1
	syscall
	
	li $v0,4
	la $a0,nl
	syscall
	
	#print sign
	li $v0,4
	la $a0,sign
	syscall
	
	beqz $t0,posRes
	
	li $v0,4
	la $a0,nega
	syscall
	li $a3,-1	#store sign
	j dec
	
posRes:	li $v0,4
	la $a0,pos
	syscall
	li $a3,1	#store sign
	
dec:	#Calculate and print decimal equivalent.
	move $a1,$t1	#exponent
	#mantissa in $f0
	jal expCalc
	
	#print decimal exponent
	li $v0,4
	la $a0,deci
	syscall
	
	li $v0,2
	mov.s $f12,$f0
	syscall
	
	li $v0,4
	la $a0,nl
	syscall
	
end:

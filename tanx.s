     THUMB
     AREA     factorial, CODE, READONLY
     EXPORT __main
     ENTRY 
__main  FUNCTION	

;load given inputs
	    VLDR.F32  S0, = 0 ;load x
        
;initialize
        
        VLDR.F32  S2, = 1.0   ; i = for tracking the term currently being calculated 
        VLDR.F32  S3, = 1.0   ; result
        VLDR.F32  S1, = 0.0   ; previous result
        VLDR.F32  S5, = 1.0   ; for incrementing in future
        VLDR.F32  S4, = 1.0   ; temp
        VLDR.F32  S8, = 1.0   ; temp with sign
        VLDR.F32  S9, = 0.0   ; const 0

        VLDR.F32  S6, = 0.0   ; sin x
        VLDR.F32  S7, = 1.0   ; cos x
    
        MOV       R0, #0x1   ; track if the term is for sin or cos
        MOV       R1, #0x0   ; track the sign
        MOV       R2, #0x1   ; constant for increment
        
        
        
continue
		VCMP.F32 S3, S1       ; (i==n)
		VMRS APSR_nzcv, FPSCR 
        BEQ stop	          ; exit if equal
            
        VMOV.F32 S1, S3       ; copy previous result
        
        VMUL.F32 S4, S4, S0   ; temp = temp*x
        VDIV.F32 S4, S4, S2   ; temp = temp/i
            

        CBZ    R1, positive             ; check sign
        CBNZ   R1, negative             ; check sign
        
chalochalo
        
        CBZ    R0, cos             
        CBNZ   R0, sin             ; check sin or cos
        
        

result

        VDIV.F32 S3, S6, S7   ; result = sin/cos
        
        VADD.F32 S2, S2, S5   ; i++
        
        CMP   R0, #0x0
        ITE   EQ
        MOVEQ R0, #0x1
        MOVNE R0, #0x0
        
        B continue			  ; next iteration
positive
        VADD.F32 S8, S9, S4   ; signtemp=temp
        B chalochalo
negative
        VSUB.F32 S8, S9, S4   ;signtemp=-temp
        B chalochalo

sin
        VADD.F32 S6, S6, S8   ; sinresult += sinresult+signtemp 
        CMP R1, #0x0
        ITE    EQ
        MOVEQ R1, #0x1
        MOVNE R1, #0x0
        B result
 
cos
        VADD.F32 S7, S7, S8   ; cosresult += cosresult+signtemp 
        B result
        
        
stop    B stop ; stop program
     ENDFUNC
     END
     AREA     factorial, CODE, READONLY
     EXPORT __main
     ENTRY 
__main  FUNCTION	

;load given inputs
	    VLDR.F32  S0, = 10   ;load x
        
;initialize
        
        VLDR.F32  S2, = 1.0   ; i = for tracking the term currently being calculated 
        VLDR.F32  S3, = 1.0   ; result
        VLDR.F32  S1, = 0.0   ; previous result
        VLDR.F32  S5, = 1.0   ; for incrementing in future
        VLDR.F32  S4, = 1.0   ; temp
        

continue
		VCMP.F32 S3, S1       ; (i==n)
		VMRS APSR_nzcv, FPSCR 
        BEQ stop	          ; exit if equal
            
        VMOV.F32 S1, S3       ; copy previous result
        
        VMUL.F32 S4, S4, S0   ; temp = temp*x
        VDIV.F32 S4, S4, S2   ; temp = temp/i
        VADD.F32 S3, S3, S4   ; result += result*temp 
        
        VADD.F32 S2, S2, S5   ; i++
        
        B continue			  ; next iteration
		
		
stop    B stop ; stop program
     ENDFUNC
     END
area program, code, readonly
entry
LDR R1,value1
MOV R1,R1,LSL #0X01
area program,data,readonly
value1 DCD &00000001
END

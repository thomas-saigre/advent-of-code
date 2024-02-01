>               ; Go to cell A
>>>+<<<         ; set cell BOOL to True (1) and go back to cell A
,               ; Read fisrt input to cell A
------------------------------------------------
>               ; Move to cell B
,               ; Read second input to cell B
[
    ------------------------------------------------
    [-<->>+<]   ; set to cell A the difference between cell A and cell B
                ; and set to cell B' the initial value of B
    <           ; go back to cell A
    [           ; check if cell A is not null (meaning that A and B inputs were differents)
        >>>-<<< ; set cell bool to False (0) and go back to cell A
        [-]     ; Clear cell A
    ]
    >>>         ; go to cell BOOL
    [           ; if cell BOOL is not False (meaning that initially A = B)
        <       ; go to cell B'
        [       ; copy content of cell B' to cell A (for next iteration) and add the value to counter
            <<+ ;    cell A
            <+  ;    counter
            >>>-;    go back to cell B' which is decremented
        ]
        >[-]    ; set cell bool to False
    ]
    +           ; set bool to True
    <           ; go to cell B'
    [           ; if not done yet move the content to cell A
        -<<+>>
    ]
    <           ; go back to cell B
    <<.>>       ; display counter
    ,           ; read next input to cell B
]
<<+++++         ; specific to my input: the 5 from the begining and the end
.               ; display counter
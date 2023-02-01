// bison hoc1.y 
// gcc -lm -o hoc1 hoc1.tab.c
// ./hoc1
%{
    #include <stdio.h>
    #include <ctype.h>
    #include <math.h>
    #define YYSTYPE double  /* data type of yacc stack */
    int yylex(void);
    int yyerror(char *);
    double running_total;
    %}
    %token  NUMBER

    %left   '+' '-'   /* left associative, same precedence */
    %left   '*' '/'   /* left assoc., higher precedence */
    %left '^'
    %%
    list:     /* nothing */
    | list      '\n'
    | list expr '\n'    { 
        printf(" EXPR VAL is %.1f" , $2);  
        printf("\n"); 
        running_total += $2; 
        printf("Running total: %.1f" , running_total);
        printf("\n"); 
    }
    ;
    expr:     NUMBER        { $$ = $1;}
    | '(' expr ')' {$$ = $2;}
    | expr '+' expr { $$ = $1 + $3;}
    | expr '-' expr { $$ = $1 - $3;}
    | expr '*' expr { $$ = $1 * $3;}
    | expr '/' expr { $$ = $1 / $3;}
    | expr '^' NUMBER {$$ = pow($1 , $3) }
    ; 
    %%
/* end of grammar */

char    *progname;      /* for error messages */
    int     lineno = 1;

int main(int argc, char **argv) /* hoc1 */
    {
        progname = argv[0];
        yyparse();
        return 0;
    }

int yylex(void)         /* get next token */
    {
        int c, r ;

        r = -2;
        while ((c=getchar()) == ' ' || c == '\t')
            ;
        if (c == EOF) {
            r = 0;
        }
if (c == '.' || isdigit(c)) {   /* number */
        ungetc(c, stdin);
        scanf("%lf", &yylval);
        r = NUMBER;
    }
    if (c == '\n') { 
        lineno++; 
    }

    if (r == -2) { r = c; }
    return r;
}

int yyerror(char *s)    /* for errors */
{
    printf(" ERROR (%s) near line %d\n", s, lineno);
    return -1;
}

#include <stdio.h>
#include <assert.h>
#include <string.h>

#define PASSWORD_SIZE 8
#define CRT_RULE_3 2
#define FORBIDDEN_CHAR_I 'i'
#define FORBIDDEN_CHAR_O 'o'
#define FORBIDDEN_CHAR_L 'l'
#define DUMMY_CHAR '&'
#define CHAR_A 'a'
#define CHAR_Z 'z'
#define CHAR_TOO_FAR 'z' + 1
#define NEXT_CORRECT "aabccaaa"

#define VERBOSE 0


int check_password(char password[PASSWORD_SIZE+1])
{

    if (VERBOSE) printf("Checking password %s\n", password);
    int rule_1 = 0, rule_2 = 1, count_3 = 0;
    int char_rule_3 = DUMMY_CHAR;
    for (int i=0; i<PASSWORD_SIZE; ++i)
    {
        if (i < PASSWORD_SIZE - 2)
        {
            if (VERBOSE) printf("  * %d %d %d\n", password[i], password[i+1], password[i+2]);
            rule_1 |= (password[i] == password[i+1]-1) && (password[i] == password[i+2]-2);
            if (VERBOSE) if (rule_1) printf("  Rule 1 is checked !\n");
        }
        if ((password[i] == FORBIDDEN_CHAR_I) || (password[i] == FORBIDDEN_CHAR_O) || (password[i] == FORBIDDEN_CHAR_L))
        {
            rule_2 = 0;
            if (VERBOSE) printf("  Rule 2 is not checket\n");
            break;
        }
        if (i < PASSWORD_SIZE - 1)
        {
            if (password[i] == password[i+1])
            {
                if (char_rule_3 == DUMMY_CHAR)
                {
                    char_rule_3 = password[i];
                    count_3 += 1;
                }
                else
                {
                    if (password[i] != char_rule_3)
                    {
                        count_3 += 1;
                    }
                }
            }
            if (VERBOSE) printf("  3. %d\n", count_3);
        }
    }
    if (VERBOSE) printf("  rule_1 %d, rule_2 %d, count_3 %d\n", rule_1, rule_2, count_3);
    return rule_1 & rule_2 & (count_3 >= CRT_RULE_3 );
}

void next_password(char password[PASSWORD_SIZE+1])
{
    // first, wee increment the password
    password[PASSWORD_SIZE-1] += 1;
    for (int i=PASSWORD_SIZE-1; i>=0; --i)
    {
        if (password[i] == CHAR_TOO_FAR )
        {
            password[i] = CHAR_A;
            if (i > 0)
                password[i-1] += 1;
            else
                printf("We reached to top password (%s), we should'nt see this message.", password);
        }
    }

    // No need to be that smart... We can just continue without this :p
    // Then we look if a forbidden character is in it
    // for (int i=0; i<PASSWORD_SIZE; ++i)
    // {
    //     if (password[i] == FORBIDDEN_CHAR_I || password[i] == FORBIDDEN_CHAR_L || password[i] == FORBIDDEN_CHAR_O)
    //     {
    //         password[i] += 1;
    //         for (int j = 0; j + i + 1 < PASSWORD_SIZE; ++j)
    //         {
    //             password[i+j+1] = NEXT_CORRECT[j];
    //         }
    //         return;
    //     }
    // }
}

int main()
{
    assert(!check_password("hijklmmn"));
    assert(!check_password("abbceffg"));
    assert(!check_password("abbcegjk"));
    assert(check_password("abcdffaa"));
    assert(!check_password("cqkaaabc"));

    // char my_test[PASSWORD_SIZE+1] = "cqkaaabc";
    // if (check_password(my_test))
    //     printf("%s is correct\n", my_test);
    // else
    //     printf("%s is not correct\n", my_test);

    // char ex1[PASSWORD_SIZE+1] = "ghijklmn";
    // next_password(ex1);
    // assert(!strcmp(ex1, "ghjaabcc"));

    char santa_password[PASSWORD_SIZE+1] = "cqjxjnds";
    next_password(santa_password);
    while (!check_password(santa_password))
    {
        next_password(santa_password);
    }
    printf("Part I : %s\n", santa_password);

    next_password(santa_password);
    while (!check_password(santa_password))
    {
        next_password(santa_password);
    }
    printf("Part II: %s\n", santa_password);

    return 0;
}
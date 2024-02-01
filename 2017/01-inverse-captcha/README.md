# Inverse Captcha in Brainfuck

## Part 1

The code does not really returns the correct enswer, but we can manage to recover it.
when two consecutives numbers are equals, this number is added to the counter (and this works !),
but when we add to much, the value reaches the maximal value and then rolls back to `0` (`␀`).

So presently, I display the value of the counter at each step, and count by hand the number of times $N$ when it rolls back, to compute (by hand) the final result : is $c$ is the value stored in the counter at the end of the execution, the result is $256\times N + c$

**NB:** as the last term is because my input begins and ends with a `5`, I add `5` to `c`.


Here is the output of my code:

```
␀␉␉␉␉␉␉␋␋␋␋␋␋␋␋␋␋␋␋␋␓␛␛␛␛␛␛$$$$)))))))))))))))))))))))))))))))--4;;=========>>>>>>>>>>>>>>>>>>>>>@@@@@@@@@EEFFFFFFFFFFFFFIIIPPPPPPPPPPPPPPPPPPRRRRRRRRRUUUU]]]]]]]]]]]]]]ccggggggggggggggglqqqqx␡£ªªª³³³³³³¶¶¶¶¸¸¸¿¿¿¿¿¿¿¿ÅÅÅÅÅÅÅÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÆÊÊÊÊÊÊÊÊÊÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÌÐÐÐÐÑÑÑÑÑÑÑÑÑÑÑÙÙÙßååææææææææææææææéééééééééééééééééééêêêêêîòòòòòòûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûû
␂␂␂␂␂␂␂␂␂␆␆␆␆␆␆␆␆␋␋␋␋␒␒␘␘␘␘␘␟␟␟␟␟␟␟""""""""$$$$**********222222222229@@@@@@FFFFFFFFFFFMMMTTTTTTTTTTTWWWWWWWWWWWWWWZ]]]dkkkkkkkkkpppppxxxxxx§§§§§§§§§§§§§§§§§§§§§§§§§ªªª²ºººº¼¼¼¼¼¼¼¼½½¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿ÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÇÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÎÑÑÕÕÕÕÕÕÕÕÕÝÝÝÝÝÝßßßßßßßßßßßßßßßãããçççíííííííííííííôôôôôôûûû
␄␊␊␊␊␊␊␖␟␟␟␟␟␟␟␟␟␟␟␟␟␟␟␟␟␟␟␟␟␟%++4444444444444444==????????DDJJJQQQQQTTTTWWWWWWWWWWYYYYYYY\\\\\\\\\\\___eejjjjjjjjrrrrrrrrrrrrrrrvzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz␡␡␡␡␡¦¦¦¦¦«°°°°°°´´¹¹½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½½ÆÆÆÆÌÒÒÒÒÒÓÔÔÔÔÔÔÔÔÔÔÔØØáááááâââââââêêêêêêêêêêêêêêêêêêêêêêêêêêóóóü
␅␅␅␅␅␅␅␅␅␅␅␅␅␅␅␅␅␅␅␅␅␎␎␎␎␎␎␗␗␗␗␗␗␗␗␗␗␗␗␚␚␚␚␚␚␚␚␚␚␚␚␚␚␚␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜␜######************00000044444444444444444;;;;;;;;;;;;;;;;;;;;;;;;?????????AAAIIIIIIIIIIIIQQQQQQVVVVYYYYY\\\\ddeeeeeeeeeeeiiiiiiiiinnnnnnnnnnnooooooooswwwwwwwwww␡¡¡¢¢¢¢¢¢¢¢¢£££¤¤¤¤¤¤­­­±µµµµµµµµµµ¾¾¾¾¾¾¾¾¾¾¾¾¾¾¾¾¾¾¾ÅÅÅÅÅÅÅÅÅÅÅÅÈÈÈÈÈÈÊÌÌÌÌÌÌÌÕÕÕÕÕÜÜÜåååéééìììììììòò÷÷÷÷÷÷÷÷÷
␀␀␀␀␆␆␆␆␆␆␆␆␆␆␆␆␆␆␆␆␆␆␆␇␇␇␇␇␇␇␇␋␋␋␊␊␊␊␊␊␊␊␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␔␜␜␜␜%%%+++44444444466>>>>DJJJJJJJJJRRRRRRWWWWWWWWWWWWW````````ejjjjjjjjjjjjnnnnnnnppppuuvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv}}}¢¢¢¢¢¢¢¢¢¦¦¦¦¦¦¦¦¦¯¯¯¯¯¯¯¯¶¶¶·······························¾¾¾¾¾¾¾¾¾¾¾¾¾¾¾¾¿¿¿¿ÀÀÀÅÅÅÅÅÅÅÅÅÅÅÅÅËËËËËËËËËËËËËËËËËËËÐÐÐÐÐÐÐÐÐÙÙÙÙÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚÚáááêóóóóóóóóóóóóóóóóóóóóóóóóùùùùùùùúúúúúúúúúþþþ
␂␂␂␇␇␊␊␊␊␑␑␑␑␑␚␚␚    ########***-000666666888;;;;;;;;;;;;;;;;;;;;;@@@@@@@@@@@@@@@@HHHHHHHHHHQQQQQYYYYYYYYYYYYYYYbbbbbeeeellllllllq
```

I returned to line each time we roll back to `␀`, so we have $N = 5$, and $c = 113$.

So we should have $R_1 = 256\times 5 + 113 = 1393$ 🙃.


## Part 2

Noway I'm trying to do part 2 in Brainfuck !
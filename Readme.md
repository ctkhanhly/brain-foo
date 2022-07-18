```
--[----->+<]>++.-------.++++++++++++++++++.--------.------.+++++++..---.++++++++++..----.---------.+++++++++++++++.-------.
```

Did you get mad confuse reading the above line? That is actually code from the BF programming language!

A few days ago I watched this youtube video https://www.youtube.com/watch?v=hdHjjBS4cs8&ab_channel=Fireship and was very interested in the BF programming language itself and how Fireship generate BF code. So I was thinking, can I generalize their idea and write a script that just spits out BF code in a short and succinct way? My goal is that if I would have to type out BF code manually, I don't need to type in that many characters nor think too much on what that means but can expect correct code generation. So here we go:

## First Optimization

If we look at Fireship's code to print out letter 'h':
+[----->+++<]>+.
The characters before [ will be either some number of '+' or '-' and I call this number **s** (positive for '+' and negative for '-'). This number cannot be zero if we are using loop at all.

The number of '-' characters before > inside square brackets ([]) will be **a**, this number has to be nonnegative.

The number of '+' characters after > and before < inside square brackets ([]) will be **b**, this number has to be nonnegative.

The number of '+' or '-' characters after the square brackets will be **k**.

What Fireship does is first add some offset s to the first byte and go on a loop trying to making this byte 0 while changing the second byte so that at the end of the loop the first byte is 0 and the second byte will contains the ASCII number of the desired character. After the loop, increment the position pointer to the second byte and print out the character (optionally add a few more offset k to the second byte before that).

Here's the equation to solve for a,b,s,k:

Let **t** be the first nonnegative number such that (-t*a + s) % 256 = 0, this represents the number of times the loop is run before the first byte becomes 0.

Ideally, we want k to be 0 to minimize the number of characters in the code, so we want t*b % 256 = c.

Using these 2 facts, I implemented a simple brute force solution to solve for a,b,s,k and of course I don't want the total number of characters to be more than 50 and so I limit the range for each (was a bit generous in my code tbh) in **Python** and **Haskell**. Some simple calculation shows that my algorithm results in at most 23 characters of code syntax to print out any ASCII character.


## Second Optimization

In the iterative code, I made a second optimization so that instead of always clearing byte at indices 0 and 1 and use the above algorithm, I could just simple add/subtract a few offsets to generate the next character. For example, if we have just printed code to print out 'h' and byte 1 has value 104, then we can just add 1 '+' character and print '.' to print out 'i' as opposed to clearing byte 1, to be 0, changing the position pointer back to 0, and generate code to print out 'i' (105).

I also implemented a super simple BF interpreter that doesn't handle nested loop at all.

To generate BF code to print out a string, give a string after running, for example:

```
echo "ctkhanhly" | python3 iterative.py
```

To run tests where I check all of my generated code can spit out the correct ASCII characters (at most from 0-255), run:

```
make runTests
```

and remove files I created while running tests, run:

```
make clean
```

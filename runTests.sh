#/usr/bin/bash

# Test Correctness
ghc -o test test.hs
./test > codehs
python3 test.py > codepy
IS_TEST=True python3 interpreter.py 0<codehs 1> ouths
IS_TEST=True python3 interpreter.py 0<codepy 1> outpy

cmp ouths sol 2>&1 1> /dev/null
if [$? != 0]; then
    echo "Haskell algo is incorrect"
else
    echo "Haskell algo is correct"
fi
cmp outpy sol 2>&1 1> /dev/null
if [$? != 0]; then
    echo "Python algo is incorrect"
else
    echo "Python algo is correct"
fi

# Test Max Min
python3 get_maxmin.py > maxminpy
ghc -o get_maxmin get_maxmin.hs
./get_maxmin > maxminhs
minhs=$(tail -n 1 maxminhs)
maxhs=$(head -n 1 maxminhs)

if [ $minhs = '0' ]; then
    echo "Haskell min BF code generator is correct"
else
    echo "Haskell min BF code generator is incorrect"
fi

if [ $maxhs = '23' ]; then
    echo "Haskell max BF code generator is correct"
else
    echo "Haskell max BF code generator is incorrect"
fi

python3 get_maxmin.py > maxminpy
minpy=$(tail -n 1 maxminpy)
maxpy=$(head -n 1 maxminpy)

if [ $minpy = '0' ]; then
    echo "Python min BF code generator is correct"
else
     echo "Python min BF code generator is incorrect"
fi

if [ $maxpy = '23' ]; then
    echo "Python max BF code generator is correct"
else
    echo "Python max BF code generator is incorrect"
fi
runTests:
	chmod +x runTests.sh
	./runTests.sh
clean:
	rm *.{o,hi} test get_maxmin code{hs,py} maxmin{hs,py} out{hs,py}

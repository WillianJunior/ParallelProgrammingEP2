# $(VERBOSE).SILENT:

CXXC = g++
CFLAGS = -std=c++11 -g -ggdb -gdwarf-2 -lm
SERIAL = ep2-serial
CONC = ep2-conc

HUGE = 16000

all: compile

compile: $(SERIAL).cpp
	@$(CXXC) $(SERIAL).cpp -o $(SERIAL).out $(CFLAGS)
	@$(CXXC) $(CONC).cpp -o $(CONC).out $(CFLAGS) -lpthread

compile_test: $(SERIAL).cpp
	@$(CXXC) $(SERIAL).cpp -DNO_NEW_LINE -o $(SERIAL).out $(CFLAGS)
	@$(CXXC) $(CONC).cpp -DNO_NEW_LINE -o $(CONC).out $(CFLAGS) -lpthread

test: test_inputs_gen test_outputs_gen compile
	@./$(SERIAL).out 3 3 1 1 ocean < test1 > r
	@diff r test1_r
	@./$(SERIAL).out 4 4 2 4 ocean < test2 > r
	@diff r test2_r
	@./$(SERIAL).out 10 10 5 2 ocean < test3 > r
	@diff r test3_r

	@./$(CONC).out 3 3 1 1 ocean < test1 > r
	@diff r test1_r
	@./$(CONC).out 4 4 2 4 ocean < test2 > r
	@diff r test2_r
	@./$(CONC).out 10 10 5 2 ocean < test3 > r
	@diff r test3_r

test_full: compile_test test_huge_input_gen
	@echo -n "x=[1:16]\nb1=[" >> results.txt
	
# get baseline data
	
	@./$(SERIAL).out $(HUGE) $(HUGE) 5 2 time < test_huge
	@./$(SERIAL).out $(HUGE) $(HUGE) 5 2 time < test_huge
	@echo "Baseline warmup finished"
	@echo -n "[" > baseline
	@./$(SERIAL).out $(HUGE) $(HUGE) 5 2 time < test_huge >> baseline
	@echo -n "," >> baseline
	@./$(SERIAL).out $(HUGE) $(HUGE) 5 2 time < test_huge >> baseline
	@echo -n "," >> baseline
	@./$(SERIAL).out $(HUGE) $(HUGE) 5 2 time < test_huge >> baseline
	@echo -n "," >> baseline
	@./$(SERIAL).out $(HUGE) $(HUGE) 5 2 time < test_huge >> baseline
	@echo -n "," >> baseline
	@./$(SERIAL).out $(HUGE) $(HUGE) 5 2 time < test_huge >> baseline
	@echo "Baseline test finished"
	@echo -n "]" >> baseline
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n ";" >> results.txt
	@cat baseline >> results.txt
	@echo -n "];\n" >> results.txt
	@rm baseline

# get test data strongly scalable
	@echo -n "y1=[" >> results.txt
	@export THREADS=1; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 1 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=2; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 2 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=3; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 3 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=4; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 4 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=5; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 5 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=6; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 6 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=7; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 7 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=8; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 8 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=9; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 9 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=10; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 10 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=11; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 11 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=12; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 12 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=13; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 13 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=14; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 14 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=15; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 15 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=16; $(MAKE) --quiet test_thread
	@echo "Y1 threads = 16 test finished"
	@echo -n "];\n" >> results.txt

# get test data weakly scalable
	@echo -n "z1=[" >> results.txt
	@export THREADS=1; export HUGE=1000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 1 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=2; export HUGE=2000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 2 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=3; export HUGE=3000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 3 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=4; export HUGE=4000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 4 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=5; export HUGE=5000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 5 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=6; export HUGE=6000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 6 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=7; export HUGE=7000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 7 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=8; export HUGE=8000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 8 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=9; export HUGE=9000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 9 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=10; export HUGE=10000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 10 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=11; export HUGE=11000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 11 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=12; export HUGE=12000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 12 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=13; export HUGE=13000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 13 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=14; export HUGE=14000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 14 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=15; export HUGE=15000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 15 test finished"
	@echo -n ";" >> results.txt
	@export THREADS=16; export HUGE=16000; $(MAKE) --quiet -e test_thread
	@echo "Z1 threads = 16 test finished"
	@echo -n "];\n" >> results.txt
	@echo "Z1 test finished"
	

test_thread:
	@./$(CONC).out $(HUGE) $(HUGE) 5 $(THREADS) time < test_huge
	@./$(CONC).out $(HUGE) $(HUGE) 5 $(THREADS) time < test_huge
	@echo -n "[" >> results.txt
	@./$(CONC).out $(HUGE) $(HUGE) 5 $(THREADS) time < test_huge >> results.txt
	@echo -n "," >> results.txt
	@./$(CONC).out $(HUGE) $(HUGE) 5 $(THREADS) time < test_huge >> results.txt
	@echo -n "," >> results.txt
	@./$(CONC).out $(HUGE) $(HUGE) 5 $(THREADS) time < test_huge >> results.txt
	@echo -n "," >> results.txt
	@./$(CONC).out $(HUGE) $(HUGE) 5 $(THREADS) time < test_huge >> results.txt
	@echo -n "," >> results.txt
	@./$(CONC).out $(HUGE) $(HUGE) 5 $(THREADS) time < test_huge >> results.txt
	@echo -n "]" >> results.txt


test_huge: compile test_huge_input_gen
	@ echo "serial: "
	@./$(SERIAL).out $(HUGE) $(HUGE) 5 2 time < test_huge
	@ echo "concurrent: "
	@./$(CONC).out $(HUGE) $(HUGE) 5 16 time < test_huge

test_inputs_gen:
	@ printf "5\n5\n5\n5\n5\n9\n5\n5\n5\n" > test1
	@ printf "2\n2\n2\n2\n1\n2\n3\n4\n1\n2\n2\n1\n3\n3\n3\n3\n" > test2
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" > test3
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" >> test3
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" >> test3
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" >> test3
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" >> test3
	@ printf "5\n5\n5\n5\n5\n11\n5\n5\n5\n5\n" >> test3
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" >> test3
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" >> test3
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" >> test3
	@ printf "5\n5\n5\n5\n5\n5\n5\n5\n5\n5\n" >> test3

test_outputs_gen:
	@ printf "4\t8\t8\n4\t8\t8\n4\t8\t8\n" > test1_r
	@ printf "1\t2\t2\t2\n1\t2\t2\t2\n1\t2\t2\t2\n1\t2\t2\t2\n" > test2_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" > test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r
	@ printf "6\t6\t6\t6\t6\t6\t6\t6\t6\t6\n" >> test3_r

test_huge_input_gen:
	@ perl huge_gen.pl $(HUGE)
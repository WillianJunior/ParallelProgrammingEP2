# $(VERBOSE).SILENT:

CXXC = g++
CFLAGS = -std=c++11 -lpthread -g -ggdb -gdwarf-2

all: compile

compile: ep2.cpp
	$(CXXC) $(CFLAGS) ep2.cpp -o ep2.out

test: test_inputs_gen test_outputs_gen compile
	@./ep2.out 3 3 1 1 ocean < test1 > r
	@-diff r test1_r
	@./ep2.out 4 4 2 4 ocean < test2 > r
	@-diff r test2_r
	@./ep2.out 10 10 5 2 ocean < test3 > r
	@-diff r test3_r

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

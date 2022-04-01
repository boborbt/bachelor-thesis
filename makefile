# Points to the root of Google Test, relative to where this file is.
GTEST_DIR= ./src/tests/googletest/googletest
# All Google Test headers.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h
# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include
# Flags passed to the C++ compiler.
CXXFLAGS += -g -Wall -Wextra -pthread
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

#---------------MAIN-------------

mad_dices: ./build/cell.o ./build/dice.o ./build/white_dice.o
	cd src; \
	$(CXX) mad_dices.cpp -o mad_dices ../build/cell.o ../build/dice.o ../build/white_dice.o

./build/cell.o: ./src/lib/cell.cpp ./src/lib/cell.h
	cd src/lib; \
	$(CXX) -c cell.cpp -o ../../build/cell.o; 

./build/dice.o: ./src/lib/dice.cpp ./src/lib/dice.h
	cd src/lib; \
	$(CXX) -c dice.cpp -o ../../build/dice.o;

./build/white_dice.o: ./src/lib/white_dice.cpp ./src/lib/white_dice.h
	cd src/lib; \
	$(CXX) -c white_dice.cpp -o ../../build/white_dice.o;

#---------------TESTS-------------

gtest-all.o : $(GTEST_SRCS_)
	$(CXX) -isystem src/tests/googletest/googletest/include -Isrc/tests/googletest/googletest $(CXXFLAGS) -c src/tests/googletest/googletest/src/gtest-all.cc;

gtest_main.o : $(GTEST_SRCS_)
	$(CXX) -isystem src/tests/googletest/googletest/include -Isrc/tests/googletest/googletest $(CXXFLAGS) -c src/tests/googletest/googletest/src/gtest_main.cc;
	
gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^; \
	mv gtest.a ./src/tests; 

gtest_main.a : gtest-all.o gtest_main.o
	$(AR) $(ARFLAGS) $@ $^;
	
./src/tests/tests.o : ./src/tests/tests.cpp ./build/cell.o ./build/dice.o ./build/white_dice.o $(GTEST_HEADERS)
	cd ./src/tests/; \
	$(CXX) -isystem ./googletest/googletest/include $(CXXFLAGS) -c tests.cpp

tests: ./src/tests/tests.o gtest_main.a 
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@; \
	mv gtest-all.o ./src/tests; \
	mv gtest_main.o ./src/tests; \
	mv gtest_main.a ./src/tests; \
	mv tests ./src/tests;

#---------------COMMANDS-------------

make all: mad_dices

run:
	./src/mad_dices

run_tests:	
	./src/tests/tests	

clean:
	rm -f ./build/*.o ./src/mad_dices ./src/tests/tests ./src/tests/*.a ./src/tests/*.o

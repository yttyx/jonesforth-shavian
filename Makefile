# Makefile for Shavian variant of Jonesforth

TESTDIR	:= ./tests

all:	jonesforth

# gcc options:
# -m32
# -g - add debugging information
# -Wa pass options to as (the gnu assembler)
# as options:
# -a - turn on listings; qualifiers:
# 	s - include symbols
# 	m - expand macros
# 	l - include assembly 
# 	h - include high level code 
# 	L - retain local symbols in the symbol table

jonesforth: jonesforth.S
	gcc -m32 -g -nostdlib -static -o $@ $<

list:
	gcc -m32 -c -Wa,-asmlh,-L jonesforth.S >jonesforth.list

run:	jonesforth
	./jonesforth

clean:
	@rm -f jonesforth jonesforth.o jonesforth.list core.* $(TESTDIR)/test.out

TESTS	:= $(patsubst %.f,%.test,$(wildcard $(TESTDIR)/test_*.f))

test check: $(TESTS)

tests/test_%.test: $(TESTDIR)/test_%.f jonesforth
	@echo -n "$< ... "
	@cat $<  <(echo '𐑑𐑧𐑕𐑑') | ./jonesforth -s | sed 's/𐑛𐑕𐑐=[0-9]*//g' > $(TESTDIR)/test.out
	@diff -u $<.out $(TESTDIR)/test.out
	@echo "ok"
	@rm -f $(TESTDIR)/test.out

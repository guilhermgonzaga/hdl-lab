GHDL:=ghdl
SRC:=$(wildcard *.vhdl)
OBJ?=$(patsubst %.vhdl,%,$(SRC))

all: $(OBJ)

check: $(SRC)
	@$(GHDL) -s -v $^ && $(GHDL) -a -v $^

$(OBJ): $(SRC)
	$(GHDL) -i -v $@.vhdl
	$(GHDL) -m -v $@

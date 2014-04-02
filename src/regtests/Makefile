
DIRS = hello_world zlib_test

all:
	for d in $(DIRS); do (cd $$d; $(MAKE) all ); done

regression:
	for d in $(DIRS); do (cd $$d; $(MAKE) regression ); done

clean:
	for d in $(DIRS); do (cd $$d; $(MAKE) clean ); done


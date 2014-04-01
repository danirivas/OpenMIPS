
BASE_PATH=`readlink -f .`

SOURCE_URL="http://ftp.gnu.org/gnu/gdb/gdb-7.7.tar.bz2"
SOURCE_CHECKSUM="271a18f41858a7e98b28ae4eb91287c9" 
GDB_PREFIX=$BASE_PATH/toolchain/

function down_file {
	CALC=`md5sum $BASE_PATH/dl/$1 | cut -d" " -f 1`
	if [ "$CALC" != "$3" ]; then
		echo "Need to download sources"
		rm -f $BASE_PATH/dl/$1
		wget -O $BASE_PATH/dl/$1 "$2"
	fi
}

function down_extract {

    down_file "gdb-7.7.tar.bz2"  "$SOURCE_URL" "$SOURCE_CHECKSUM"
	echo "Extracting files into source folder..."

    rm -rf   $BASE_PATH/src/gdb/
   	mkdir -p $BASE_PATH/src/gdb

	tar -xf $BASE_PATH/dl/gdb-7.7.tar.bz2 -C $BASE_PATH/src/gdb/
}

if [ "$1" == "check" ]; then
	flist="mips-elf-gdb mips-elf-run"

	for elem in $flist; do
		if [ ! -f $BASE_PATH/toolchain/bin/$elem ]; then
			exit 1;
		fi
	done
	exit 0
elif [ "$1" == "build" ] || [ "$1" == "clean" ]; then

	echo "Cleaning..."
	rm -rf   $BASE_PATH/src/gdb/
	rm -rf $BASE_PATH/build/gdb/

fi	
if [ "$1" == "build" ]; then

	down_extract 
	
	echo "Configure gdb..."
	
	rm -rf $BASE_PATH/build/gdb/
	mkdir -p $BASE_PATH/build/gdb
	
	export PATH=$PATH:$BASE_PATH/toolchain/bin/

    (export LD_LIBRARY_PATH=$GDB_PREFIX/lib; cd $BASE_PATH/build/gdb; $BASE_PATH/src/gdb/gdb-7.7/configure --target=mips-elf --prefix=$GDB_PREFIX )
	
	echo "Compiling gdb..."
	(export LD_LIBRARY_PATH=$GDB_PREFIX/lib; make -j 8 -C $BASE_PATH/build/gdb all)
	
	echo "Install GDB"
	(export LD_LIBRARY_PATH=$GDB_PREFIX/lib; make -C $BASE_PATH/build/gdb install)

fi	


BASE_PATH=`readlink -f .`

SOURCE_URL="http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2"
SOURCE_CHECKSUM="e0f71a7b2ddab0f8612336ac81d9636b"
BINUTILS_PREFIX=$BASE_PATH/toolchain

if [ "$1" == "check" ]; then
	flist="mips-elf-addr2line mips-elf-c++filt mips-elf-ld.bfd mips-elf-objdump mips-elf-size mips-elf-ar mips-elf-elfedit mips-elf-nm mips-elf-ranlib mips-elf-strings mips-elf-as mips-elf-ld mips-elf-objcopy mips-elf-readelf mips-elf-strip"

	for elem in $flist; do
		if [ ! -f $BASE_PATH/toolchain/bin/$elem ]; then
			exit 1;
		fi
	done
	exit 0

elif [ "$1" == "build" ] || [ "$1" == "clean" ]; then

	echo "Cleaning..."
	rm -rf   $BASE_PATH/src/binutils/
	rm -rf $BASE_PATH/build/binutils/

fi	
if [ "$1" == "build" ]; then

	CALC=`md5sum $BASE_PATH/dl/binutils-2.24.tar.bz2 | cut -d" " -f 1`
	if [ "$CALC" != "$SOURCE_CHECKSUM" ]; then
		echo "Need to download binutils sources"
		rm -f $BASE_PATH/dl/binutils-2.24.tar.bz2
		wget -O $BASE_PATH/dl/binutils-2.24.tar.bz2 "$SOURCE_URL"
	fi
	
	echo "Extracting files into source folder..."
	
	mkdir -p $BASE_PATH/src/binutils/
	tar -xf $BASE_PATH/dl/binutils-2.24.tar.bz2 -C $BASE_PATH/src/binutils/
	
	echo "Configure binutils..."
	
	rm -rf $BINUTILS_PREFIX
	mkdir -p $BASE_PATH/build/binutils
	mkdir -p $BINUTILS_PREFIX
	
	(cd $BASE_PATH/build/binutils; $BASE_PATH/src/binutils/binutils-2.24/configure --target=mips-elf --prefix=$BINUTILS_PREFIX )
	
	echo "Compiling binutils..."
	make -j4 -C $BASE_PATH/build/binutils all
	
	echo "Install BINUTILS"
	make -C $BASE_PATH/build/binutils install
fi


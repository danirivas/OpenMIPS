
BASE_PATH=`readlink -f .`

SOURCE_URL="ftp://sources.redhat.com/pub/newlib/newlib-1.20.0.tar.gz"
SOURCE_CHECKSUM="e5488f545c46287d360e68a801d470e8"
NEWLIB_PREFIX=$BASE_PATH/toolchain

if [ "$1" == "check" ]; then
	exit 0
elif [ "$1" == "build" ] || [ "$1" == "clean" ]; then
	echo "Cleaning..."
	rm -rf   $BASE_PATH/src/newlib/
	rm -rf $BASE_PATH/build/newlib/
fi
if [ "$1" == "build" ]; then

	CALC=`md5sum $BASE_PATH/dl/newlib-1.20.0.tar.gz | cut -d" " -f 1`
	if [ "$CALC" != "$SOURCE_CHECKSUM" ]; then
		echo "Need to download newlib sources"
		rm -f $BASE_PATH/dl/newlib-1.20.0.tar.gz
		wget -O $BASE_PATH/dl/newlib-1.20.0.tar.gz "$SOURCE_URL"
	fi
	
	echo "Extracting files into source folder..."
	
	mkdir -p $BASE_PATH/src/newlib/
	tar -xf $BASE_PATH/dl/newlib-1.20.0.tar.gz -C $BASE_PATH/src/newlib/
	
	echo "Configure newlib..."
	
	mkdir -p $BASE_PATH/build/newlib
	
	export PATH=$PATH:$BASE_PATH/toolchain/bin
	
	(cd $BASE_PATH/build/newlib; $BASE_PATH/src/newlib/newlib-1.20.0/configure --target=mips-elf --prefix=$NEWLIB_PREFIX)
	
	echo "Compiling newlib..."
	make -j 8 -C $BASE_PATH/build/newlib all
	
	echo "Install newlib"
	make -C $BASE_PATH/build/newlib install
fi
	

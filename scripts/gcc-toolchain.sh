
BASE_PATH=`readlink -f .`

SOURCE_URL="http://ftp.gnu.org/gnu/gcc/gcc-4.8.0/gcc-4.8.0.tar.bz2"
SOURCE_CHECKSUM="e6040024eb9e761c3bea348d1fa5abb0"
GCC_PREFIX=$BASE_PATH/toolchain/

# GMP
GMP_URL="ftp://ftp.gmplib.org/pub/gmp-5.1.0/gmp-5.1.0.tar.bz2"
GMP_CHECKSUM="362cf515aff8dc240958ce47418e4c78"
# MPC
MPC_URL="http://www.multiprecision.org/mpc/download/mpc-1.0.1.tar.gz"
MPC_CHECKSUM="b32a2e1a3daa392372fbd586d1ed3679"
# MPFR 
MPFR_URL="http://www.mpfr.org/mpfr-3.1.1/mpfr-3.1.1.tar.bz2"
MPFR_CHECKSUM="e90e0075bb1b5f626c6e31aaa9c64e3b"

function down_file {
	CALC=`md5sum $BASE_PATH/dl/$1 | cut -d" " -f 1`
	if [ "$CALC" != "$3" ]; then
		echo "Need to download sources"
		rm -f $BASE_PATH/dl/$1
		wget -O $BASE_PATH/dl/$1 "$2"
	fi
}

function down_extract {

    down_file "gcc-4.8.0.tar.bz2"  "$SOURCE_URL" "$SOURCE_CHECKSUM"
    if [ "$1" == "build-pre" ]; then
        down_file "gmp-5.1.0.tar.bz2"  "$GMP_URL"    "$GMP_CHECKSUM"
        down_file "mpc-1.0.1.tar.gz"   "$MPC_URL"    "$MPC_CHECKSUM"
        down_file "mpfr-3.1.1.tar.bz2" "$MPFR_URL"   "$MPFR_CHECKSUM"
    fi

	echo "Extracting files into source folder..."

    flist="gcc gmp mpc mpfr"
    for p in $flist; do
	    rm -rf   $BASE_PATH/src/$p/
    	mkdir -p $BASE_PATH/src/$p
        echo "mkdir -p $BASE_PATH/src/$p"
    done

	tar -xf $BASE_PATH/dl/gcc-4.8.0.tar.bz2 -C $BASE_PATH/src/gcc/
    if [ "$1" == "build-pre" ]; then
	    tar -xf $BASE_PATH/dl/gmp-5.1.0.tar.bz2 -C $BASE_PATH/src/gmp/
    	tar -xf $BASE_PATH/dl/mpc-1.0.1.tar.gz -C $BASE_PATH/src/mpc/
    	tar -xf $BASE_PATH/dl/mpfr-3.1.1.tar.bz2 -C $BASE_PATH/src/mpfr/
    fi

}

if [ "$1" == "check" ]; then
	flist="mips-elf-gcc mips-elf-g++"

	for elem in $flist; do
		if [ ! -f $BASE_PATH/toolchain/bin/$elem ]; then
			exit 1;
		fi
	done
	exit 0
elif [ "$1" == "build-pre" ] || [ "$1" == "build" ] || [ "$1" == "clean" ]; then

	echo "Cleaning..."
	rm -rf   $BASE_PATH/src/gcc/
	rm -rf $BASE_PATH/build/gcc/
	rm -rf   $BASE_PATH/src/gcc-pre/
	rm -rf $BASE_PATH/build/gcc-pre/

fi	
if [ "$1" == "build-pre" ]; then

	down_extract $1
	
	echo "Configure gcc..."
	
	rm -rf $BASE_PATH/build/gcc-pre/
	mkdir -p $BASE_PATH/build/gcc-pre
	
	export PATH=$PATH:$BASE_PATH/toolchain/bin/

    echo "Build GMP"
    (cd $BASE_PATH/src/gmp/gmp-5.1.0; ./configure --disable-shared --prefix=$GCC_PREFIX; make -j8; make install)
    echo "Build MPFR"
    (cd $BASE_PATH/src/mpfr/mpfr-3.1.1; ./configure --disable-shared --prefix=$GCC_PREFIX --with-gmp=$GCC_PREFIX; make -j8; make install)
    echo "Build MPC"
    (cd $BASE_PATH/src/mpc/mpc-1.0.1; ./configure --disable-shared --prefix=$GCC_PREFIX --with-gmp=$GCC_PREFIX --with-mpfr=$GCC_PREFIX; make -j8; make install)

    (export LD_LIBRARY_PATH=$GCC_PREFIX/lib; cd $BASE_PATH/build/gcc-pre; $BASE_PATH/src/gcc/gcc-4.8.0/configure --target=mips-elf --prefix=$GCC_PREFIX --enable-languages=c --without-headers --with-newlib --disable-libssp --with-gmp=$GCC_PREFIX --with-mpfr=$GCC_PREFIX --with-gmp=$GCC_PREFIX )
	
	echo "Compiling gcc..."
	(export LD_LIBRARY_PATH=$GCC_PREFIX/lib; make -j 8 -C $BASE_PATH/build/gcc-pre all LD_LIBRARY_PATH=$GCC_PREFIX/lib)
	
	echo "Install GCC"
	(export LD_LIBRARY_PATH=$GCC_PREFIX/lib; make -C $BASE_PATH/build/gcc-pre install)

elif [ "$1" == "build" ]; then
	down_extract $1
	
	echo "Configure gcc..."
	
	rm -rf $BASE_PATH/build/gcc/
	mkdir -p $BASE_PATH/build/gcc
	
	export PATH=$PATH:$BASE_PATH/toolchain/bin/
	
	(export LD_LIBRARY_PATH=$GCC_PREFIX/lib; cd $BASE_PATH/build/gcc; $BASE_PATH/src/gcc/gcc-4.8.0/configure --target=mips-elf --prefix=$GCC_PREFIX --enable-languages=c,c++ --without-headers --with-newlib --disable-libssp --with-gmp=$GCC_PREFIX --with-mpfr=$GCC_PREFIX --with-gmp=$GCC_PREFIX )
	
	echo "Compiling gcc..."
	(export LD_LIBRARY_PATH=$GCC_PREFIX/lib; make -j 8 -C $BASE_PATH/build/gcc all)
	
	echo "Install GCC"
	(export LD_LIBRARY_PATH=$GCC_PREFIX/lib; make -C $BASE_PATH/build/gcc install)
fi	

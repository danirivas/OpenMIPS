
volatile int a = 0x34;
volatile int b = 0xAB;

int main() {
	return (a << b) | (b >> a) + (a ^ b);
}


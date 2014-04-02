
#include <zlib.h>

unsigned int m_z = 0;
unsigned int m_w = 0;

unsigned int getrand() {
	m_z = 36969 * (m_z & 65535) + (m_z >> 16);
	m_w = 18000 * (m_w & 65535) + (m_w >> 16);
	return (m_z << 16) + m_w;
}

char inbuffer [4*1024];
char outbuffer[8*1024];

int main() {
	long size_outbuffer;
	long size_inbuffer = sizeof(inbuffer);

	int i;
	for (i = 0; i < size_inbuffer; i++)
		inbuffer[i] = getrand();

	int result = compress (outbuffer, &size_outbuffer, inbuffer, size_inbuffer);
}


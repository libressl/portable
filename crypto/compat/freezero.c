#include <string.h>
#include <stdlib.h>

void
freezero(void *ptr, size_t sz)
{
	/* This is legal. */
	if (ptr == NULL)
		return;

	explicit_bzero(ptr, sz);
	free(ptr);
}

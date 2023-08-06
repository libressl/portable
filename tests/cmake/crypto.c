#include <openssl/crypto.h>

int main(void) {
  OPENSSL_init_crypto(0, NULL);
  OPENSSL_cleanup();
  return 0;
}

/* shutdown.tos: MiNT Shutdown() -> ARAnyM NatFeats poweroff */
#include <mint/mintbind.h>
int main(void)
{
    Shutdown(0L);
    return 0;
}

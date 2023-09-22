#include "my_application.h"

#include <steam/steam_api.h>

int main(int argc, char** argv) {
  if (!SteamAPI_Init()) {
    return 0;
  }
  if (!SteamInput()->Init(false)) {
    return 0;
  }

  g_autoptr(MyApplication) app = my_application_new();
  int value = g_application_run(G_APPLICATION(app), argc, argv);

  SteamInput()->Shutdown();
  SteamAPI_Shutdown();

  return value;
}

#include "my_application.h"

#include <iostream>
#include <steam/steam_api.h>

int main(int argc, char** argv) {
  if (!SteamAPI_Init()) {
    std::cerr << "Failed to initialize Steam API." << std::endl;
    return 1;
  }
  if (!SteamInput()->Init(false)) {
    std::cerr << "Failed to initialize Steam Input." << std::endl;
    return 1;
  }

  g_autoptr(MyApplication) app = my_application_new();
  int value = g_application_run(G_APPLICATION(app), argc, argv);

  SteamInput()->Shutdown();
  SteamAPI_Shutdown();

  return value;
}

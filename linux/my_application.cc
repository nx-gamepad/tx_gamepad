#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#include <steam/steam_api.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

#include <thread>

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

void action_event_callback(SteamInputActionEvent_t *event) {
  InputDigitalActionHandle_t aButtonActionHandle = SteamInput()->GetDigitalActionHandle("turn_left");
  if (event->digitalAction.actionHandle == aButtonActionHandle && event->digitalAction.digitalActionData.bActive && event->digitalAction.digitalActionData.bState) {
    g_message("left on");
  } else if (event->digitalAction.actionHandle == aButtonActionHandle && event->digitalAction.digitalActionData.bActive && !event->digitalAction.digitalActionData.bState) {
    g_message("left off");
  }
  InputDigitalActionHandle_t bButtonActionHandle = SteamInput()->GetDigitalActionHandle("turn_right");
  if (event->digitalAction.actionHandle == bButtonActionHandle && event->digitalAction.digitalActionData.bActive && event->digitalAction.digitalActionData.bState) {
    g_message("right on");
  } else if (event->digitalAction.actionHandle == bButtonActionHandle && event->digitalAction.digitalActionData.bActive && !event->digitalAction.digitalActionData.bState) {
    g_message("right off");
  }
  InputDigitalActionHandle_t xButtonActionHandle = SteamInput()->GetDigitalActionHandle("forward_thrust");
  if (event->digitalAction.actionHandle == xButtonActionHandle && event->digitalAction.digitalActionData.bActive && event->digitalAction.digitalActionData.bState) {
    g_message("up on");
  } else if (event->digitalAction.actionHandle == xButtonActionHandle && event->digitalAction.digitalActionData.bActive && !event->digitalAction.digitalActionData.bState) {
    g_message("up off");
  }
  InputDigitalActionHandle_t yButtonActionHandle = SteamInput()->GetDigitalActionHandle("backward_thrust");
  if (event->digitalAction.actionHandle == yButtonActionHandle && event->digitalAction.digitalActionData.bActive && event->digitalAction.digitalActionData.bState) {
    g_message("down on");
  } else if (event->digitalAction.actionHandle == yButtonActionHandle && event->digitalAction.digitalActionData.bActive && !event->digitalAction.digitalActionData.bState) {
    g_message("down off");
  }
}

void steam_input_loop() {
  SteamInput()->EnableActionEventCallbacks(action_event_callback);
  while (true) SteamAPI_RunCallbacks();
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "tx_gamepad");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "tx_gamepad");
  }

  gtk_window_fullscreen(GTK_WINDOW(window));
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  std::thread steam_input_thread(steam_input_loop);
  steam_input_thread.detach();

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_NON_UNIQUE,
                                     nullptr));
}

{...}: {
  services.kanata = {
    enable = true;
    keyboards.keyboard = {
      devices = [
        "/dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd"
        "/dev/input/by-id/usb-SONiX_USB_DEVICE-event-if01"
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      ];
      config = ''
        (defsrc
          caps
        )
        (defalias
          caps (tap-hold 100 200 esc caps)
        )
        (deflayer base
          @caps
        )
      '';
    };
  };
}

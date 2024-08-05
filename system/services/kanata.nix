{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards.keyboard = {
      devices = [
        "/dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd"
        "/dev/input/by-id/usb-SONiX_USB_DEVICE-event-if01"
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

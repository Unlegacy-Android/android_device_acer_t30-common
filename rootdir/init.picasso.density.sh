#!/system/bin/sh

case "$(cat /proc/cmdline)" in
  *target_product=a51*)
    setprop ro.sf.lcd_density 160
    ;;
  *target_product=a70*)
    setprop ro.sf.lcd_density 240
    ;;
esac

done

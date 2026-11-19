#!/bin/sh

# رابط التحميل المباشر لملف ipk من مستودعك (استخدم رابط Raw)
PLUGIN_URL="https://github.com/Hamza2122/Mi-List-ENIGMA2/raw/refs/heads/main/cacheflush_2.2_all.ipk"
TMP_FILE="/tmp/cacheflush_2.2_all.ipk"

echo "جاري تحميل الإضافة..."
wget -q --no-check-certificate "$PLUGIN_URL" -O "$TMP_FILE"

if [ -f "$TMP_FILE" ]; then
    echo "جاري تثبيت الإضافة..."
    opkg update > /dev/null 2>&1
    opkg install --force-overwrite "$TMP_FILE"
    rm -f "$TMP_FILE"
    echo "تم التثبيت بنجاح! جاري إعادة تشغيل الواجهة..."
    killall -9 enigma2
else
    echo "فشل التحميل! تأكد من رابط الملف على GitHub."
    exit 1
fi

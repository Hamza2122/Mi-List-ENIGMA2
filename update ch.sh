#!/bin/sh

URL="https://github.com/Hamza2122/Mi-List-ENIGMA2/raw/refs/heads/main/channels_archive.tar.gz"
TMP_FILE="/tmp/channels_archive.tar.gz"

echo "-> 1. جاري تحميل ملف القنوات..."
wget --no-check-certificate -q -O "$TMP_FILE" "$URL"

if [ ! -s "$TMP_FILE" ]; then
    echo "خطأ: فشل تحميل الملف!"
    rm -f "$TMP_FILE"
    exit 1
fi

echo "-> 2. إيقاف واجهة Enigma2 لتحرير الذاكرة..."
init 4
sleep 3

echo "-> 3. حذف القنوات القديمة وتثبيت الجديدة..."
rm -rf /etc/enigma2/lamedb*
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/enigma2/blacklist
rm -rf /etc/enigma2/whitelist

tar -xzf "$TMP_FILE" -C /
rm -f "$TMP_FILE"

echo "-> 4. تشغيل واجهة Enigma2 بالأسماء الجديدة..."
init 3

echo "تم التحديث بنجاح!"
exit 0

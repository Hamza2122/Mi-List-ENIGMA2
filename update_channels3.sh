#!/bin/sh

CHANNELS_URL="https://github.com/Hamza2122/Mi-List-ENIGMA2/raw/refs/heads/main/channels_archive.tar.gz"
TMP_DIR="/tmp/channels_update"
ENIGMA_DIR="/etc/enigma2"
TUXBOX_DIR="/etc/tuxbox"

echo "بدء عملية تحديث القنوات..."

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "جاري تحميل ملف القنوات من السيرفر..."
wget -q --no-check-certificate -O "$TMP_DIR/channels_archive.tar.gz" "$CHANNELS_URL"

if [ ! -s "$TMP_DIR/channels_archive.tar.gz" ]; then
    echo "خطأ: فشل تحميل الملف أو الرابط غير صالح!"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "جاري فك الضغط..."
tar -xzf "$TMP_DIR/channels_archive.tar.gz" -C "$TMP_DIR"

EXTRACTED_DIR=$(find "$TMP_DIR" -name "lamedb" -exec dirname {} \; | head -n 1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "خطأ: لم يتم العثور على ملفات قنوات صالحة داخل الأرشيف!"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "جاري مسح القنوات القديمة..."
rm -f "$ENIGMA_DIR"/lamedb*
rm -f "$ENIGMA_DIR"/*.tv
rm -f "$ENIGMA_DIR"/*.radio
rm -f "$ENIGMA_DIR"/whitelist
rm -f "$ENIGMA_DIR"/blacklist

echo "جاري تثبيت القنوات الجديدة..."
cp -f "$EXTRACTED_DIR"/lamedb* "$ENIGMA_DIR"/ 2>/dev/null
cp -f "$EXTRACTED_DIR"/*.tv "$ENIGMA_DIR"/ 2>/dev/null
cp -f "$EXTRACTED_DIR"/*.radio "$ENIGMA_DIR"/ 2>/dev/null
cp -f "$EXTRACTED_DIR"/whitelist "$ENIGMA_DIR"/ 2>/dev/null
cp -f "$EXTRACTED_DIR"/blacklist "$ENIGMA_DIR"/ 2>/dev/null

if [ -f "$EXTRACTED_DIR/satellites.xml" ]; then
    echo "تحديث ملف الأقمار satellites.xml..."
    cp -f "$EXTRACTED_DIR/satellites.xml" "$TUXBOX_DIR/satellites.xml"
fi

rm -rf "$TMP_DIR"

echo "جاري إعادة تحميل قائمة القنوات..."
wget -qO- "http://127.0.0" > /dev/null

echo "تم تحديث القنوات بنجاح!"
exit 0

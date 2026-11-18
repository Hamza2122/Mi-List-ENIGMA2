#!/bin/bash

# ==========================================
# إعدادات الرابط (قم بتغيير الرابط أدناه لرابط ملف القنوات المضغوط zip أو tar.gz)
# مثال: رابط مباشر من GitHub (Raw) لملف قنوات بصيغة tar.gz أو zip
CHANNELS_URL="https://github.com/Hamza2122/Mi-List-ENIGMA2/raw/refs/heads/main/channels_backup.tar.gz"
# ==========================================

TMP_DIR="/tmp/channels_update"
ENIGMA_DIR="/etc/enigma2"
TUXBOX_DIR="/etc/tuxbox"

echo "بدء عملية تحديث القنوات..."

# 1. تنظيف وإنشاء مجلد العمل المؤقت
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# 2. تحميل ملف القنوات
echo "جاري تحميل ملف القنوات من السيرفر..."
wget -q --no-check-certificate -O "$TMP_DIR/channels_archive" "$CHANNELS_URL"

if [ ! -s "$TMP_DIR/channels_archive" ]; then
    echo "خطأ: فشل تحميل الملف أو الرابط غير صالح!"
    rm -rf "$TMP_DIR"
    exit 1
fi

# 3. فك الضغط (يدعم tar.gz و zip)
echo "جاري فك الضغط..."
if file "$TMP_DIR/channels_archive" | grep -q "gzip"; then
    tar -xzf "$TMP_DIR/channels_archive" -C "$TMP_DIR"
elif file "$TMP_DIR/channels_archive" | grep -q "Zip"; then
    unzip -q "$TMP_DIR/channels_archive" -d "$TMP_DIR"
else
    # محاولة فك الضغط الافتراضية في حال عدم توفر أداة file
    tar -xzf "$TMP_DIR/channels_archive" -C "$TMP_DIR" 2>/dev/null || unzip -q "$TMP_DIR/channels_archive" -d "$TMP_DIR" 2>/dev/null
fi

# 4. البحث عن مجلد القنوات المستخرج (الذي يحتوي على lamedb)
EXTRACTED_DIR=$(find "$TMP_DIR" -name "lamedb" -exec dirname {} \; | head -n 1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "خطأ: لم يتم العثور على ملفات قنوات صالحة داخل الأرشيف!"
    rm -rf "$TMP_DIR"
    exit 1
fi

# 5. حذف ملفات القنوات والباقات القديمة (مع الحفاظ على ملفات الإعدادات settings)
echo "جاري مسح القنوات القديمة..."
rm -f "$ENIGMA_DIR"/lamedb*
rm -f "$ENIGMA_DIR"/*.tv
rm -f "$ENIGMA_DIR"/*.radio
rm -f "$ENIGMA_DIR"/whitelist
rm -f "$ENIGMA_DIR"/blacklist

# 6. نسخ الملفات الجديدة
echo "جاري تثبيت القنوات الجديدة..."
cp -f "$EXTRACTED_DIR"/lamedb* "$ENIGMA_DIR"/ 2>/dev/null
cp -f "$EXTRACTED_DIR"/*.tv "$ENIGMA_DIR"/ 2>/dev/null
cp -f "$EXTRACTED_DIR"/*.radio "$ENIGMA_DIR"/ 2>/dev/null
cp -f "$EXTRACTED_DIR"/whitelist "$ENIGMA_DIR"/ 2>/dev/null
cp -f "$EXTRACTED_DIR"/blacklist "$ENIGMA_DIR"/ 2>/dev/null

# تحديث ملف الأقمار الصناعية satellites.xml إن وجد
if [ -f "$EXTRACTED_DIR/satellites.xml" ]; then
    echo "تحديث ملف الأقمار satellites.xml..."
    cp -f "$EXTRACTED_DIR/satellites.xml" "$TUXBOX_DIR/satellites.xml"
fi

# 7. تنظيف الملفات المؤقتة
rm -rf "$TMP_DIR"

# 8. إعادة تحميل القنوات في Enigma2 دون الحاجة لإعادة تشغيل الجهاز بالكامل
echo "جاري إعادة تحميل قائمة القنوات..."
wget -qO- "http://127.0.0" > /dev/null

echo "تم تحديث القنوات بنجاح!"
exit 0

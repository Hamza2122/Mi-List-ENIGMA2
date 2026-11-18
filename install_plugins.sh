#!/bin/sh

echo "=========================================="
echo "   جاري تحديث النظام وتثبيت الإضافات...   "
echo "=========================================="

# مجلد مؤقت لتحميل الملفات
TMP_DIR="/tmp/my_plugins"
mkdir -p $TMP_DIR
cd $TMP_DIR

# تحديث قائمة الحزم بدون ترقية النظام لتجنب التعارض
opkg update

# قائمة روابط الإضافات من مستودعك (استخدم روابط Raw المباشرة)
PLUGINS="
https://github.com/K3bOra/UltraAudio/raw/refs/heads/main/packages/Ultra_Audio_Final_V1.ipk
https://github.com/AMAJamry/AJPanel/raw/refs/heads/main/enigma2-plugin-extensions-ajpanel_v10.8.6_all.ipk
https://github.com/biko-73/Ncam_EMU/raw/refs/heads/main/enigma2-plugin-softcams-ncam_V15.8-r0_all.ipk
https://github.com/islam-2412/FuryBiss/raw/refs/heads/main/fury/furybiss_3.14_arm.ipk
https://live-feed.net/enigma2/enigma2-plugin-extensions-livefeed-0.4-r1-cortexa15hf-neon-vfpv4-py3.14.ipk
https://github.com/fairbird/RaedQuickSignal/archive/refs/heads/main.tar.gz
https://github.com/levi-45/Manager/archive/refs/heads/main.tar.gz
https://github.com/emilnabil/download-plugins/raw/refs/heads/main/EmilRemovePackage/EmilRemovePackage.tar.gz
https://github.com/emil237/quran/raw/refs/heads/main/enigma2-plugin-extensions-quran-karim_v2.2_all.ipk
"

# تحميل وتثبيت كل إضافة على حدة
for URL in $PLUGINS; do
    FILE_NAME=$(basename "$URL")
    echo "------------------------------------------"
    echo "جاري تحميل: $FILE_NAME"
    wget -q --no-check-certificate "$URL" -O "$TMP_DIR/$FILE_NAME"
    
    if [ -f "$TMP_DIR/$FILE_NAME" ]; then
        echo "جاري تثبيت: $FILE_NAME"
        # تثبيت الحزمة مع تجاهل طلبات إعادة التشغيل التلقائية إن وجدت
        opkg install --force-reinstall "$TMP_DIR/$FILE_NAME"
    else
        echo "فشل تحميل: $FILE_NAME"
    fi
done

# تنظيف الملفات المؤقتة
echo "------------------------------------------"
echo "جاري تنظيف الملفات المؤقتة..."
rm -rf $TMP_DIR

echo "=========================================="
echo " اكتمل التثبيت! سيتم إعادة تشغيل الواجهة الآن"
echo "=========================================="
sleep 3

# إعادة تشغيل واجهة Enigma2 مرة واحدة فقط لتفعيل جميع الإضافات
killall -9 enigma2

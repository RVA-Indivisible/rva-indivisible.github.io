# Would be nice if this worked:
# chromium --headless --window-size=1920,1080 --run-all-compositor-stages-before-draw --virtual-time-budget=9000 --incognito --dump-dom https://${CANVA_SRC_DOMAIN}/ | monolith - -I -b https://rvaindivisible.my.canva.site/ -o index.html

CANVA_SRC_DOMAIN=rvaindivisible.my.canva.site

wget -mpck --html-extension -e robots=off https://${CANVA_SRC_DOMAIN}/

mkdir ${CANVA_SRC_DOMAIN}/_assets/media/
mkdir ${CANVA_SRC_DOMAIN}/_assets/fonts/

for media_asset in $(grep -o '_assets\/media\/\w\+\.\w\+' ${CANVA_SRC_DOMAIN}/index.html 2>/dev/null | sort -u); do
    wget ${CANVA_SRC_DOMAIN}/${media_asset} -O ${CANVA_SRC_DOMAIN}/${media_asset}
done

for font_asset in $(grep -o '_assets\/fonts\/\w\+\.\w\+' ${CANVA_SRC_DOMAIN}/index.html 2>/dev/null | sort -u); do
    wget ${CANVA_SRC_DOMAIN}/${font_asset} -O ${CANVA_SRC_DOMAIN}/${font_asset}
done

# Clean up existing content in root
rm -fr index.html _assets/

# Move new content to root
mv ${CANVA_SRC_DOMAIN}/* .

# Remove leftover staging directory
rm -fr ${CANVA_SRC_DOMAIN}/

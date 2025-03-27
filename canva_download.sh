# Would be nice if this worked:
# chromium --headless --window-size=1920,1080 --run-all-compositor-stages-before-draw --virtual-time-budget=9000 --incognito --dump-dom https://rvaindivisible.my.canva.site/ | monolith - -I -b https://rvaindivisible.my.canva.site/ -o index.html

#wget -E -k -p https://rvaindivisible.my.canva.site/
wget -mpck --html-extension -e robots=off https://rvaindivisible.my.canva.site/

mkdir rvaindivisible.my.canva.site/_assets/media/
mkdir rvaindivisible.my.canva.site/_assets/fonts/

for media_asset in $(grep -o '_assets\/media\/\w\+\.\w\+' rvaindivisible.my.canva.site/index.html 2>/dev/null | sort -u); do
    wget rvaindivisible.my.canva.site/${media_asset} -O rvaindivisible.my.canva.site/${media_asset}
done

for font_asset in $(grep -o '_assets\/fonts\/\w\+\.\w\+' rvaindivisible.my.canva.site/index.html 2>/dev/null | sort -u); do
    wget rvaindivisible.my.canva.site/${font_asset} -O rvaindivisible.my.canva.site/${font_asset}
done

# GitHub pages didn't seem to like _assets
sed -i -e 's/_assets/assets/g' rvaindivisible.my.canva.site/index.html
mv rvaindivisible.my.canva.site/_assets rvaindivisible.my.canva.site/assets

# Clean up existing content in root
rm -fr index.html assets/

# Move new content to root
mv rvaindivisible.my.canva.site/* .

# Remove leftover staging directory
rm -fr rvaindivisible.my.canva.site/

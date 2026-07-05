const sharp = require('sharp');
const path = require('path');

const src = '/Users/rofiqulummagmail.com/Downloads/financely_icon.svg';
const out = path.join(__dirname, '..', 'assets', 'icon', 'app_icon.png');

(async () => {
  // Render the white glyph at high resolution, then center it on a 1024x1024
  // transparent canvas with padding so the adaptive-icon mask never crops it.
  const glyph = await sharp(src, { density: 512 })
    .resize(620, 620, {
      fit: 'contain',
      background: { r: 0, g: 0, b: 0, alpha: 0 },
    })
    .png()
    .toBuffer();

  await sharp({
    create: {
      width: 1024,
      height: 1024,
      channels: 4,
      background: { r: 0, g: 0, b: 0, alpha: 0 },
    },
  })
    .composite([{ input: glyph, gravity: 'center' }])
    .png()
    .toFile(out);

  console.log('wrote', out);
})();

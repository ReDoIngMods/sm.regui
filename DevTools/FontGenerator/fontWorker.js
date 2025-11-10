// fontWorker.js
const { workerData, parentPort } = require('worker_threads');
const fs = require('fs');
const path = require('path');
const { createCanvas } = require('canvas');
const opentype = require('opentype.js');

const fontPath = workerData;
const fontSize = 128;
const fontSpacing = 0;

const characters = [];
for (let c = 32; c <= 126; c++) characters.push(String.fromCharCode(c));
characters.push('\uFFFD');

const rotations = [];
for (let i = 0; i <= 360; i += 15) rotations.push(i);

function loadFontAsync(fontPath) {
    return new Promise((resolve, reject) => {
        opentype.load(fontPath, (err, font) => {
            if (err) reject(err);
            else resolve(font);
        });
    });
}

function nextPowerOfTwo(x) {
    return Math.pow(2, Math.ceil(Math.log2(x)));
}

(async () => {
    parentPort.postMessage(`Worker started for font: ${fontPath}`);
    const font = await loadFontAsync(fontPath);
    const scale = fontSize / font.unitsPerEm;

    let maxTop = Number.NEGATIVE_INFINITY;
    let minBottom = Number.POSITIVE_INFINITY;
    for (const glyphChar of characters) {
        const bbox = font.charToGlyph(glyphChar).getBoundingBox();
        if (bbox.y2 > maxTop) maxTop = bbox.y2;
        if (bbox.y1 < minBottom) minBottom = bbox.y1;
    }

    const maxTopPx = maxTop * scale;
    const minBottomPx = minBottom * scale;
    const extraPadding = 16;
    const glyphHeightUpright = maxTopPx - minBottomPx;
    const glyphMaxSide = Math.ceil(Math.sqrt(2 * Math.pow(glyphHeightUpright, 2)));
    const cellHeight = glyphMaxSide + extraPadding;
    const cellWidth = 128;
    const rotationCount = rotations.length;

    const gridCols = Math.ceil(Math.sqrt(rotationCount));
    const gridRows = Math.ceil(rotationCount / gridCols);
    const cellSize = Math.max(cellWidth, cellHeight);
    const baseCanvasSize = cellSize * Math.max(gridCols, gridRows);
    const canvasSize = nextPowerOfTwo(baseCanvasSize);

    const outputDir = `./Output/${path.parse(fontPath).name}`;
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

    const canvas = createCanvas(canvasSize, canvasSize);
    const ctx = canvas.getContext('2d');

    const glyphs = {};

    for (const glyphChar of characters) {
        const charCode = glyphChar.charCodeAt(0);
        const glyph = font.charToGlyph(glyphChar);
        const bbox = glyph.getBoundingBox();
        const glyphWidthPx = (bbox.x2 - bbox.x1) * scale;
        const glyphHeightPx = (bbox.y2 - bbox.y1) * scale;
        const baselineY = cellSize - maxTopPx;

        glyphs[glyphChar] = { advanceWidth: glyph.advanceWidth * scale, rotations: [] };
        ctx.clearRect(0, 0, canvasSize, canvasSize);

        for (let r = 0; r < rotationCount; r++) {
            const rotationRad = (rotations[r] * Math.PI) / 180;
            const col = r % gridCols;
            const row = Math.floor(r / gridCols);
            const cellX = col * cellSize;
            const cellY = row * cellSize;
            const centerX = cellX + cellSize / 2;
            const centerY = cellY + baselineY - ((glyphHeightPx / 2) + bbox.y1 * scale);

            ctx.save();
            ctx.translate(centerX, centerY);
            ctx.rotate(rotationRad);
            ctx.translate(-centerX, -centerY);

            const posX = cellX + (cellSize - glyphWidthPx) / 2 - bbox.x1 * scale;
            const path = glyph.getPath(posX, baselineY + cellY, fontSize);
            path.fill = 'white';
            path.draw(ctx);
            ctx.restore();

            glyphs[glyphChar].rotations.push([cellX, cellY]);
        }

        const glyphImagePath = path.join(outputDir, `${charCode}.png`);
        fs.writeFileSync(glyphImagePath, canvas.toBuffer('image/png'));
    }

    const metadata = {
        fontSize,
        rotations,
        cellSize,
        lineHeight: (font.ascender * scale) + (-font.descender * scale),
        fontSpacing
    };
    fs.writeFileSync(path.join(outputDir, 'data.json'), JSON.stringify({ metadata, glyphs }, null, 4));
    parentPort.postMessage(`Worker finished font: ${fontPath}`);
})();

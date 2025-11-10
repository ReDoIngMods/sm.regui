const fs = require('fs');
const path = require('path');
const { createCanvas } = require('canvas');
const opentype = require('opentype.js');

const fontSize = 121;
const fontSpacing = 0;
const fontPath = './font.ttf';

// Define all characters to process here
const characters = [];
for (let c = 32; c <= 126; c++) {
    characters.push(String.fromCharCode(c));
}

characters.push('\uFFFD');

let rotations = [];
for (let i = 0; i <= 360; i += 15) {
    rotations.push(i);
}

opentype.load(fontPath, (err, font) => {
    if (err) {
        console.error('Error loading font:', err);
        return;
    }

    const scale = fontSize / font.unitsPerEm;

    // Find global maxTop and minBottom for consistent vertical alignment
    let maxTop = Number.NEGATIVE_INFINITY;
    let minBottom = Number.POSITIVE_INFINITY;

    for (const glyphChar of characters) {
        const glyph = font.charToGlyph(glyphChar);
        const bbox = glyph.getBoundingBox();
        if (bbox.y2 > maxTop) maxTop = bbox.y2;
        if (bbox.y1 < minBottom) minBottom = bbox.y1;
    }

    const maxTopPx = maxTop * scale;
    const minBottomPx = minBottom * scale;

    const extraPadding = 16; // Optional padding around glyphs
    const glyphHeightUpright = maxTopPx - minBottomPx;

    // Original cell size calculations (for upright glyph)
    const glyphMaxSide = Math.ceil(Math.sqrt(2 * Math.pow(glyphHeightUpright, 2)));
    const cellHeight = glyphMaxSide + extraPadding;
    const cellWidth = 128;  // original width you used per rotated glyph cell

    const rotationCount = rotations.length;

    // Grid dimensions for arranging rotations
    const gridCols = Math.ceil(Math.sqrt(rotationCount));
    const gridRows = Math.ceil(rotationCount / gridCols);

    // Square cell size (to hold each rotated glyph)
    const cellSize = Math.max(cellWidth, cellHeight);

    // Total canvas size (square to hold all rotated glyphs in grid)
    const baseCanvasSize = cellSize * Math.max(gridCols, gridRows);

    function nextPowerOfTwo(x) {
        return Math.pow(2, Math.ceil(Math.log2(x)));
    }

    const canvasSize = nextPowerOfTwo(baseCanvasSize);

    const outputDir = './Output';
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir);

    const glyphs = {};

    for (const glyphChar of characters) {
        const charCode = glyphChar.charCodeAt(0);

        const glyph = font.charToGlyph(glyphChar);
        const bbox = glyph.getBoundingBox();

        const glyphWidthPx = (bbox.x2 - bbox.x1) * scale;
        const glyphHeightPx = (bbox.y2 - bbox.y1) * scale;

        const canvas = createCanvas(canvasSize, canvasSize);
        const ctx = canvas.getContext('2d');

        // Calculate baseline Y inside each cell to align glyphs vertically
        // baselineY is relative to each cell's top-left
        const baselineY = cellSize - maxTopPx;

        glyphs[glyphChar] = {
            advanceWidth: glyph.advanceWidth * scale,
            rotations: []
        };

        for (let r = 0; r < rotationCount; r++) {
            const rotationDeg = rotations[r];
            const rotationRad = (rotationDeg * Math.PI) / 180;

            // Position in grid
            const col = r % gridCols;
            const row = Math.floor(r / gridCols);

            // Top-left corner of this cell
            const cellX = col * cellSize;
            const cellY = row * cellSize;

            // Center point inside cell for rotation (adjust vertical center based on glyph)
            const centerX = cellX + cellSize / 2;
            const centerY = cellY + baselineY - ((glyphHeightPx / 2) + bbox.y1 * scale);

            ctx.save();
            ctx.translate(centerX, centerY);
            ctx.rotate(rotationRad);
            ctx.translate(-centerX, -centerY);

            // Position glyph inside cell (horizontally centered)
            const posX = cellX + (cellSize - glyphWidthPx) / 2 - bbox.x1 * scale;
            const path = glyph.getPath(posX, baselineY + cellY, fontSize);
            path.fill = 'white';
            path.draw(ctx);

            ctx.restore();

            glyphs[glyphChar].rotations.push([cellX, cellY]);
        }

        // Save the square image for this glyph with grid of rotations
        const glyphImagePath = path.join(outputDir, `${charCode}.png`);
        fs.writeFileSync(glyphImagePath, canvas.toBuffer('image/png'));

        console.log(`Saved glyph image: ${glyphImagePath}`);
    }

    // Save metadata
    const metadata = {
        fontSize,
        rotations,
        cellSize,
        lineHeight: (font.ascender * scale) + (-font.descender * scale),
        fontSpacing: fontSpacing
    };

    const jsonPath = path.join(outputDir, 'data.json');
    fs.writeFileSync(jsonPath, JSON.stringify({ metadata, glyphs }, null, 4));
    console.log(`Saved glyph metadata: ${jsonPath}`);
});

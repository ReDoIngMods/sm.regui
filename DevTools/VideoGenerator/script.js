import { exec } from "child_process"
import fs from "fs/promises"
import fsSync from "fs"
import path from "path"
import crypto from "crypto"
import pLimit from "p-limit"
import sharp from "sharp"

const limit = pLimit(48)

const inputFile = "input.mp4"
const rawFramesDir = "RawFrames"
const compressedDir = "CompressedFrames"
const outputDir = "Output"
const mapFile = path.join(outputDir, "data.json")

const HASH_WIDTH = 64
const HASH_HEIGHT = 64

function execPromise(cmd) {
    return new Promise((resolve, reject) => {
        exec(cmd, (error, stdout, stderr) => {
            if (error) reject(stderr)
            else resolve(stdout)
        })
    })
}

async function extractFrames() {
    const cmd = `ffmpeg -hwaccel cuda -i "${inputFile}" -vf "fps=20,scale=-1:480" -c:v png "${rawFramesDir}/%d.png" -hide_banner -loglevel error`

    console.log("🎬 Running FFmpeg...")
    await execPromise(cmd)
}

async function compressFrames() {
    const files = (await fs.readdir(rawFramesDir)).filter(f => f.endsWith(".png")).sort((a, b) => Number(a.split(".")[0]) - Number(b.split(".")[0]))
    await Promise.all(files.map(file => limit(async () => {
        const inputPath = path.join(rawFramesDir, file)
        const outputFileName = file.replace(/\.png$/, ".webp")
        const outputPath = path.join(compressedDir, outputFileName)

        try {
            await sharp(inputPath).webp({ quality: 25, effort: 6 }).toFile(outputPath)
            console.log(`🔹 Compressed: ${file} → ${outputFileName}`)
        } catch (err) {
            console.error(`❌ WEBP compression failed for ${file}`, err)
        }
    })))
}

async function getImageHash(filePath) {
    const buffer = await sharp(filePath).resize(HASH_WIDTH, HASH_HEIGHT).removeAlpha().raw().toBuffer()

    return crypto.createHash("md5").update(buffer).digest("hex")
}

async function deduplicateFrames() {
    const files = (await fs.readdir(compressedDir)).filter(f => f.endsWith(".webp")).sort((a, b) => Number(a.split(".")[0]) - Number(b.split(".")[0]))

    const hashToFrame = new Map()
    const mapping = []

    await Promise.all(files.map(file => limit(async () => {
        const fileNumber = path.basename(file, ".webp")
        const filePath = path.join(compressedDir, file)
        const hash = await getImageHash(filePath)

        if (hashToFrame.has(hash)) {
            mapping[Number(fileNumber) - 1] = Number(hashToFrame.get(hash))
            return
        }

        hashToFrame.set(hash, fileNumber)
        mapping[Number(fileNumber) - 1] = Number(fileNumber)

        const destPath = path.join(outputDir, file)
        await fs.copyFile(filePath, destPath)
        console.log(`✨ Unique frame saved: ${file}`)
    })))

    return mapping
}

async function safeRemove(dirPath) {
    try {
        await fs.rm(dirPath, {force: true, recursive: true, maxRetries: 5, retryDelay: 10})
    } catch (err) {
        console.log(`❌Failed to remove ${dirPath}`)
    }
}

async function cleanUp() {
    await safeRemove(rawFramesDir)
    await safeRemove(compressedDir)
}

async function ensureDir(dirPath) {
    if(!fsSync.existsSync(dirPath)) {
        await fs.mkdir(dirPath)
    }
}

await ensureDir(rawFramesDir)
await ensureDir(compressedDir)
await ensureDir(outputDir)

console.time("🏁 Total time")

console.log("🎬 Extracting frames...")
await extractFrames()

console.log("🗜️ Compressing frames...")
await compressFrames()

console.log("🧠 Deduplicating frames...")
const mapping = await deduplicateFrames()

console.log(`📄 Writing frame map to ${mapFile}...`)
await fs.writeFile(mapFile, JSON.stringify(mapping, null, 0), "ascii")

console.log("🧹 Cleaning up...")
await cleanUp()

console.log("✅ Done!")
console.timeEnd("🏁 Total time")
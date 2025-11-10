// main.js
const fs = require('fs');
const path = require('path');
const { Worker } = require('worker_threads');

const fontsDir = './Fonts';
const files = fs.readdirSync(fontsDir);

function runFontWorker(fontPath) {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./fontWorker.js', {
            workerData: fontPath
        });

        worker.on('message', msg => console.log(msg));
        worker.on('error', reject);
        worker.on('exit', code => {
            if (code !== 0) reject(new Error(`Worker stopped with exit code ${code}`));
            else resolve();
        });
    });
}

(async () => {
    const promises = files.map(file => runFontWorker(path.join(fontsDir, file)));
    await Promise.all(promises);
    console.log('All fonts processed.');
})();

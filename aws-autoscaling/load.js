const url = process.env.URL || 'http://autoscaling-alb-2032883031.us-east-1.elb.amazonaws.com/';
const concurrency = 200;
const durationMs = 10 * 60 * 1000;

const end = Date.now() + durationMs;
let ok = 0, fail = 0;

async function worker() {
  while (Date.now() < end) {
    try {
      const r = await fetch(url, { signal: AbortSignal.timeout(10000) });
      r.ok ? ok++ : fail++;
    } catch { fail++; }
  }
}

setInterval(() => console.log(`ok=${ok} fail=${fail}`), 5000).unref();
Promise.all(Array.from({ length: concurrency }, worker)).then(() => console.log(`done ok=${ok} fail=${fail}`));
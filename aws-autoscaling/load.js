const url = 'http://autoscaling-alb-2032883031.us-east-1.elb.amazonaws.com/';
const numberOfRequests = 10;
const delayMs = 1000;

const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function checkEndpoint() {
  try {
    const response = await fetch(url, { signal: AbortSignal.timeout(10000) });
    console.log(`Status: ${response.status}`);
  } catch (error) {
    console.error(`Request failed: ${error.message}`);
  }
}

async function runChecks() {
  for (let i = 0; i < numberOfRequests; i++) {
    await checkEndpoint();
    if (i < numberOfRequests - 1) {
      await delay(delayMs);
    }
  }
  console.log('Endpoint checks finished.');
}

runChecks();

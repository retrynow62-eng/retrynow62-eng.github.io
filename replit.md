# Replit setup

## Run command

The `Start application` workflow runs:

```sh
PORT=5000 USE_REDIS=false ILA_IP_LOCATION_DB=geo-whois-asn ILA_AUTO_UPDATE=false NODE_ENV=production node --no-node-snapshot main.js
```

The project uses Node.js 22 because the `isolated-vm` dependency does not compile against the imported Node.js 20 runtime.

## Required service

The application requires `MONGODB_URL` to contain a complete MongoDB connection URI beginning with `mongodb://` or `mongodb+srv://`. Store it as a Replit Secret. Redis, Meilisearch, and S3 are optional and are disabled in the current workflow.

The frontend repository is downloaded into `frontend/` on first startup. Replit imports do not preserve nested `.git` metadata, so startup uses `frontend/package.json` to detect an already-downloaded frontend.

## Current status

The workflow and dependencies are configured, but the app cannot serve requests until a valid `MONGODB_URL` is provided. Once the secret is corrected, restart `Start application` and verify the preview at `/`.
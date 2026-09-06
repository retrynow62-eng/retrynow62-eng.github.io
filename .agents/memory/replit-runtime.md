---
name: Replit runtime constraints
description: Non-obvious runtime and startup constraints discovered while bringing the imported Node application onto Replit.
---

The imported application needs Node.js 22 rather than Node.js 20 because its pinned `isolated-vm` dependency does not compile against the available Node 20 runtime. Its IP geolocation dependency's default MaxMind redistribution download can arrive as an invalid archive in this environment; the `geo-whois-asn` country dataset is a reachable alternative when only country lookup is required.

**Why:** These constraints are environmental and are not obvious from the application's source or package manifest alone.

**How to apply:** Preserve the Node 22 runtime and the alternate country-dataset startup setting when restarting this imported project, unless the dependency or network behavior changes.
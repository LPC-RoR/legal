// app/javascript/controllers/index.js
// Arranca Stimulus y carga en caliente todos los controladores del directorio.

// app/javascript/controllers/index.js
// MODO MANUAL: sin eagerLoadControllersFrom.
// Si algún lugar importa "controllers", no fallará.
export { application } from "./application"
console.log("[stimulus] modo manual (sin auto-loader)");

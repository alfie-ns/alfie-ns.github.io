const fs = require("fs");
const filename = "assets/js/main.min.js";
const script = fs.readFileSync(filename, 'utf-8');
const banner = fs.readFileSync("_includes/copyright.js", 'utf-8');
const githubBanner = "/* Hosted for free on GitHub Pages - https://github.com/alfie-ns/alfie-ns.github.io */\n";

if (script.slice(0, 3) !== "/*!") {
  fs.writeFileSync(filename, githubBanner + banner + script);
}

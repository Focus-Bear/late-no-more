const exec = require("@applescript/exec.js")
module.exports = async function say(dialog) {
  const SCRIPT= `say "${dialog}"`
  await exec(SCRIPT)
};

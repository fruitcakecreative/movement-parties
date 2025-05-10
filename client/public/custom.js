function runCustomScript() {
  console.log("ready");
}

if (document.readyState !== 'loading') {
  runCustomScript();
} else {
  document.addEventListener('DOMContentLoaded', runCustomScript);
}

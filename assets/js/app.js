// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import * as LocalStateStore from "./hooks/local_state_store";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let Hooks = {};

Hooks.LocalStateStore = LocalStateStore.hooks;

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());
window.addEventListener("phx:copy", (event) => {
  // let text = event.target.value; // Alternatively use an element or data tag!
  let url = new URL(window.location.href);
  let text = url.origin + url.pathname;
  console.log(event);
  navigator.clipboard.writeText(text).then(() => {
    const oldText = event.target.innerText;
    event.target.innerText = "Copied!";
    event.target.disabled = true;
    event.target.style.opacity = 0.5;
    event.target.style.cursor = "default";

    setTimeout(() => {
      event.target.innerText = oldText;
      event.target.disabled = false;
      event.target.style.opacity = 1;
      event.target.style.cursor = "pointer";
    }, 1000);
    console.log("All done!"); // Or a nice tooltip or something.
  });
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

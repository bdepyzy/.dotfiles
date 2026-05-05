import { spawn } from "node:child_process";
import { appendFileSync, rmSync, writeFileSync } from "node:fs";

const logFile = "/home/bdepyzy/.local/state/opencode-cs2-permission.log";
const stateFile = "/tmp/cs2-permission-pending";
let lastPlay = 0;

function log(message) {
  appendFileSync(logFile, `${new Date().toISOString()} ${message}\n`);
}

function signalWaybar() {
  spawn("pkill", ["-RTMIN+12", "waybar"], {
    detached: true,
    stdio: "ignore",
  }).unref();
}

function setPending() {
  writeFileSync(stateFile, String(Date.now()));
  signalWaybar();
}

function clearPending() {
  rmSync(stateFile, { force: true });
  signalWaybar();
}

function play() {
  const now = Date.now();
  if (now - lastPlay < 500) return;
  lastPlay = now;
  log("playing permission reaction");
  const env = { ...process.env };
  delete env.CS2_REACTION_SOUND;
  spawn("/home/bdepyzy/.local/bin/cs2-reaction", ["--notify", "OpenCode permission", "Approval requested"], {
    detached: true,
    env,
    stdio: "ignore",
  }).unref();
}

export const CS2PermissionReaction = async () => {
  log("js plugin loaded");
  return {
    async event({ event }) {
      if (event?.type === "permission.asked") {
        log("permission.asked event");
        setPending();
        play();
      } else if (event?.type === "permission.replied") {
        log("permission.replied event");
        clearPending();
      }
    },
    async "permission.ask"() {
      log("permission.ask hook");
      setPending();
      play();
    },
  };
};

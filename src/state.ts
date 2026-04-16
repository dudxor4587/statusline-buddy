import { readFile, writeFile, mkdir } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";

const STATE_DIR = join(homedir(), ".claude-buddy");
const STATE_FILE = join(STATE_DIR, "profile.json");

export interface BuddyState {
  name: string;
  art: string | null;
  speech: string | null;
}

function defaultState(): BuddyState {
  return { name: "Buddy", art: null, speech: null };
}

export async function loadState(): Promise<BuddyState> {
  try {
    const data = await readFile(STATE_FILE, "utf-8");
    return { ...defaultState(), ...JSON.parse(data) };
  } catch {
    return defaultState();
  }
}

export async function saveState(state: BuddyState): Promise<void> {
  await mkdir(STATE_DIR, { recursive: true });
  await writeFile(STATE_FILE, JSON.stringify(state, null, 2), "utf-8");
}

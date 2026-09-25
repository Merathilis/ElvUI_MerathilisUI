---
name: release
description: Walk through publishing a new MerathilisUI version together with the user - changelog review, pre-release checks, release commit, merge to main + tag + push, and prepping the next version's changelog. Use when the user wants to release/publish a new version (e.g. "/release", "/release 7.36", "lass uns releasen").
---

# Release workflow

Run this **together with the user**, phase by phase. Talk to the user in German; everything written to the repo (commit messages, changelog text) is English.

**Stop after every phase**, show a short summary of what was done/found and wait for the user's OK before the next phase. Never skip a phase silently - if one is not needed, say so.

Argument: optional target version (e.g. `7.36`). Without it, derive it (see Phase 0) and confirm with the user.

## Background

- Version lives in `ElvUI_MerathilisUI/ElvUI_MerathilisUI.toc` as `## X-Version: x.yz` (read by `Init.lua` into `MER.Version`). `## Version: @project-version@` is filled by the packager - never touch it.
- Changelog key = version × 100 (`7.36` → `MER.Changelog[736]`).
- In-progress changelog: `ElvUI_MerathilisUI/Core/Changelog/<version>.lua` (+ root `CHANGELOG.md`, which mirrors it as `-   [Fix]/[New]/[Improvement]: text` bullets under `### Changes`, order FIXES, NEW, IMPROVEMENTS). Both files must always contain the same entries.
- Pushing a tag triggers `.github/workflows/release.yml` (BigWigs packager → CurseForge, Wago, GitHub release, Discord notification). The tag name is the version, e.g. `7.36`.
- Branch flow: work happens on `development`; releases are `development` merged into `main`, tag on the merge commit. `beta`/`ptr` are **not** part of the release.
- Commit prefixes: `📖 DOC:`, `🚀 RELEASE:` etc. No mention of source addons in commit messages.
- `gh` and `luacheck` are not installed on the user's machine.

## Phase 0 - Preconditions

1. `git status` must be clean and the current branch `development`. If not, stop and ask.
2. `git fetch origin --tags`, then make sure `development` is not behind `origin/development` (and `main` not behind `origin/main`). If behind, ask before pulling.
3. Last release = `git describe --tags --abbrev=0 origin/main` (or highest numeric tag). New version = the in-progress changelog file's version (highest `Core/Changelog/*.lua` outside `Previous/`), which should be last tag + 0.01. If the argument, the file and the tag disagree, stop and clarify.
4. Verify the in-progress file really defines `MER.Changelog[<new × 100>]` with `RELEASE_DATE = "TBD"` (it has once been a stale rename of the previous release).

## Phase 1 - Changelog review

1. List all commits since the last tag: `git log <lastTag>..development --no-merges --format="%h %s"`.
2. For each commit decide whether it is user-visible. Skip: `📖 DOC` commits, locale syncs, refactors without behaviour change, test/CI/meta commits, and anything whose effect was reverted later in the range. Look at the diff (`git show --stat`, then the relevant parts) when the subject alone is unclear.
3. Compare against the entries already in `<version>.lua` and `CHANGELOG.md`:
   - list user-visible commits **without** an entry and draft an entry for each, in the existing style (`"Area: Module - what changed, from the player's point of view."`, category FIXES / NEW / IMPROVEMENTS),
   - flag entries that no longer match the final state of the code (feature changed again later, option renamed, …),
   - flag differences between the `.lua` file and `CHANGELOG.md`.
4. Present the drafts to the user, apply what they approve to **both** files, and commit: `📖 DOC: Update <version> changelog`.

## Phase 2 - Pre-release checks

Report findings; fix only after the user agrees.

- **Load order**: every file referenced in the `.toc` and in `Load_*.xml` files under `ElvUI_MerathilisUI/` exists (case-sensitive path match), and no new `.lua` file added since the last tag is left unreferenced.
- **Locales**: keys added to `Locales/enUS.lua` since the last tag exist in every other locale file (`L["key"] = true` is enough).
- **Profile migrations**: in `Core/Update.lua`, no `profileVersion < x` block uses a version **higher** than the one being released (it would never run until a later release). Blocks for exactly this version are expected.
- **Leftovers**: grep the diff since the last tag for debug prints / temporary code (`print(`, `DevTool`, `--TODO`/`FIXME` added in this range, `debug = true`).
- **Syntax**: if `luac`/`luacheck` is available use it; otherwise mention that this check was skipped.
- **Game/ElvUI versions**: show the current `## Interface` and `## X-ElvUIVersion` from the `.toc` and ask whether either needs bumping (the user knows the current patch/ElvUI version).

## Phase 3 - Release commit

1. `<version>.lua`: `RELEASE_DATE = "TBD"` → today as `"DD.MM.YYYY"`.
2. `.toc`: `## X-Version: <version>` (plus `## Interface` / `## X-ElvUIVersion` if agreed in Phase 2).
3. `README.md`: the `Version-x.yz` badge → new version; the `ElvUI-x.yz` badge → `X-ElvUIVersion`.
4. Show the diff, then commit: `🚀 RELEASE: <version>`.

## Phase 4 - Publish (outward-facing)

**Ask for an explicit "yes" before running any of these.** Summarise exactly what will be pushed (version, number of commits since the last tag).

```bash
git checkout main
git merge development          # no fast-forward flag needed; keep the existing merge style
git tag -a <version> -m "<version>"
git push origin main
git push origin <version>
git checkout development
```

- If the merge conflicts, stop and resolve together - never force anything.
- After pushing, point the user to the Actions run (`https://github.com/Merathilis/ElvUI_MerathilisUI/actions`). Offer to check it in the browser pane; do not poll.
- If the workflow fails: do **not** delete/re-push the tag on your own - discuss with the user first (the upload may already be partially public).

## Phase 5 - Prep next version

Next version = released + 0.01 (e.g. 7.36 → 7.37, 7.39 → 7.40).

1. `git mv Core/Changelog/<version>.lua Core/Changelog/Previous/<version>.lua`.
2. Keep the 5 newest files in `Previous/`: `git rm` the oldest ones.
3. Create `Core/Changelog/<next>.lua` from `_template.lua` with `MER.Changelog[<next × 100>]`, `RELEASE_DATE = "TBD"`, empty tables.
4. Update `Core/Changelog/Load_Changelog.xml`: drop removed files, point to `Previous\<version>.lua`, add `<next>.lua` last.
5. Reset `CHANGELOG.md` to:
   ```markdown
   ### Changes

   -
   ```
6. Commit `📖 DOC: prep changelogs`, then ask before `git push origin development`.

Finish with a short recap: version released, tag, links (Actions, CurseForge, Wago), and the new in-progress version.

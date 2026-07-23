# Contributing

Thank you for your interest in CWR-CE, the community continuation of the
Poseidon engine (Arma: Cold War Assault Remastered) source release. This
repository now also carries the Apple Silicon / iOS port (native Metal
renderer, macOS/iOS build support) contributed from the CWR-arm64 fork.

## Repository Model

This is a community fork, not the original Bohemia Interactive release, and
is not affiliated with or endorsed by Bohemia Interactive:

- Pull requests are welcome for fixes, portability work, tooling, tests, and
  documentation — including Apple Silicon/Metal/iOS-specific work.
- Ideas and feature proposals are welcome in issues or discussions.
- This is a community project, not a formal one — response times and review
  turnaround aren't guaranteed.
- Changes must respect the license terms in `LICENSE`, including the
  additional Section 7 terms.
- For bugs in official Bohemia Interactive builds distributed on Steam, use
  the upstream repository instead: <https://github.com/BohemiaInteractive/CWR>.

## Branches And The Official Track

- `main` is the primary development branch. All community work lands here — bug
  fixes, ports, tooling, tests, renderer work, and larger feature efforts.
- `official` is a curated, conservative branch intended as a candidate base for a
  future official Bohemia Interactive Steam patch. It deliberately accepts only:
  - bug and crash fixes, and
  - quality-of-life improvements.

  It does not take new features, renderer changes, or gameplay/logic changes —
  anything that would alter the game's official behaviour stays on `main`.
- Maintainers decide which changes are ported to `official` and apply the `port`
  label; contributors do not need to request or assign it. Target `main` as usual.

## Issues

Use GitHub issues for bugs, build problems, ideas, feature requests, and
coordination work. Use the issue template when opening a report.

- Include your platform (macOS/iOS/Linux/Windows), build preset or game
  version/commit, CMake/Clang versions where relevant, reproduction steps,
  expected behavior, and actual behavior.
- Do not report security vulnerabilities in public issues.

## Pull Requests

Before opening one:

- keep the change focused and reviewable — its parts should reasonably belong
  together, and unrelated work should go in separate pull requests. A wider change
  that cannot be split cleanly can stay in one pull request as long as it is
  organized into focused, self-contained commits so a reviewer can follow it step
  by step,
- describe the problem being solved,
- include tests or manual verification notes when practical,
- follow the existing code style and testing conventions — see
  [`tests/README.md`](tests/README.md) and the CI workflow
  (`.github/workflows/build.yml`) for what's expected to pass,
- avoid committing game data, proprietary assets, generated dependency trees,
  or local build outputs — retail/demo game data questions are out of scope
  here; see the [README](README.md#getting-game-data-to-run-what-you-build)
  for where to get game data,
- make sure modified versions remain clearly marked as modified and are not
  presented as an official Bohemia Interactive product.

AI-assisted contributions are welcome. If you use an AI assistant:

- you are the author, not the tooling — commit metadata must credit you and no
  tool you used (an LLM or otherwise): no `Co-Authored-By` for a tool, no
  "Generated with …" trailer, and no AI mention in the commit message,
- review and tidy the diff before submitting — strip over-commenting (comments
  that restate the code, narrate history, or cite tickets/PRs), dead code, and
  unrelated churn, and match the surrounding style and comment density,
- hold everything you post to the same standard as the code — commit messages,
  documentation, and GitHub text (pull request and issue descriptions, comments,
  reviews) should be clean, focused, and free of AI boilerplate,
- do not run AI review bots or tools against this repository directly; their
  output tends to be noisy. Run them on your own fork first and submit only the
  reviewed result.

## Community Development

Ports, experiments, tooling, source cleanup, bug fixes, and long-running
feature work can be coordinated directly in this repository. Larger ideas are
easiest to review when they start as an issue or discussion before a large
pull request. You can also share ideas and community development work with
the community release authors at <https://github.com/ofpisnotdead-com/CWR-CE>.

## Licensing Of Contributions

The project source is licensed under the GNU General Public License v3.0 or
later, with additional Section 7 terms in `LICENSE`.

By contributing source changes here, you agree that your contribution is
provided under the same GPL-3.0-or-later license terms, including the
additional Section 7 terms in `LICENSE`.

When working with forks or modified versions:

- source changes are governed by the same GPL-3.0-or-later terms, including
  the Section 7 additional terms,
- you do not grant or imply any right to use "ARMA" or any other Bohemia
  Interactive trademarks,
- modified versions must be marked as modified and must not be presented as
  the original program.

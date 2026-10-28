# Jenkinsfile for Zed

A [Zed](https://zed.dev) extension that adds first-class support for
**Jenkinsfiles** (Groovy Pipeline scripts) and Groovy files.

## Features

- **Syntax highlighting** — full Groovy grammar ([tree-sitter-groovy] by
  [murtaza64](https://github.com/murtaza64)) plus Jenkins-specific rules:
  declarative sections (`pipeline`, `agent`, `stages`, `stage`, `steps`,
  `post`, `when`, …), special variables (`env`, `params`, `currentBuild`),
  string interpolation, and GroovyDoc comments.
- **Bash injection** — shell commands inside `sh '...'` / `sh """..."""` steps
  are highlighted with Zed's built-in bash grammar.
- **Outline / symbols** — jump between `stage('...')` blocks, functions and
  classes from the outline panel or `go to symbol` (cmd-shift-o).
- **Bracket matching & rainbow brackets**, auto-indent for closures, and
  auto-closing brackets/quotes.
- **Comment toggling** with `//` (cmd-/).
- **Formatter integration** (via [npm-groovy-lint], see below).
- **Optional language server** for completions/hints (opt-in, see below).

## `Jenkinsfile.*` variants (`Jenkinsfile.sit`, `Jenkinsfile.uat`, …)

Per-environment pipelines are usually named `Jenkinsfile.<env>`. Zed's
extension `path_suffixes` only matches exact suffixes — glob patterns are not
supported there — so this extension handles them in two ways:

1. **Automatic (content-based, best-effort).** Zed checks the start of the
   file against `first_line_pattern`. A `Jenkinsfile.sit` is picked up as a
   Jenkinsfile when one of these appears at the start of a line within the
   first ~256 characters: `pipeline {`, `node {` / `node(`, `stage(`,
   `properties {`, `library …`, `@Library(…)`, `def call(…)` or a groovy
   shebang. Files that begin with long banner comments may slip through.

2. **Explicit (recommended, always works).** Map the glob yourself in Zed
   settings — either globally or per project in `.zed/settings.json`:

   ```json
   {
     "file_types": {
       "Jenkinsfile": ["Jenkinsfile.*", "jenkinsfile.*"]
     }
   }
   ```

   `file_types` supports globs (unlike `path_suffixes`), so any
   `Jenkinsfile.<anything>` is opened with the full Jenkinsfile tooling
   regardless of its content.

## Installing (development)

From this repository:

```sh
zed extension install --path .
```

Or inside Zed: open the command palette → `extensions: Install Dev Extension`
and select this directory.

> Building a dev extension requires [rustup] with the `wasm32-wasip1` target.
> Zed installs the target automatically via rustup, but rustup itself must be
> present.

## Formatter

The extension doesn't ship a formatter binary; the recommended setup is
[npm-groovy-lint] (CodeNarc-based, understands Jenkinsfiles via its
`recommended-jenkinsfile` ruleset). Requires Node.js ≥ 22.13 and Java 17.

```sh
npm install -g npm-groovy-lint
```

Then add to your Zed `settings.json`:

```json
{
  "languages": {
    "Jenkinsfile": {
      "formatter": {
        "external": {
          "command": "npm-groovy-lint",
          "arguments": ["--format", "-", "--loglevel", "ERROR"]
        }
      },
      "format_on_save": "on"
    }
  }
}
```

## Language server (completions, hints)

Zed requires an LSP server for completions, hovers, and diagnostics — there is
no Jenkins/Groovy language server with prebuilt releases today, so this one is
**opt-in** and never auto-installs anything.

### Enabling it

```json
{
  "languages": {
    "Jenkinsfile": {
      "language_servers": ["groovy-language-server", "..."]
    }
  }
}
```

Once enabled, the extension looks for a binary in this order:

1. Whatever you configure under `lsp.groovy-language-server.binary` (below).
2. A `groovy-language-server` executable on your `PATH`.

### Pointing it at a server

The maintained open-source server is
[GroovyLanguageServer/groovy-language-server] (Java). Build the "all" jar with
Maven (`mvn package`) and register it:

```json
{
  "lsp": {
    "groovy-language-server": {
      "binary": {
        "path": "/usr/bin/java",
        "arguments": ["-jar", "/path/to/groovy-language-server-all.jar"]
      },
      "settings": { /* forwarded as workspace/configuration */ }
    }
  }
}
```

### Disabling it

Nothing to do — the server only starts when you enable it as shown above.
(On Zed versions without `opt_in_languages` support, you can silence it with
`"language_servers": ["!groovy-language-server"]`.)

## Notes & limitations

- `.groovy` files are matched by this extension too, so plain Groovy sources
  get the Jenkins-oriented highlighting. If that bothers you, remove `"groovy"`
  from `path_suffixes` in `languages/jenkinsfile/config.toml` in your local
  copy.
- Files without a matching suffix (including `Jenkinsfile.*` variants) are
  detected when a pipeline keyword appears near the top of the file — see
  [the `Jenkinsfile.*` section](#jenkinsfile-variants-jenkinsfilesit-jenkinsfileuat-)
- The grammar treats pipeline steps as plain function calls; completion comes
  only from the language server when enabled.

## License

MIT — see [LICENSE](LICENSE). Grammar by [murtaza64] (MIT),
`npm-groovy-lint` by [nvuillam](https://github.com/nvuillam) (MIT).

[tree-sitter-groovy]: https://github.com/murtaza64/tree-sitter-groovy
[npm-groovy-lint]: https://github.com/nvuillam/npm-groovy-lint
[GroovyLanguageServer/groovy-language-server]: https://github.com/GroovyLanguageServer/groovy-language-server
[rustup]: https://rustup.rs

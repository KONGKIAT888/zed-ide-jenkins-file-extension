use zed_extension_api::{
    self as zed, settings::LspSettings, Command, LanguageServerId, Result, Worktree,
};

const LANGUAGE_SERVER_ID: &str = "groovy-language-server";

struct JenkinsfileExtension;

impl zed::Extension for JenkinsfileExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &Worktree,
    ) -> Result<Command> {
        if language_server_id.as_ref() != LANGUAGE_SERVER_ID {
            return Err(format!(
                "unknown language server: {}",
                language_server_id.as_ref()
            ));
        }

        // Users can point the server at any executable (e.g. a JVM-based
        // language server jar launched through `java -jar`) via the `lsp`
        // section of their settings.
        let settings = LspSettings::for_worktree(LANGUAGE_SERVER_ID, worktree)?;

        if let Some(binary) = settings.binary {
            return Ok(Command {
                command: binary.path.unwrap_or_else(|| LANGUAGE_SERVER_ID.to_string()),
                args: binary.arguments.unwrap_or_default(),
                env: binary.env.unwrap_or_default().into_iter().collect(),
            });
        }

        // Fall back to a `groovy-language-server` executable available on PATH.
        Ok(Command {
            command: LANGUAGE_SERVER_ID.to_string(),
            args: Vec::new(),
            env: Default::default(),
        })
    }

    fn language_server_initialization_options(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &Worktree,
    ) -> Result<Option<zed::serde_json::Value>> {
        Ok(
            LspSettings::for_worktree(language_server_id.as_ref(), worktree)?.initialization_options,
        )
    }

    fn language_server_workspace_configuration(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &Worktree,
    ) -> Result<Option<zed::serde_json::Value>> {
        Ok(LspSettings::for_worktree(language_server_id.as_ref(), worktree)?.settings)
    }
}

zed::register_extension!(JenkinsfileExtension);

use std::sync::OnceLock;

#[allow(unused)]
static INIT: OnceLock<()> = OnceLock::new();

/// Initialize the tracing subscriber once.
///
/// Safe to call multiple times — only the first call takes effect.
#[allow(unused)]
pub(crate) fn init() {
    INIT.get_or_init(|| {
        tracing_subscriber::fmt()
            .with_test_writer()
            .with_env_filter(
                tracing_subscriber::EnvFilter::builder()
                    .with_default_directive(tracing::Level::INFO.into())
                    .from_env_lossy(),
            )
            .with_target(true)
            .init();
    });
}

#[cfg(test)]
#[ctor::ctor(unsafe)]
fn init_for_tests() {
    init();
}

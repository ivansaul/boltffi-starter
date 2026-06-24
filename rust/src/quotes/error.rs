#[boltffi::data]
#[derive(Debug, thiserror::Error)]
pub enum QuotesError {
    #[error("no quote available")]
    Unavailable,

    #[error("invalid response")]
    InvalidResponse,

    #[error("unknown error: {0}")]
    Unknown(String),
}
